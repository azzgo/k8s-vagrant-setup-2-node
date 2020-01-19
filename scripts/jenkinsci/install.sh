#!/bin/bash

CURRENT_SCRIPT_PATH=$(dirname $0)

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add nginx-stable https://helm.nginx.com/stable

helm repo update

# 安装 Jenkins
helm install jenkins stable/jenkins -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/jenkins/values.yaml 

# 安装 nginx-ingress
# Node: 请注意此条命令有可能失败,因为默认 kube-apiserver 不允许绑定宿主机的 80 和 443 端口
helm install nginx-ingress nginx-stable/nginx-ingress -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/nginx/values.yaml

# 安装 docker-registry
## 准备证书
sh $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/docker-registry/certs/create-tls.sh

## 准备用户
helm install docker-registry stable/docker-registry -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/docker-registry/values.yaml

kubectl create secret docker-registry docker-registry-login --docker-server=docker-registry.192-168-33-10.nip.io --docker-email=email --docker-username=admin --docker-password=adminDocker


## 创建 fox web ingress 服务
kubectl create -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/fox-dev.ingress.yaml
