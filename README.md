# K8S Vagrant personal practive

这是我个人摸索出来在 Mac Desktory 上用 Vagrant 配合 VitualBox 运行一个 K8S 集群的沉淀, 欢迎使用和提出意见

本人使用 kubeadm 运行 k8s 1.17 (全部改换国内源) 无碍

## Preparation

本文档假设你本机已经安装了一下工具

- `vagrant`: 管理虚拟机的工具,你可以预先下载好 box 镜像,能省去不少时间
- `make`: 本练习使用 makefile 作为所有脚本运行是入口, 请确保安装
- `kubectl`: k8s 的命令行工具, 用来操作本地或者远程集群用的

以下工具不是创建集群必须的工具
- `helm@3`: k8s 的依赖管理工具, 我个人玩的一些例子里有用到

## Quick Start

### 创建集群

```sh
make up
```

运行完成后,你就可以操作集群了,虚拟机有相关问题需要调整,你可以运行 `vagrant ssh [master|node]` 到虚拟机终端中调试

不需要，可以使用下面命令销毁虚拟机

```
make destroy
```

### 创建jenkins ci with 私有 Docker Registry

```
make jenkinsci
```

完成后,需要等待一段时间 jenkins pod 启动下载相关插件(确保你的网络可以正常下载jenkins.io的插件)

然后访问 <http://jenkins.192-168-33-10.nip.io> 可以访问jinkins(初始账号密码是 admin:adminPass, 而 Docker Registry 的密码是 admin:adminDocker)

不需要，可以使用下面命令销毁资源

```
make unjenkinsci
```

## 心路历程
