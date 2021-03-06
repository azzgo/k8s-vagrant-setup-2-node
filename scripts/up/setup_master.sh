#!/bin/bash

# 替代 kubeadm config images pull 为国内拉取,tag改换
for image in $(kubeadm config images list | sed s/k8s.gcr.io/gcr.azk8s.cn\\/google_containers/g | grep ^gcr.azk8s.cn)
do
docker pull $image
docker tag $image $(echo $image | sed s/gcr.azk8s.cn\\/google_containers/k8s.gcr.io/)
docker rmi $image
done
# 
kubeadm init --config /home/vagrant/kubeadm.yaml

sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -Rf /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

## 设置 coredns 默认 dns 到阿里dns
kubectl apply -f /vagrant/templates/coredns.yaml

## 安装网络插件
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

## 安装 local-hostpath-provider
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# 生成添加节点指令
kubeadm token create --print-join-command > /vagrant/kubeadm_join_cmd.sh
chmod +x /vagrant/kubeadm_join_cmd.sh

# 拷贝证书
mkdir /vagrant/.credentials
cp -f /etc/kubernetes/pki/ca.crt /vagrant/.credentials
cat /etc/kubernetes/admin.conf | grep client-certificate-data: | sed s/.*client-certificate-data:[[:space:]]*// | base64 -d > /vagrant/.credentials/client-certificate-data.pem
cat /etc/kubernetes/admin.conf | grep client-key-data: | sed s/.*client-key-data:[[:space:]]*// | base64 -d > /vagrant/.credentials/client-key-data.pem

# 单机节点
## kubectl taint nodes --all node-role.kubernetes.io/master-

## 为 kube-apiserver 更改运行运行的 Node Port 端口范围
sed -i 's/^\(\([: space :]*\)- kube-apiserver\)$/\1\n\2-\ --service-node-port-range=1-65535/' /etc/kubernetes/manifests/kube-apiserver.yaml
