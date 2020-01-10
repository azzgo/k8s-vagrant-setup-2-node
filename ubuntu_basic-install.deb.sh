#!/bin/sh
USER="vagrant"

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
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubeadm=1.17.0-00 kubelet=1.17.0-00

# 关闭 SWAP
sudo swapoff -a
