#!/bin/bash

kubectl get nodes
echo "====================================================================================="
echo ""
echo "E0626 05:05:38.164493   19503 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused"
echo " "
unset KUBECONFIG
echo "Or set it to the default KUBECONFIG location:"
echo " "
export KUBECONFIG=/etc/kubernetes/admin.conf
echo "Another workaround is to overwrite the existing kubeconfig for the "admin" user:"
echo ""
mv $HOME/.kube $HOME/.kube.bak
mkdir $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo ""
echo ""
kubectl get nodes

