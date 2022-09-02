#!/bin/bash
###
###  Usage:
###   ./destroy.sh
###     - or -
###   POC_APPLICATION='lev' ./destroy.sh
###

set -e

source _init-vars.sh

# Bash Colours
HL="\e[1m"  # Highlight
YW="\e[93m" # Yellow
RD="\e[31m" # Red
NC="\e[0m"  # Nocolor

echo -e "
###
###  ${RD}DESTROYING${NC} application with ID: ${YW}${APPLICATION}${NC}...
###
###  (You can also use the \`POC_APPLICATION\` env to target a specific application: export POC_APPLICATION='lev')
###
"

sleep 3

echo '
###
### STEP 1. Destroying ASM-GATEWAYS
###
'

SECTION='asm-gateways'
pushd "$SECTION"
envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
terraform init -backend-config="bucket=enablers-gcs-tf-state"  -backend-config="prefix=terraform/online-boutique/${APPLICATION}/${SECTION}" -reconfigure
terraform destroy -auto-approve
popd

echo '
###
###  STEP 2. Destroying ASM
###
'
SECTION='asm'
pushd "$SECTION"
envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
terraform init -backend-config="bucket=enablers-gcs-tf-state"  -backend-config="prefix=terraform/online-boutique/${APPLICATION}/${SECTION}" -reconfigure
terraform destroy -auto-approve
popd

echo '
###
###  STEP 3. Destroying HUB-MESH
###
'
SECTION='hub-mesh'
pushd "$SECTION"
envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
terraform init -backend-config="bucket=enablers-gcs-tf-state"  -backend-config="prefix=terraform/online-boutique/${APPLICATION}/${SECTION}" -reconfigure
terraform destroy -auto-approve
popd

echo '
###
###  STEP 4. Destroying VPC-GKE
###
'
SECTION='vpc-gke'
pushd "$SECTION"
envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
terraform init -backend-config="bucket=enablers-gcs-tf-state"  -backend-config="prefix=terraform/online-boutique/${APPLICATION}/${SECTION}" -reconfigure
terraform destroy -target='module.gke1' -target='module.gke2' -auto-approve
popd

