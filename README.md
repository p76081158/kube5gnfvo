# Kube5GNfvo

![](https://i.imgur.com/wy0NI6X.png)

###### tags: `docs` `Kubernetes` `free5gc` `NFV`

## Introduction



## Requirement

### Linux

* [free5gc linux kernel version & module](https://hackmd.io/@Vcx/Hy_gHkdAD)

### Git

* [Git Install for Ubuntu 18.04](https://hackmd.io/@Vcx/SyuZPlBWu)

### Container Runtime Interface

* Every machines in cluster should have CRI

#### choose one for CRI

* [CRI-O](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cri-o)
* [containerd](https://hackmd.io/@Vcx/rJFyLPRWO)
* [Docker](https://hackmd.io/@Vcx/ByYcrDvSL)

### Kubernetes

* Using Kubernetes version: **v1.15.3**
* at least **two machine** (master & worker node)

#### install for linux

```bash
# on each node run this cmd
$ sudo apt-get install -y kubelet=1.15.3-00 kubeadm=1.15.3-00 kubectl=1.15.3-00 --allow-downgrades
```

#### if already installed kubectl binary with curl on Linux

* [Downgrade/Uninstall kubectl version](https://hackmd.io/@Vcx/rk2WlZa-_)

#### error & solution

![](https://i.imgur.com/hWV5Ssg.png)

##### Add key for new repository:

```bash
$ sudo apt install curl
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```
![](https://i.imgur.com/d23dhHe.png)

##### Add repository:

```bash
# write repository to file (use tee)
$ echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
$ sudo apt-get update

# write repository to file (use nano)
$ sudo nano /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
$ sudo apt-get update
```
![](https://i.imgur.com/1wPBbYQ.png)

##### Install Kubernetes:

```bash
# need reboot for kubectl environment $PATH setup
$ sudo apt-get install -y kubelet=1.15.3-00 kubeadm=1.15.3-00 kubectl=1.15.3-00 --allow-downgrades
```
![](https://i.imgur.com/poISMwa.png)

## Setup

### Kubeadm

#### Node Requirement

* Every nodes should have **kubelet**, **kubeadm** and **kubectl** installed.
* Also, **CRI** is required on every nodes in kubernetes cluster.
* [Check pods can communicate across nodes or not](https://hackmd.io/@Vcx/HyLSg9xM_#Check-pods-can-communicate-across-nodes-or-not)
* [Swap disabled on every nodes](https://hackmd.io/@Vcx/HyLSg9xM_#Swap-disabled)

#### Create Kubenetes Cluster

##### Environment

* **1 Master Node**
    * Intel(R) Xeon(R) CPU E3-1230 @ 3.20GHz
    * 10 GB
    * Ubuntu 18.04.3 LTS
    * CRI : Docker
* **1 Worker Node**
    * Intel(R) Core(TM) CPU i7-2600 @ 3.4GHz
    * 12 GB
    * Ubuntu 18.04.5 LTS
    * CRI : containerd

##### Master Node

* Create cluster
```bash
$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```
![](https://i.imgur.com/65D4Zyn.png)
* Set up local kubeconfig
```bash
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

# check cluster state
$ kubectl get nodes
```
![](https://i.imgur.com/YjvP6Dg.png)
* Check master node's pods
```bash
$ kubectl -n kube-system get pods
```
![](https://i.imgur.com/YOGflpX.png)
* Install [flannel CNI](https://hackmd.io/@Vcx/rJgcDWbfu#flannel-CNI)
```bash
$ git clone https://github.com/p76081158/kube5gnfvo.git
$ cd kube5gnfvo/example/
$ kubectl apply -f kube-flannel.yml
```
![](https://i.imgur.com/2wy6HQB.png)
* Check flannel pod and master node ready or not
```bash
$ kubectl -n kube-system get pods
$ kubectl get nodes
```
![](https://i.imgur.com/XRMbibE.png)
* Install [Multus-CNI](https://hackmd.io/@Vcx/rJgcDWbfu#Multus-CNI)
```bash
# skip these cmd if already clone
$ git clone https://github.com/p76081158/kube5gnfvo.git
$ cd kube5gnfvo/example/

# create multus cni
$ kubectl apply -f multus-daemonset.yml
```
![](https://i.imgur.com/ETO4ewX.png)
![](https://i.imgur.com/XFvQAre.png)
* Check multus pod and master node ready or not
```bash
$ kubectl -n kube-system get pods
$ kubectl get nodes
```
![](https://i.imgur.com/cnNDlxg.png)

##### Worker Node

* Join cluster
* [How to get join cmd](https://hackmd.io/@Vcx/HyLSg9xM_#Get-cluster-join-token)
```bash
# kubeadm join <master_ip> --token <token> --discovery-token-ca-cert-hash <ca>
$ sudo kubeadm join 140.116.247.67:6443 --token 9gws4c.ddca6cgcqna38qd8     --discovery-token-ca-cert-hash sha256:5d521ecbda86a353f2cbc7b735219f03c83a1208f48ee604316db2b34b20d378
```
![](https://i.imgur.com/qvm44Dq.png)
* Check cluster node <font color="red">(Run this cmd at master node)</font>
```bash
$ kubectl get nodes
$ kubectl -n kube-system get pods
```
![](https://i.imgur.com/D5VDZxX.png)

### OpenvSwitch

#### Install on every node in kubernetes cluster

```bash
$ sudo apt install openvswitch-switch -y
$ sudo ovs-vsctl add-br br1
```
![](https://i.imgur.com/joeX5Sf.png)

### OVS-CNI

#### Install [Open vSwitch CNI](https://hackmd.io/@Vcx/rJgcDWbfu#Open-vSwitch-CNI)

```bash
$ cd kube5gnfvo/example/
$ kubectl apply -f ovs-cni.yaml
$ kubectl -n kube-system get pods
```
![](https://i.imgur.com/3LfnLOf.png)

#### Create a NetworkAttachmentDefinition

* Definition of CNI which can be used by multus cni to deploy pod's network

## Reference

1. [free5gmano/kube5gnfvo](https://github.com/free5gmano/kube5gnfvo)
2. [Ubuntu 16.04 LTS - Unable to locate package kubelet, kubeadm, kubectl](https://github.com/kubernetes/kubernetes/issues/59959)