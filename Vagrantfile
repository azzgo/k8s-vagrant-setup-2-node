# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/xenial64"
    master.vm.network "private_network", ip: "192.168.33.10"
    master.vm.hostname = "master"
    master.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
      # 使用宿主机 DNS 寻找,不然访问境外如 Github 等网站 dns 会返回一个美国地址,导致超时
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end
    
    master.vm.provision "file", source: "./templates/kubeadm.yaml", destination: "$HOME/kubeadm.yaml"
    master.vm.provision "shell", path: "./scripts/up/ubuntu_basic-install.deb.sh"
    master.vm.provision "shell", path: "./scripts/up/setup_master.sh"
  end

  config.vm.define "node" do |node|
    node.vm.box = "ubuntu/xenial64"
    node.vm.network "private_network", ip: "192.168.33.11"
    node.vm.hostname = "node"
    node.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
      # 使用宿主机 DNS 寻找,不然访问境外如 Github 等网站 dns 会返回一个美国地址,导致超时
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    node.vm.provision "shell", path: "./scripts/up/ubuntu_basic-install.deb.sh"
    node.vm.provision "shell", path: "./scripts/up/setup_node.sh"
    node.vm.provision "shell", inline: "sh /vagrant/kubeadm_join_cmd.sh"
  end

end
