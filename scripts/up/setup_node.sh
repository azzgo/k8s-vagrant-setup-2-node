#!/bin/bash

# 下载必须的Images
declare -a images=("k8s.gcr.io/pause:3.1" "k8s.gcr.io/kube-proxy:v1.17.0" "k8s.gcr.io/coredns:1.6.5")
for origin_image in "${images[@]}"
do
image=$(echo $origin_image | sed s/k8s.gcr.io/gcr.azk8s.cn\\/google_containers/)
docker pull $image
docker tag $image $(echo $image | sed s/gcr.azk8s.cn\\/google_containers/k8s.gcr.io/)
docker rmi $image
done

