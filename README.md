# Zookeeper in Kubernetes

## Base info
- docker
  - version: 19.03.1
- k8s
  - version: v1.15.3
- k8s-zookeeper
  - base image: zookeeper:3.5.6 ([ official ](https://hub.docker.com/_/zookeeper))

## Usage

``` bash
git clone http://open.inspur.com/zhangxinjie01/zookeeper-in-k8s.git
# if not in dev branch
# git checkout dev

cd ./zookeeper-in-k8s/
docker build -t k8s-zookeeper:3.5.6 .

# copy to k8s cluster node
docker save k8s-zookeeper:3.5.6 -o k8s-zk.tar
scp k8s-zk.tar root@k8s-node1:
scp k8s-zk.tar root@k8s-node2:
scp k8s-zk.tar root@k8s-node3:

# load image in k8s node
docker load -i k8s-zk.tar

# in k8s master
# edit it before deploy
kubectl create -f zookeeper-pv.yml
kubectl apply -f zookeeper.yml
```
