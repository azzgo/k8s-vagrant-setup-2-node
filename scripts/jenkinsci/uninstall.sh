#!/bin/bash

CURRENT_SCRIPT_PATH=$(dirname $0)

echo "Make sure your cluster is clean..."

helm uninstall jenkins

helm uninstall docker-registry

helm uninstall nginx-ingress


CURRENT_SCRIPT_PATH=$(dirname $0)

kubectl delete -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/jenkins/rabc.yaml
kubectl delete secret docker-registry-tls

echo "Deleted, run \"helm ls\" ing..."

helm ls
