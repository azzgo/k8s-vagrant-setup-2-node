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
      v.cpus = 3
    end
    master.vm.provision "file", source: "./kubeadm.yaml", destination: "$HOME/kubeadm.yaml"
    master.vm.provision "shell", path: "ubuntu_basic-install.deb.sh"
    master.vm.provision "shell", path: "setup_master.sh"
  end

  config.vm.define "node" do |node|
    node.vm.box = "ubuntu/xenial64"
    node.vm.network "private_network", ip: "192.168.33.11"
    node.vm.hostname = "node"
    node.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 3
    end
    node.vm.provision "shell", path: "ubuntu_basic-install.deb.sh"
    node.vm.provision "shell", inline: "sh /vagrant/kubeadm_join_cmd.sh"
    # node.vm.provision "shell", inline: "route add 10.96.0.1 gw 192.168.33.10"
  end

end
