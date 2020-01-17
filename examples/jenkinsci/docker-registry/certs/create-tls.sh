#!/bin/sh

CURRENT_SCRIPT_PATH=$(dirname $0)

# 生成私钥
openssl genrsa -out $CURRENT_SCRIPT_PATH/docker-registry.key 2048

# 生成证书请求
openssl req -new -key $CURRENT_SCRIPT_PATH/docker-registry.key -out $CURRENT_SCRIPT_PATH/docker-registry.csr -config $CURRENT_SCRIPT_PATH/ssl.cnf

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: docker-registry
spec:
  groups:
  - system:authenticated
  request: $(cat ${CURRENT_SCRIPT_PATH}/docker-registry.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

# 批准证书
kubectl certificate approve docker-registry

# 下载证书
kubectl get csr docker-registry -o jsonpath="{.status.certificate}" | base64 -d > $CURRENT_SCRIPT_PATH/docker-registry.crt

# 注册 tls secret
kubectl create secret tls docker-registry-tls --cert $CURRENT_SCRIPT_PATH/docker-registry.crt --key $CURRENT_SCRIPT_PATH/docker-registry.key
