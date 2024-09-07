Docker Install 


    chmod +x Docker_install.sh

  
    ./Docker_install.sh

=================================================================



Only Containerd  Install 


    chmod +x containerd-install.sh.sh

  
    ./containerd-install.sh.sh

=================================================================




kubernetes install commands:

     chmod +x  Kubeadm-Installation.sh
  
     Kubeadm-Installation.sh

================================================================

kubectl get node (   Error Occur  kubectl_tubeshoot.sh  Download And Install    )



#kubectl get node




Error
E0626 05:05:38.164493   19503 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused



  
    journalctl -u kubelet.service


    chmod +x   install.sh
          
    ./install.sh


====================================================

    node-role.kubernetes.io/control-plane-


FailedScheduling:     This is the event type indicating that the pod could not be scheduled onto any node.

default-scheduler:     This is the component responsible for scheduling pods.

0/1 nodes are available:     Out of 1 node, 0 nodes are available to schedule the pod.

untolerated taint {node-role.kubernetes.io/control-plane: }:     The node has a taint with the key node-role.kubernetes.io/control-plane, and your pod does not have a corresponding toleration.

preemption: 0/1 nodes are available:   1 Preemption is not helpful for scheduling: Indicates that even attempting to preempt other pods will not help in scheduling this pod.

              apiVersion: v1
              kind: Pod
              metadata:
                name: my-pod
              spec:
                tolerations:
                    - key: "node-role.kubernetes.io/control-plane"
                    operator: "Exists"
                    effect: "NoSchedule"
               containers:
                  - name: my-container
                    image: my-image

YAML file for a ReplicationController includes fields (spec.containers and spec.tolerations) that are not valid in the context of a ReplicationController.


              apiVersion: v1
              kind: Pod
              metadata:
                name: example-pod
              spec:
                tolerations:
                   - key: "node-role.kubernetes.io/control-plane"
                   operator: "Exists"
                   effect: "NoSchedule"
            containers:
               - name: example-container
               image: nginx

or

Remove the Taint Temporarily (Optional)

    
    kubectl describe node kube | grep Taints
    
    kubectl taint nodes <node-name> node-role.kubernetes.io/control-plane-

    kubectl taint nodes <node-name> node.kubernetes.io/not-ready:NoSchedule-



I ran into same problem there while upgrading to v1.1.1. check your kube-scheduler process and log

     systemctl status kube-scheduler -l

     sudo journalctl -u kubelet -f
               
     journalctl -u kube-scheduler  -f



kubelet's cgroup driver to match the container runtime cgroup driver for kubeadm clusters.

    

     [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
           
            BinaryName = ""
            
            CriuImagePath = ""
            
            CriuPath = ""
            
            CriuWorkPath = ""
            
            IoGid = 0
            
            IoUid = 0
            
            NoNewKeyring = false
            
            NoPivotRoot = false
            
            Root = ""
            
            ShimCgroup = ""
            
            SystemdCgroup = false
            
=======================================

You can change true

    SystemdCgroup = true


YAML file using yamllint or other YAML validation tools:

    apt install yamllint

     yamllint config.yaml


i fixe the first issue when i recreated the role and the rolebinding

create Role:

    cat <<EOF | kubectl apply -f -

    apiVersion: rbac.authorization.k8s.io/v1
    
    kind: Role
    metadata:
        namespace: kube-system
        name: kubeadm:kubeadm-config
    rules:
        - apiGroups:
        - ""
    resourceNames:
      - kubeadm-config
    resources:
      - configmaps
    verbs:
      - get
    EOF

Create RoleBinding:


    cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      namespace: kube-system
      name: kubeadm:kubeadm-config
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: kubeadm:kubeadm-config
    subjects:
        - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: system:nodes
    - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: system:bootstrappers:kubeadm:default-node-token
    EOF


container network interface (CNI) plugin, which is responsible for managing network connectivity for containers in Kubernetes:

CNI Plugin Installation

Verify that the CNI plugin is installed correctly. 

CNI plugins are usually installed in /opt/cni/bin or /etc/cni/net.d/.

List the contents of the CNI directory:

Verify CNI configuration and ensure that network interfaces are set up.


    ls /opt/cni/bin/

    ls /etc/cni/net.d/

If you don't have a CNI plugin installed, you can install one. 

Some common CNI plugins are Flannel, Calico, Weave, and Cilium.

Install Calico:

    kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

Install Fannel:
    
    kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

Delete the existing Flannel installation:

Try restarting the Flannel :

    kubectl delete pod -l app=flannel -n kube-system

    kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


Install weave:

    kubectl apply -f  https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

Verify CNI Plugin:

    kubectl get pods -n kube-system

Node Has No Critical Errors:

    kubectl top nodes
