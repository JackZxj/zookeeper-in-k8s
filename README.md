# Zookeeper in Kubernetes

## Base info
- docker
  - version: 19.03.1
- k8s
  - version: v1.15.3

## Usage

** Please use v2 **

### Official zookeeper image

Download `v2/zk-in-k8s.yaml` and use `kubectl apply -f v2/zk-in-k8s.yaml` to start service.
Note: you should create your own `PV` and edit the last part of `zk-in-k8s.yaml` before apply it. You can use `v2/zk-local-pv.yaml` to create local storage, remember to edit it to your own hostname.

Test case:
``` bash
# 查看是否全部启动成功
kubectl get pods -w -l app=zk

# 创建znode
kubectl exec zk-0 zkCli.sh create /hello world
# 在各个节点上查看znode是否同步
kubectl exec zk-0 zkCli.sh get /hello
kubectl exec zk-1 zkCli.sh get /hello
kubectl exec zk-2 zkCli.sh get /hello

# 查看节点状态
kubectl exec zk-1 zookeeper-metrics 2181

# 删除pod测试
kubectl delete po zk-2
# 查看zk-2是否自动重启
kubectl get pods -w -l app=zk
# 查看pod重启后数据是否还在
kubectl exec zk-2 zkCli.sh get /hello

# 删除zk集群，需等待若干分钟至完全删除
kubectl delete statefulset zk
# 重启zk集群
kubectl apply -f zk-in-k8s.yaml
# 查看集群重启后数据是否还在（需要在重启后等待若干分钟重新获取数据）
kubectl exec zk-2 zkCli.sh get /hello
# 若无法重新获得数据，则检查pv的回收策略是否为retain
```

### Own zookeeper image

Base image: `centos:8`

``` bash
cd v2
# for example

docker build -t zxj/zookeeper:3.5.6 .
# test zk image
# create volume file before use!
docker run --name myzk -d -p 2888:2888 -p 3888:3888 -p 2181:2181 -e ZOO_MY_ID=1 -v /root/my-zookeeper/data:/data -v /root/my-zookeeper/datalog:/datalog -v /root/my-zookeeper/logs:/logs zxj/zookeeper:3.5.6
docker exec -i myzk zkServer.sh status
docker exec -i myzk zkCli.sh create /hello world
docker exec -i myzk zkCli.sh get /hello

docker save zxj/zookeeper:3.5.6 -o k8s-zk.tar
scp k8s-zk.tar root@k8s-node1:
scp k8s-zk.tar root@k8s-node2:
scp k8s-zk.tar root@k8s-node3:

# load image in k8s-node
# docker load -i k8s-zk.tar

sed -i 's/zookeeper:3.5.6/zxj\/zookeeper:3.5.6/g' zk-in-k8s.yaml
# in k8s master
# edit it before deploy
kubectl create -f zk-local-pv.yaml
kubectl apply -f zk-in-k8s.yaml

# Test case as same as official image
```
