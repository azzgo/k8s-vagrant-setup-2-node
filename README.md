# k8s vagrant

## Quick Start

```sh
vagrant up
```

## Issues

1. 创建的k8s上，创建的应用无法访问

具体原因不清楚，目前排查是master节点在网络插件配置的虚拟网卡上访问到node节点的pod资源，执行`kubectl delete node node`删除掉所有node节点，使用单机节点模式则正常工作

相关 Issue: https://github.com/weaveworks/weave/issues/3574
