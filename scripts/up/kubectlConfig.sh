#!/bin/sh

KUBERNETES_PUBLIC_ADDRESS=192.168.33.10

kubectl config set-cluster vagrant \
  --certificate-authority=.credentials/ca.crt \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

kubectl config set-credentials vagrant-user \
  --client-key .credentials/client-key-data.pem\
  --client-certificate .credentials/client-certificate-data.pem\
  --embed-certs

kubectl config set-context vagrant \
  --cluster=vagrant \
  --user=vagrant-user

kubectl config use-context vagrant
