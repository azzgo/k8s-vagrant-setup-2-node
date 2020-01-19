#!/bin/bash
USER="vagrant"
K8S_VERSION=1.17.0-00

set -xe
 
## 替换apt源到国内
sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

# K8S 阿里源

curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

apt-get update

# 安装 docker
curl -fsSL https://get.docker.com | sudo sh -s -- --mirror Aliyun
usermod -aG docker $USER
mkdir -p /etc/docker

tee /etc/docker/daemon.json <<-'EOF'
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "registry-mirrors": ["https://t9ab0rkd.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker

# 安装 kubeadm
apt-get install -y kubeadm=${K8S_VERSION} kubelet=${K8S_VERSION}

# 关闭 SWAP
sudo swapoff -a


## 更改 kubelet 默认监听网卡
## Issue: https://github.com/kubernetes/kubernetes/issues/60835
NODE_IP=$(ip addr show enp0s8 | grep inet | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}/" | tr -d '/')

echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=${NODE_IP}\"" >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload
systemctl restart kubelet


## 拷贝 CA 证书，后面的 Examples 有用
cp /vagrant/examples/jenkinsci/docker-registry/certs/ca.crt /usr/local/share/ca-certificates/kubernetes.crt
update-ca-certificates
