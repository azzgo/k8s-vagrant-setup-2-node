#!/bin/bash

CURRENT_SCRIPT_PATH=$(dirname $0)

echo "Make sure your cluster is clean..."

helm uninstall jenkins
kubectl delete -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/jenkins/rabc.yaml

helm uninstall docker-registry
kubectl delete secret docker-registry-tls
kubectl delete secret docker-registry-ca

helm uninstall nginx-ingress

echo "Deleted, run \"helm ls\" ing..."

helm ls
