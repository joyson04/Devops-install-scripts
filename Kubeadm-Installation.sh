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
