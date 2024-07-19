Docker Install 


    chmod +x Docker_install.sh

  
    ./Docker_install.sh

=================================================================






kubernetes install commands:

     chmod +x  Kubeadm-Installation.sh
  
     Kubeadm-Installation.sh

================================================================

kubectl get node (   Error Occur  kubectl_tubeshoot.sh  Download And Install    )



#kubectl get node




Error
E0626 05:05:38.164493   19503 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused



  


    chmod +x   kubectl_tubeshoot.sh
          
    ./kubectl_tubeshoot.sh


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

