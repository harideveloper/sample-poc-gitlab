#!/bin/bash
set -e

source _init-vars.sh

SECTION='asm-gateways'
pushd "$SECTION"
envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
popd

SECTION='asm'
pushd "$SECTION"
envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
popd

SECTION='hub-mesh'
pushd "$SECTION"
envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
popd

SECTION='vpc-gke'
pushd "$SECTION"
envsubst < variables.tf.tmpl > variables.tf
envsubst < provider.tf.tmpl > provider.tf
popd
