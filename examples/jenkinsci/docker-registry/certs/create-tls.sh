#!/bin/bash

CURRENT_SCRIPT_PATH=$(dirname $0)

# 生成私钥
openssl genrsa -out $CURRENT_SCRIPT_PATH/docker-registry.key 2048

# 生成CA私钥，和证书
openssl genrsa -out $CURRENT_SCRIPT_PATH/ca.key 2048

openssl req -x509 -new -nodes -key $CURRENT_SCRIPT_PATH/ca.key \
-subj "/CN=Master" -days 10000 \
-out $CURRENT_SCRIPT_PATH/ca.crt

# 生成证书请求
openssl req -new -key $CURRENT_SCRIPT_PATH/docker-registry.key -out $CURRENT_SCRIPT_PATH/docker-registry.csr -config $CURRENT_SCRIPT_PATH/ssl.cnf


#生成证书
openssl x509 -req -in docker-registry.csr \
-CA $CURRENT_SCRIPT_PATH/ca.crt -CAkey $CURRENT_SCRIPT_PATH/ca.key \
-CAcreateserial -out docker-registry.crt -days 10000 \
-extensions v3_ext -extfile $CURRENT_SCRIPT_PATH/ssl.cnf

# 注册 tls secret
kubectl create secret tls docker-registry-tls --cert $CURRENT_SCRIPT_PATH/docker-registry.crt --key $CURRENT_SCRIPT_PATH/docker-registry.key

# 注册 CA 证书secret
kubectl create secret generic docker-registry-ca --from-file $CURRENT_SCRIPT_PATH/ca.crt
