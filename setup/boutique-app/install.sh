#!/bin/bash
###
###  Usage:
###   ./install.sh
###     - or -
###   POC_APPLICATION='lev' ./install.sh
###

set -e

source _init-vars.sh

# Bash Colours
HL="\e[1m"  # Highlight
YW="\e[93m" # Yellow
NC="\e[0m"  # Nocolor

echo -e "
###
###  DEPLOYING application with ID: ${YW}${APPLICATION}${NC}...
###
###  (You can also use the \`POC_APPLICATION\` env to target a specific application: export POC_APPLICATION='lev')
###
"

sleep 3

echo '
###
###  STEP 1. VPC-GKE
###
'

SECTION='vpc-gke'
pushd "$SECTION"

envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
terraform init -backend-config="bucket=enablers-gcs-tf-state"  -backend-config="prefix=terraform/online-boutique/${APPLICATION}/${SECTION}" -reconfigure
terraform apply -auto-approve
popd


echo '
###
###  STEP 2. HUB-MESH
###
'
SECTION='hub-mesh'
pushd "$SECTION"

envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
terraform init -backend-config="bucket=enablers-gcs-tf-state"  -backend-config="prefix=terraform/online-boutique/${APPLICATION}/${SECTION}" -reconfigure
terraform apply -auto-approve

gcloud --project=${PROJECT_ID} container clusters get-credentials ${GKE1} --zone ${GKE1_LOCATION}
kubectl wait --for=condition=established crd controlplanerevisions.mesh.cloud.google.com --timeout=${TIMEOUT}

gcloud --project=${PROJECT_ID} container clusters get-credentials ${GKE2} --zone ${GKE2_LOCATION}
kubectl wait --for=condition=established crd controlplanerevisions.mesh.cloud.google.com --timeout=${TIMEOUT}
popd  


echo '
###
###  STEP 3. ASM
###
'

SECTION='asm'
pushd "$SECTION"

envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
terraform init -backend-config="bucket=enablers-gcs-tf-state"  -backend-config="prefix=terraform/online-boutique/${APPLICATION}/${SECTION}" -reconfigure
terraform apply -auto-approve

export ASM_LABEL=$(terraform output asm_label | tr -d '"')

echo 'Waiting for ASM to come online...'

kubectl --context=${GKE1_CTX} wait --for=condition=ProvisioningFinished controlplanerevision ${ASM_LABEL} -n istio-system --timeout=${TIMEOUT}
kubectl --context=${GKE2_CTX} wait --for=condition=ProvisioningFinished controlplanerevision ${ASM_LABEL} -n istio-system --timeout=${TIMEOUT}

kubectl get ns --context=${GKE1_CTX}
kubectl get ns --context=${GKE2_CTX}

kubectl describe controlplanerevision ${ASM_LABEL} -n istio-system --context=${GKE1_CTX}
kubectl describe controlplanerevision ${ASM_LABEL} -n istio-system --context=${GKE2_CTX}

kubectl describe secret ${GKE2}-secret-kubeconfig -n istio-system --context=${GKE1_CTX}
kubectl describe secret ${GKE1}-secret-kubeconfig -n istio-system --context=${GKE2_CTX}

popd


echo '
###
### STEP 4. ASM-GATEWAYS
###
'

SECTION='asm-gateways'
pushd "$SECTION"

envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
terraform init -backend-config="bucket=enablers-gcs-tf-state"  -backend-config="prefix=terraform/online-boutique/${APPLICATION}/${SECTION}" -reconfigure
terraform apply -auto-approve

kubectl --context=${GKE1_CTX} -n ${ASM_GATEWAYS_NAMESPACE} wait --for=condition=available --timeout=${TIMEOUT} deployment asm-ingressgateway
kubectl --context=${GKE2_CTX} -n ${ASM_GATEWAYS_NAMESPACE} wait --for=condition=available --timeout=${TIMEOUT} deployment asm-ingressgateway

kubectl --context=${GKE1_CTX} -n ${ASM_GATEWAYS_NAMESPACE} get deploy
kubectl --context=${GKE2_CTX} -n ${ASM_GATEWAYS_NAMESPACE} get deploy

kubectl --context=${GKE1_CTX} -n ${ASM_GATEWAYS_NAMESPACE} get service
kubectl --context=${GKE2_CTX} -n ${ASM_GATEWAYS_NAMESPACE} get service

popd


echo '
###
### STEP 5. DEPLOYING APPLICATION
###
'

pushd online-boutique

#### Create Namespace
kubectl --context=${GKE1_CTX} apply -f namespace-online-boutique.yaml
kubectl --context=${GKE2_CTX} apply -f namespace-online-boutique.yaml

#### Deploy Kubernetes Manifests
kubectl --context=${GKE1_CTX} -n online-boutique apply -f online-boutique/release/kubernetes-manifests.yaml
kubectl --context=${GKE2_CTX} -n online-boutique apply -f online-boutique/release/kubernetes-manifests.yaml

# Deleting some services comes here (disabled for now)
: '
kubectl --context=${GKE1_CTX} -n online-boutique delete deployment adservice
kubectl --context=${GKE1_CTX} -n online-boutique delete deployment cartservice
kubectl --context=${GKE1_CTX} -n online-boutique delete deployment redis-cart
kubectl --context=${GKE1_CTX} -n online-boutique delete deployment currencyservice
kubectl --context=${GKE1_CTX} -n online-boutique delete deployment emailservice

kubectl --context=${GKE2_CTX} -n online-boutique delete deployment paymentservice
kubectl --context=${GKE2_CTX} -n online-boutique delete deployment productcatalogservice
kubectl --context=${GKE2_CTX} -n online-boutique delete deployment shippingservice
kubectl --context=${GKE2_CTX} -n online-boutique delete deployment checkoutservice
kubectl --context=${GKE2_CTX} -n online-boutique delete deployment recommendationservice
'

echo "Waiting for the deployments in the online-boutique namespace"

kubectl --context=${GKE1_CTX} -n online-boutique wait --for=condition=available --timeout=${TIMEOUT} --all deployments
kubectl --context=${GKE2_CTX} -n online-boutique wait --for=condition=available --timeout=${TIMEOUT} --all deployments

#### Deploy ASM Manifests
kubectl --context=${GKE1_CTX} -n online-boutique apply -f asm-manifests.yaml
kubectl --context=${GKE2_CTX} -n online-boutique apply -f asm-manifests.yaml

GKE1_ASM_INGRESS_IP=$(kubectl --context=${GKE1_CTX} --namespace ${ASM_GATEWAYS_NAMESPACE} get svc asm-ingressgateway -o jsonpath={.status.loadBalancer.ingress..ip})
GKE2_ASM_INGRESS_IP=$(kubectl --context=${GKE2_CTX} --namespace ${ASM_GATEWAYS_NAMESPACE} get svc asm-ingressgateway -o jsonpath={.status.loadBalancer.ingress..ip})

echo "GKE1 ASM Ingressgateway IP is ${GKE1_ASM_INGRESS_IP} accessible at http://${GKE1_ASM_INGRESS_IP}"
echo "GKE2 ASM Ingressgateway IP is ${GKE2_ASM_INGRESS_IP} accessible at http://${GKE2_ASM_INGRESS_IP}"
