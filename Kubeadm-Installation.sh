-------------------------------------- Both Master & Worker Node ---------------------------------------
sudo apt update -y
sudo apt install docker.io -y

sudo systemctl start docker
sudo systemctl enable docker

echo "Debian 12 and Ubuntu 22.04, directory /etc/apt/keyrings does not exist by default, and it should be created before the curl command"
echo "22.04 lower version create directory"
echo "mkdir /etc/apt/keyrings"

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo apt-get install -y kubelet kubeadm kubectl
echo "--------------------------------------------- Master Node Only -------------------------------------------------- "
echo "Master Node (Type yes)[Master command executed] , Worker Node Type no [worker command executed]"
echo "yes or no:"
echo " "
read  $a
if [ "$a" = "yes" ]
then
    echo "--------------------------------------------- Master Node -------------------------------------------------- "
    sudo su
    echo "====== Disable swap if it is enabled ========"
    sudo swapon --show
    sudo swapoff -a
    echo ""
    echo "============================================"
    echo ""
    kubeadm init
    export KUBECONFIG=/etc/kubernetes/admin.conf
    kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
    kubeadm token create --print-join-command

else
    echo "--------------------------------------------- Worker Node --------------------------------------------------"
    sudo su
    echo "====== Disable swap if it is enabled ======"
    sudo swapon --show
    sudo swapoff -a
    echo "============================================"

    kubeadm reset pre-flight checks
    echo "complete-output-of-join-command --v=5"
fi 
----------------------------------------------------------------------------------------------------------------------------------------
If getting below message as output of command "kubectl get nodes",
The connection to the server localhost:8080 was refused - did you specify the right host or port? Then perform the following on Master
root@node:/home/ubuntu# unset KUBECONFIG
root@node:/home/ubuntu# export KUBECONFIG=/etc/kubernetes/admin.conf
root@node:/home/ubuntu# mv $HOME/.kube $HOME/.kube.bak
root@node:/home/ubuntu# mkdir $HOME/.kube
root@node:/home/ubuntu# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
root@node:/home/ubuntu# sudo chown $(id -u):$(id -g) $HOME/.kube/config
root@node:/home/ubuntu# systemctl daemon-reload
root@node:/home/ubuntu# systemctl restart kubelet
root@node:/home/ubuntu# kubectl get node
NAME         STATUS   ROLES           AGE     VERSION
masternode   Ready    <none>          9m14s   v1.30.2
node         Ready    control-plane   23m     v1.30.2
root@node:/home/ubuntu# 
----------------------------------------------------------------------------------------------------------------------------------------