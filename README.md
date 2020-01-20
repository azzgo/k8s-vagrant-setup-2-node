# K8S via Vagrant

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

效果如下:

![image](https://user-images.githubusercontent.com/5636512/72678878-ee1c2d80-3ae4-11ea-9c05-916d772fec58.png)

![image](https://user-images.githubusercontent.com/5636512/72678872-da70c700-3ae4-11ea-9464-361fa98fee67.png)


关联应用Example Repo: 
- 前端：https://github.com/azzgo/fox-web
- 后端：https://github.com/azzgo/fox-api

使用下面命令一键创建 cicd
```
make jenkinsci
```

完成后,需要等待一段时间 jenkins pod 启动下载相关插件(确保你的网络可以正常下载jenkins.io的插件)

然后访问 <http://jenkins.192-168-33-10.nip.io> 可以访问jinkins(初始账号密码是 admin:adminPass, 而 Docker Registry 的密码是 admin:adminDocker)

应用目前由以下环节
- Dev: <http://fox-dev.192-168-33-10.nip.io>

如果需要清空资源，可以使用下面命令销毁资源

```
make unjenkinsci
```

> 注意：
> 因为 docker registry 的证书在创建虚拟机的时候已经拷贝过了，如果你需要生成你自己的自签名证书，
> 需要自己手动拷贝到所有虚拟机上去，并使用下面命令更新证书信息
> sudo cp ca.crt /usr/local/share/ca-certificates/kubernetes.crt
> sudo update-ca-certificates
> 参考：https://kubernetes.io/zh/docs/concepts/cluster-administration/certificates/


## Issues 

**服务无法访问，几乎所有的 deployments.apps AVAILABLE 列都显示 0**：服务启动一段时间后，有一定概率会遇到这个问题，我没有排查出具体问题，你可以使用 `vagrant reload` 重启虚拟机集群，可以暂时性解决此问题。

## TODO

有待优化：

* 目前 jenkinsci demo 相关的密码没有统一配置的地方，散落在不同的地方，下一步需要借助模板来统一配置
