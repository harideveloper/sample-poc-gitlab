#!/bin/bash

export APPLICATION="${POC_APPLICATION:-enablers}"

export PROJECT_ID='sandbox-db-enablers'
export VPC="vpc-gke-${APPLICATION}"
export REGION="europe-west2"

export GKE1="gke1-${APPLICATION}"
export GKE1_LOCATION="${REGION}-a"
export GKE1_CTX="gke_${PROJECT_ID}_${GKE1_LOCATION}_${GKE1}"
export GKE1_KUBECONFIG="../gke1_kubeconfig_$APPLICATION.secret"

export GKE2="gke2-${APPLICATION}"
export GKE2_LOCATION="${REGION}-b"
export GKE2_CTX="gke_${PROJECT_ID}_${GKE2_LOCATION}_${GKE2}"
export GKE2_KUBECONFIG="../gke2_kubeconfig_$APPLICATION.secret"

export GKE_CHANNEL="REGULAR"
export ASM_CHANNEL="regular"
export CNI_ENABLED="true"
export ASM_GATEWAYS_NAMESPACE="asm-gateways"

export TIMEOUT='30m'
