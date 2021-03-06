#!/bin/bash

CURRENT_SCRIPT_PATH=$(dirname $0)

echo "Make sure your cluster is clean..."

helm uninstall jenkins
kubectl delete secret jenkins-credentials-xml
kubectl delete -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/jenkins/rabc.yaml

helm uninstall docker-registry
kubectl delete secret docker-registry-tls
kubectl delete secret docker-registry-ca
kubectl delete secret docker-registry-login

kubectl delete -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/fox-dev.ingress.yaml
helm uninstall nginx-ingress


echo "Deleted, run \"helm ls\" ing..."

helm ls
