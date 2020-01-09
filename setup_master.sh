#!/bin/sh


kubeadm config images pull --image-repository "gcr.azk8s.cn/google_containers"
kubeadm init --config /home/vagrant/kubeadm.yaml

sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -Rf /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubeadm token create --print-join-command > /vagrant/kubeadm_join_cmd.sh
chmod +x /vagrant/kubeadm_join_cmd.sh

# 单机节点
kubectl taint nodes --all node-role.kubernetes.io/master-

