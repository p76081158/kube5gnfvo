# Kube5GNfvo - Quick Start

![](https://i.imgur.com/wy0NI6X.png)

###### tags: `docs` `Kubernetes` `free5gc` `NFV`

## Introduction

![](https://i.imgur.com/uJSUT6q.jpg)
* The implementation of **NFV Orchestrator**

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

* [Unable to locate package kubelet/kubeadm/kubectl](https://hackmd.io/@Vcx/BJ-iDJB7_#error-amp-solution)

### OpenvSwitch

#### Install on every node in kubernetes cluster

```bash
$ sudo apt install openvswitch-switch -y
$ sudo ovs-vsctl add-br br1

# ovs-vsctl: unix:/var/run/openvswitch/db.sock: database connection failed (No such file or directory)
$ sudo /usr/share/openvswitch/scripts/ovs-ctl start
```

## Prerequisites Setup

### Kubeadm

#### Node Requirement

* Every nodes should have **kubelet**, **kubeadm** and **kubectl** installed.
* Also, **CRI** is required on every nodes in kubernetes cluster.
* [Check pods can communicate across nodes or not](https://hackmd.io/@Vcx/HyLSg9xM_#Check-pods-can-communicate-across-nodes-or-not)
* [Swap disabled on every nodes](https://hackmd.io/@Vcx/HyLSg9xM_#Swap-disabled)

#### Create Kubernetes Cluster

##### Environment

* **1 Master Node**
    * **Intel(R) Xeon(R) CPU E3-1230 @ 3.2GHz**
    * 10 GB
    * Ubuntu 18.04.3 LTS
    * CRI : Docker
* **2 Worker Node**
    * **Intel(R) Core(TM) CPU i7-2600 @ 3.4GHz**
    * 12 GB
    * Ubuntu 18.04.5 LTS
    * CRI : containerd
    * **Intel(R) Core(TM) CPU i7-6700 @ 3.4GHz**
    * 16 GB
    * Ubuntu 18.04.5 LTS
    * CRI : containerd

## Quick Start

```bash
# All in one script
$ git clone https://github.com/p76081158/kube5gnfvo.git
$ cd kube5gnfvo/
$ ./quickstart.sh
```

## [Kube5GNfvo - Step by Step](https://hackmd.io/@Vcx/BJ-iDJB7_#Prerequisites-Setup)
