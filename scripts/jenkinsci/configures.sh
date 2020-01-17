#/bin/sh

# 增加 Jenkins CI Role 确保其有 Service, Pod, Deployments 的操作权限

CURRENT_SCRIPT_PATH=$(dirname $0)

kubectl apply -f $CURRENT_SCRIPT_PATH/../../examples/jenkinsci/jenkins/rabc.yaml
