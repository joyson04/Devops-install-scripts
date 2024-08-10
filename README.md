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


I ran into same problem there while upgrading to v1.1.1. check your kube-scheduler process and log

     systemctl status kube-scheduler -l

               
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
