#!/bin//bash

# Create kubernetes cluster master node
sudo kubeadm init --config kubeadm-config.yaml

# Set up local kubeconfig
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Default CNI & Multus CNI
cd example
kubectl apply -f kube-flannel.yml && sleep 5
kubectl apply -f multus-daemonset.yml && sleep 5

# OVS-CNI
kubectl apply -f ovs-cni.yaml
kubectl apply -f ovs-net-crd.yaml

# Etcd Operator
cd etcd-cluster/rbac/ && ./create_role.sh && cd ..
kubectl apply -f deployment.yaml && sleep 30
kubectl apply -f ./

# Metrics Server
cd ../metrics-server/
kubectl apply -f ./

# Node Exporter
cd ..
kubectl apply -f prom-node-exporter.yaml

# KubeVirt
cd kubevirt
kubectl apply -f kubevirt-operator.yaml && sleep 30
kubectl apply -f kubevirt-cr.yaml

# Deploy configmap for kube5gnfvo-config
cd ~/.kube/
kubectl create configmap kube5gnfvo-config --from-file=config=config

# Deploy kube5gnfvo
cd ~/kube5gnfvo/example/nfvo/
kubectl apply -k .

kubectl -n kube-system get pods
kubectl get nodes

