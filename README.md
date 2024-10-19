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
  
     ./Kubeadm-Installation.sh

================================================================


jenkins install commands:

     chmod +x  jenkinks.sh
  
     ./jenkinks.sh

     Default port number in jeninks 8080

     Recommended install: 
     
     sudo apt install openjdk-17-jre-headless  -y 

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

OR

    containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
    
    sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
    
    sudo systemctl restart containerd
    
    sudo systemctl enable containerd


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




### Step-by-Step Process:

#### 1. Apply ServiceAccount, Role, and RoleBinding YAML Files

Save the following YAML configurations in separate files and apply them.

##### admin-sa.yaml
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: admin-role
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: admin-role
subjects:
  - kind: ServiceAccount
    name: admin
    namespace: default
```

##### general-sa.yaml
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: general
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: general-role
rules:
  - apiGroups: [""]
    resources: ["pods", "services", "endpoints", "namespaces"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["apps", "extensions"]
    resources: ["deployments", "replicasets", "daemonsets", "statefulsets"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["batch"]
    resources: ["jobs", "cronjobs"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: general-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: general-role
subjects:
  - kind: ServiceAccount
    name: general
    namespace: default
```

##### others-sa.yaml
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: others
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: others-role
rules:
  - apiGroups: [""]
    resources: ["namespaces"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: others-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: others-role
subjects:
  - kind: ServiceAccount
    name: others
    namespace: default
```

Apply these configurations:
```sh
kubectl apply -f admin-sa.yaml
kubectl apply -f general-sa.yaml
kubectl apply -f others-sa.yaml
```

#### 2. Generate Tokens for ServiceAccounts

```sh
# For Admin Service Account
kubectl -n default create token admin

# For General Service Account
kubectl -n default create token general

# For Others Service Account
kubectl -n default create token others
```

#### 3. Create Kubeconfig Files

Use the tokens generated in the previous step to create kubeconfig files for each ServiceAccount.

##### Example: admin-kubeconfig.yaml
Save this content to `admin-kubeconfig.yaml`:
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDRNSjVsVUl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBM01UTXhOakkxTXpkYUZ3MHpOREEzTVRFeE5qTXdNemRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURVU3NOMGxEbWhFUlZFOE92MTBKeFFTeTBydXVOOTJxNkhRMGN6VU5PZTFuckdPNGZKY0FGdmNYSG0KM2FCR0J1V0lQOGtvWUNwUEhnVjd5NjYxR2ZqU0UrUnpYb2tHcTY3ZldFZng1bFJScUVHTjByL0kvcndQY2pPagpoazh5R0RObnRzU2hnbzhsZUVWYk5YNkNhcWltRDFGMGxiejk1YUg3VEhiZ3k4RFU1V1NzRk9PWVlWWmdlSDg2Cm5kK3gveG5VMUdwbkhLbFV0VDlnQldrSTI4b1pFZG4yS21zbHlNMVpjeFF4cGd0NldtV0VGc1lDZHJUeDZTa0oKZ1dseHE3alZUNHNISktKRFo5bXUxQkFLalZneVcxT0Z5SEFRWWZhWURGS093NjFrNjJhNkdHdk96S05sYS90YQpheSt1M2Z2cUYxaFNldGp6NlJZQ0NFMjl1aElWQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSYmdWMkdkS01lSnF3YVlQSk1JeVJ5d28raU56QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ3ZtQXlnaXQ3SwpLdGZYRDBzcmxTVS84ODYzMEJXNStWQ0pMSTUwaFUzNTNGM1lJY2FEd3V1NDBGY2RMdUgyM2pHV0ozWnZOYWo2Ck1Qa3ZGWHNxbUZpOXJIME82UTU0K0NCRTZuUmRBelplblo1Nmg1QlFyZmIyNmdUYVVrMWVMM3daV2dGTWRvOEYKeGJFVFhxbXRRSDFpU1ZmakRuN3RXWXdpVVp0VmFwZGY4LzBwWEdnY01jdjZOcy9xRHJ5bjY0d2wrTlk0VENscwpZYXJ1WmQ4blkrM010bGxwQ0VYajJGOEN5V3diaXBRN1p1ZG14cURVZ242aGQ3MTVWWmo1Zml2aXFISnQzdUZxCldBa3B4Y0Q1eUEyNHF0RXpGcUVYUjhmOFRYRzZKZFpvTmtKUGxEODBiQjhjRlVRcTgxWkZPaHhnV3NzNGxoZGQKYnFTelZLU0tYckFICi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://172.31.45.104:6443  # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: admin
  name: admin-context
current-context: admin-context
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: <admin-token>  # Replace with the generated token
```

Replace `<admin-token>` with the actual token generated for the `admin` ServiceAccount.

Repeat this process for the `general` and `others` ServiceAccounts, creating separate kubeconfig files.

##### general-kubeconfig.yaml
Save this content to `general-kubeconfig.yaml`:
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDR

NSjVsVUl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBM01UTXhOakkxTXpkYUZ3MHpOREEzTVRFeE5qTXdNemRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURVU3NOMGxEbWhFUlZFOE92MTBKeFFTeTBydXVOOTJxNkhRMGN6VU5PZTFuckdPNGZKY0FGdmNYSG0KM2FCR0J1V0lQOGtvWUNwUEhnVjd5NjYxR2ZqU0UrUnpYb2tHcTY3ZldFZng1bFJScUVHTjByL0kvcndQY2pPagpoazh5R0RObnRzU2hnbzhsZUVWYk5YNkNhcWltRDFGMGxiejk1YUg3VEhiZ3k4RFU1V1NzRk9PWVlWWmdlSDg2Cm5kK3gveG5VMUdwbkhLbFV0VDlnQldrSTI4b1pFZG4yS21zbHlNMVpjeFF4cGd0NldtV0VGc1lDZHJUeDZTa0oKZ1dseHE3alZUNHNISktKRFo5bXUxQkFLalZneVcxT0Z5SEFRWWZhWURGS093NjFrNjJhNkdHdk96S05sYS90YQpheSt1M2Z2cUYxaFNldGp6NlJZQ0NFMjl1aElWQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSYmdWMkdkS01lSnF3YVlQSk1JeVJ5d28raU56QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ3ZtQXlnaXQ3SwpLdGZYRDBzcmxTVS84ODYzMEJXNStWQ0pMSTUwaFUzNTNGM1lJY2FEd3V1NDBGY2RMdUgyM2pHV0ozWnZOYWo2Ck1Qa3ZGWHNxbUZpOXJIME82UTU0K0NCRTZuUmRBelplblo1Nmg1QlFyZmIyNmdUYVVrMWVMM3daV2dGTWRvOEYKeGJFVFhxbXRRSDFpU1ZmakRuN3RXWXdpVVp0VmFwZGY4LzBwWEdnY01jdjZOcy9xRHJ5bjY0d2wrTlk0VENscwpZYXJ1WmQ4blkrM010bGxwQ0VYajJGOEN5V3diaXBRN1p1ZG14cURVZ242aGQ3MTVWWmo1Zml2aXFISnQzdUZxCldBa3B4Y0Q1eUEyNHF0RXpGcUVYUjhmOFRYRzZKZFpvTmtKUGxEODBiQjhjRlVRcTgxWkZPaHhnV3NzNGxoZGQKYnFTelZLU0tYckFICi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://172.31.45.104:6443  # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: general
  name: general-context
current-context: general-context
kind: Config
preferences: {}
users:
- name: general
  user:
    token: <general-token>  # Replace with the generated token
```

##### others-kubeconfig.yaml
Save this content to `others-kubeconfig.yaml`:
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDRNSjVsVUl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBM01UTXhOakkxTXpkYUZ3MHpOREEzTVRFeE5qTXdNemRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURVU3NOMGxEbWhFUlZFOE92MTBKeFFTeTBydXVOOTJxNkhRMGN6VU5PZTFuckdPNGZKY0FGdmNYSG0KM2FCR0J1V0lQOGtvWUNwUEhnVjd5NjYxR2ZqU0UrUnpYb2tHcTY3ZldFZng1bFJScUVHTjByL0kvcndQY2pPagpoazh5R0RObnRzU2hnbzhsZUVWYk5YNkNhcWltRDFGMGxiejk1YUg3VEhiZ3k4RFU1V1NzRk9PWVlWWmdlSDg2Cm5kK3gveG5VMUdwbkhLbFV0VDlnQldrSTI4b1pFZG4yS21zbHlNMVpjeFF4cGd0NldtV0VGc1lDZHJUeDZTa0oKZ1dseHE3alZUNHNISktKRFo5bXUxQkFLalZneVcxT0Z5SEFRWWZhWURGS093NjFrNjJhNkdHdk96S05sYS90YQpheSt1M2Z2cUYxaFNldGp6NlJZQ0NFMjl1aElWQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSYmdWMkdkS01lSnF3YVlQSk1JeVJ5d28raU56QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ3ZtQXlnaXQ3SwpLdGZYRDBzcmxTVS84ODYzMEJXNStWQ0pMSTUwaFUzNTNGM1lJY2FEd3V1NDBGY2RMdUgyM2pHV0ozWnZOYWo2Ck1Qa3ZGWHNxbUZpOXJIME82UTU0K0NCRTZuUmRBelplblo1Nmg1QlFyZmIyNmdUYVVrMWVMM3daV2dGTWRvOEYKeGJFVFhxbXRRSDFpU1ZmakRuN3RXWXdpVVp0VmFwZGY4LzBwWEdnY01jdjZOcy9xRHJ5bjY0d2wrTlk0VENscwpZYXJ1WmQ4blkrM010bGxwQ0VYajJGOEN5V3diaXBRN1p1ZG14cURVZ242aGQ3MTVWWmo1Zml2aXFISnQzdUZxCldBa3B4Y0Q1eUEyNHF0RXpGcUVYUjhmOFRYRzZKZFpvTmtKUGxEODBiQjhjRlVRcTgxWkZPaHhnV3NzNGxoZGQKYnFTelZLU

0tYckFICi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://172.31.45.104:6443  # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: others
  name: others-context
current-context: others-context
kind: Config
preferences: {}
users:
- name: others
  user:
    token: <others-token>  # Replace with the generated token
```

#### 4. Use the Kubeconfig Files

Set the `KUBECONFIG` environment variable to point to the desired kubeconfig file.

```sh
export KUBECONFIG=/path/to/admin-kubeconfig.yaml
```

You can now use `kubectl` with the permissions of the `admin` ServiceAccount. Similarly, switch the `KUBECONFIG` environment variable to point to `general-kubeconfig.yaml` or `others-kubeconfig.yaml` to use the respective ServiceAccounts.

#### Example Commands:

```sh
# Use the admin kubeconfig
export KUBECONFIG=/path/to/admin-kubeconfig.yaml
kubectl get pods

# Switch to general kubeconfig
export KUBECONFIG=/path/to/general-kubeconfig.yaml
kubectl get pods

# Switch to others kubeconfig
export KUBECONFIG=/path/to/others-kubeconfig.yaml
kubectl get namespaces
```

Node Has No Critical Errors:

    kubectl top nodes


==========================================================================================

# Quality of Service (QOS)

When Kubernetes creates a Pod it assigns one of these QoS classes to the Pod:

* Guaranteed
* Burstable
* BestEffort


Lets start off by creating a namespace for this demo - 

` kubectl create namespace qos ` 

--- 

## Pod with Guaranteed QOS 

For a Pod to be given a QoS class of Guaranteed:

* Every Container in the Pod must have a memory limit and a memory request, and they must be the same.
* Every Container in the Pod must have a CPU limit and a CPU request, and they must be the same.

An example could be - 

```
apiVersion: v1
kind: Pod
metadata:
  name: qos-demo
  namespace: qos
spec:
  containers:
  - name: qos-demo-ctr
    image: nginx
    resources:
      limits:
        memory: "200Mi"
        cpu: "700m"
      requests:
        memory: "200Mi"
        cpu: "700m"

```

To view the QOS - 

```
get pod qos-demo --namespace=qos -o yaml | grep -i qosclass
  qosClass: Guaranteed
```


--- 

## Pod with Burstable QOS Class

A Pod is given a QoS class of Burstable if:

* The Pod does not meet the criteria for QoS class Guaranteed.
* At least one Container in the Pod has a memory or CPU request.

```
apiVersion: v1
kind: Pod
metadata:
  name: qos-demo-2
  namespace: qos
spec:
  containers:
  - name: qos-demo-2-ctr
    image: nginx
    resources:
      limits:
        memory: "200Mi"
      requests:
        memory: "100Mi"

```

To view the QoS

```
kubectl get pods qos-demo-2 -n qos -o yaml | grep -i qosclass
  qosClass: Burstable
```

---

## Pod with BestEffort QOS Class

For a Pod to be given a QoS class of BestEffort, the Containers in the Pod must not have any memory or CPU limits or requests.

```
apiVersion: v1
kind: Pod
metadata:
  name: qos-demo-3
  namespace: qos
spec:
  containers:
  - name: qos-demo-3-ctr
    image: nginx

```

To view the qos class 

```
kubectl get pods qos-demo-3 -n qos -o yaml | grep -i qosclass
  qosClass: BestEffort
```


==========================================================================================


# kubernetes-multiple-scheduler


The Kubernetes scheduler is a policy-rich, topology-aware, workload-specific function that significantly impacts availability, performance, and capacity. The scheduler needs to take into account individual and collective resource requirements, quality of service requirements, hardware/software/policy constraints, affinity and anti-affinity specifications, data locality, inter-workload interference, deadlines, and so on. Workload-specific requirements will be exposed through the API as necessary.


Kubernetes ships with its default scheduler. Please refer to the architecture discussion about what scheduler does. 

The source code for kubernetes defaule scheduler is - 
https://github.com/kubernetes/kubernetes/tree/master/pkg/scheduler


We will take reference from the official kubernetes documentation to implement a second scheduler which will be a replica of the default scheduler. We will name the new scheduler as - **myscheduler** adn the default scheduler will be named as **default-scheduler**. The original demo is referenced at - https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/

**Note** that for this demo we will be building kubernetes on the master node. It is highly recommended that you have atleast 6 CPU, 15 GB of memory and 30 GB of storage on the node where you will execute the **make** command 


Lets start off by 

* Build kubernetes from source

**Clone the official github repository**

```
git clone https://github.com/kubernetes/kubernetes.git
```

**Install build essentials package for ubuntu**

```
sudo apt-get install build-essential -y
```

**Install GO version 1.12.9**

```
mkdir goinstall
cd goinstall
wget https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
tar -C /usr/local/ -xzf go1.12.9.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "export GOPATH=$HOME/go" >> ~/.profile
source ~/.profile

```

**Build Kubernetes** 

```
mkdir -p $GOPATH/src/k8s.io

cd $GOPATH/src/k8s.io

git clone https://github.com/kubernetes/kubernetes

cd kubernetes

make
```

The output is generated at - 

```
root@master:~/go/src/k8s.io/kubernetes# ls -ltra _output/local/bin/linux/amd64/
total 1636344
drwxr-xr-x 3 root root      4096 Oct 31 19:30 ..
-rwxr-xr-x 1 root root   4776910 Oct 31 19:30 go2make
-rwxr-xr-x 1 root root   6722368 Oct 31 19:30 deepcopy-gen
-rwxr-xr-x 1 root root   6689632 Oct 31 19:30 defaulter-gen
-rwxr-xr-x 1 root root   6738848 Oct 31 19:30 conversion-gen
-rwxr-xr-x 1 root root  11357344 Oct 31 19:30 openapi-gen
-rwxr-xr-x 1 root root   2067328 Oct 31 19:30 go-bindata
-rwxr-xr-x 1 root root  46484960 Oct 31 19:36 kubectl
-rwxr-xr-x 1 root root 209533816 Oct 31 19:36 genkubedocs
-rwxr-xr-x 1 root root   1648224 Oct 31 19:36 mounter
-rwxr-xr-x 1 root root  45794912 Oct 31 19:36 genyaml
-rwxr-xr-x 1 root root 120510976 Oct 31 19:36 kube-controller-manager
-rwxr-xr-x 1 root root   8466464 Oct 31 19:36 genswaggertypedocs
-rwxr-xr-x 1 root root  40242464 Oct 31 19:36 kube-proxy
-rwxr-xr-x 1 root root 133733920 Oct 31 19:36 e2e.test
-rwxr-xr-x 1 root root   8814784 Oct 31 19:36 ginkgo
-rwxr-xr-x 1 root root 216607640 Oct 31 19:36 genman
-rwxr-xr-x 1 root root  45794912 Oct 31 19:36 gendocs
-rwxr-xr-x 1 root root 121305336 Oct 31 19:36 kubemark
-rwxr-xr-x 1 root root  44882368 Oct 31 19:36 kube-scheduler
-rwxr-xr-x 1 root root   5483328 Oct 31 19:36 linkcheck
-rwxr-xr-x 1 root root 174141152 Oct 31 19:36 kube-apiserver
-rwxr-xr-x 1 root root  44098272 Oct 31 19:36 kubeadm
-rwxr-xr-x 1 root root 194604032 Oct 31 19:36 e2e_node.test
-rwxr-xr-x 1 root root   1987648 Oct 31 19:36 go-runner
-rwxr-xr-x 1 root root  50129472 Oct 31 19:36 apiextensions-apiserver
-rwxr-xr-x 1 root root 122934520 Oct 31 19:36 kubelet

```

---

* Create a docker image of the new scheduler 

```
vi Dockerfile 
```

Add the below content to dockerfile and save 

```
FROM busybox
ADD ./_output/local/bin/linux/amd64/kube-scheduler /usr/local/bin/kube-scheduler

```

Login to your docker account 

```
docker login
```

Build the docker image 

```
docker build . -t YOUR_DOCKER_ID/my-kube-scheduler:1.0

# In my case it is - 

docker build . -t hubkubernetes/my-kube-scheduler:1.0
```

Push the image to dockerhub

```
docker push YOUR_DOCKER_ID/my-kube-scheduler:1.0

# In my case it is 

docker push hubkubernetes/my-kube-scheduler:1.0

The push refers to repository [docker.io/hubkubernetes/my-kube-scheduler]
6c7a72d53921: Pushed 
1da8e4c8d307: Mounted from library/busybox 
1.0: digest: sha256:b124f38ea2bc80bf38175642e788952be1981027a5668e596747da3f4224c299 size: 739

```

---

* Deploy the new scheduler 

Create a file - my-scheduler.yaml 

```
vi my-scheduler.yaml
```

Add the below content and change the image to point to your docker hub image. Save the file after the change 

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-scheduler
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: my-scheduler-as-kube-scheduler
subjects:
- kind: ServiceAccount
  name: my-scheduler
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: system:kube-scheduler
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    component: scheduler
    tier: control-plane
  name: my-scheduler
  namespace: kube-system
spec:
  selector:
    matchLabels:
      component: scheduler
      tier: control-plane
  replicas: 1
  template:
    metadata:
      labels:
        component: scheduler
        tier: control-plane
        version: second
    spec:
      serviceAccountName: my-scheduler
      containers:
      - command:
        - /usr/local/bin/kube-scheduler
        - --address=0.0.0.0
        - --leader-elect=false
        - --scheduler-name=my-scheduler
        image: gcr.io/my-gcp-project/my-kube-scheduler:1.0
        livenessProbe:
          httpGet:
            path: /healthz
            port: 10251
          initialDelaySeconds: 15
        name: kube-second-scheduler
        readinessProbe:
          httpGet:
            path: /healthz
            port: 10251
        resources:
          requests:
            cpu: '0.1'
        securityContext:
          privileged: false
        volumeMounts: []
      hostNetwork: false
      hostPID: false
      volumes: []

```

Verify that - 

Name is kept as **my-scheduler**

Also note also that we created a dedicated service account my-scheduler and bind the cluster role system:kube-scheduler to it so that it can acquire the same privileges as kube-scheduler.

Run the new scheduler 

```
kubectl create -f my-scheduler.yaml

#Output
deployment.apps/my-scheduler created

```

Add the service account of my-scheduler to the clusterrolebinding **system:volume-scheduler**

```
kubectl edit clusterrolebinding system:volume-scheduler

# Add the below lines at the end of the file

- kind: ServiceAccount
  name: my-scheduler
  namespace: kube-system

```

Verify that both schedulers are running 

```
kubectl get pods --namespace=kube-system | grep scheduler
kube-scheduler-master                     1/1     Running   1          81m
my-scheduler-5854749c67-4n7r8             1/1     Running   0          60s
```

---

* Specifying scheduler for pods 

Note that when no scheduler name is specified, the kubernetes uses the **default-scheduler** 

For this demo we will create a pod that uses the newly created scheduler 

Create a file pod.yaml with the below content - 

```
vi pod.yaml 

# Add the below content 

apiVersion: v1
kind: Pod
metadata:
  name: myschedulerdemo
  labels:
    name: multischeduler-example
spec:
  schedulerName: my-scheduler
  containers:
  - name: pod-with-second-annotation-container
    image: nginx

```

Create the pod using - 

```
kubectl create -f pod.yaml

# Output
pod/myschedulerdemo created

```

Verify that pod was created and was created using **my-scheduler** by running kubectl get events

```
<unknown>   Normal   Scheduled                 pod/myschedulerdemo           Successfully assigned default/myschedulerdemo to slave

```


==========================================================================================

# Multi Master cluster setup using Kubeadm

### What is Kubeadm ? 

Kubeadm is a tool built to provide kubeadm init and kubeadm join as best-practice “fast paths” for creating Kubernetes clusters. kubeadm performs the actions necessary to get a minimum viable cluster up and running. By design, it cares only about bootstrapping, not about provisioning machines. With kubeadm, your cluster should pass Kubernetes Conformance tests. You can find more details about the conformance tests at https://github.com/cncf/k8s-conformance

### Pre-requisite 

For this demo, we will use 2 master and 2 worker node to create a multi master kubernetes cluster using kubeadm installation tool. Below are the pre-requisite requirements for the installation:

* 2 machines for master, ubuntu 16.04+, 2 CPU, 2 GB RAM, 10 GB storage
* 2 machines for worker, ubuntu 16.04+, 1 CPU, 2 GB RAM, 10 GB storage
* 1 machine for loadbalancer, ubuntu 16.04+, 1 CPU, 2 GB RAM, 10 GB storage
* All machines must be accessible on the network. For cloud users - single VPC for all machines 
* sudo privilege 
* ssh access from loadbalancer node to all machines (master & worker). 
* ssh access can be given to any account. ssh through root is not mandatory

Note that we will not cover ssh setup between loadbalancer. 

Below are my virtual machines on GCP - region - us-west1

![image](https://user-images.githubusercontent.com/44743158/68572873-81edcf80-048c-11ea-968a-1de67925696b.png)

---

## Setting up loadbalancer

At this point we will work only on the **loadbalancer** node. In order to setup loadbalancer, you can leverage any loadbalancer utility of your choice. If you feel like using cloud based TCP loadbalancer, feel free to do so. There is no restriction regarding the tool you want to use for this purpose. For our demo, we will use HAPROXY as the primary loadbalancer. 

### What are we loadbalancing ?

We have 2 master nodes. Which means the user can connect to either of the 2 api-servers. The loadbalancer will be used to loadbalance between the 2 api-servers. 

Now that we have some information about what we are trying to achieve, we can now start configuring our loadbalancer node. 

* Login to the loadbalancer node 

* Switch as root - ` sudo -i` 

* Update your repository and your system 

```
sudo apt-get update && sudo apt-get upgrade -y

```

* Install haproxy

```
sudo apt-get install haproxy -y
```

* Edit haproxy configuration 

```
vi /etc/haproxy/haproxy.cfg
```

Add the below lines to create a frontend configuration for loadbalancer - 

```
frontend fe-apiserver
   bind 0.0.0.0:6443
   mode tcp
   option tcplog
   default_backend be-apiserver
```

Add the below lines to create a backend configuration for master1 and master2 nodes at port 6443. __**Note**__ : 6443 is the default port of **kube-apiserver**

```
backend be-apiserver
   mode tcp
   option tcplog
   option tcp-check
   balance roundrobin
   default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100

       server master1 10.138.0.15:6443 check
       server master2 10.138.0.16:6443 check
```

Here - **master1** and **master2** are the names of the master nodes and **10.138.0.15** and **10.138.0.16** are the corresponding internal IP addresses. 

* Restart and Verify haproxy

```
systemctl restart haproxy
systemctl status haproxy
```

Ensure haproxy is in running status. 

Run nc command as below - 

```
nc -v localhost 6443
Connection to localhost 6443 port [tcp/*] succeeded!
```

**Note** If you see failures for master1 and master2 connectivity, you can ignore them for time being as we have not yet installed anything on the servers. 

---

## Install kubeadm,kubelet and docker on master and worker nodes

In this step we will install kubelet and kubeadm on the below nodes 

* master1
* master2
* worker1
* worker2 

The below steps will be performed on all the below nodes. 

* Log in to all the 4 machines as described above

* Switch as root - `sudo -i` 

* Update the repositories 

```
apt-get update
```

* Turn off swap 

```
swapoff -a 
```

* Install kubeadm and kubelet

```
apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update

apt-get install -y kubelet kubeadm

apt-mark hold kubelet kubeadm 

```

* Install container runtime - **docker**

```
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```

---

## Configure kubeadm to bootstrap the cluster 


We will start off by initializing only one master node. For this demo, we will use master1 to initialize our first control plane. 

* Log in to **master1** 
* Switch to root account - `sudo -i` 
* Execute the below command to initialize the cluster - 

```
kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs --pod-network-cidr=192.168.0.0/16 
```

Here, LOAD_BALANCER_DNS is the IP address or the dns name of the loadbalancer. I will use the dns name of the server, i.e. `loadbalancer` as the LOAD_BALANCER_DNS. In case your DNS name is not resolvable across your network, you can use the IP address for the same. 

The LOAD_BALANCER_PORT is the front end configuration port defined in HAPROXY configuration. For this demo, we have kept the port as **6443**. 

The command effectively becomes - 

```
kubeadm init --control-plane-endpoint "loadbalancer:6443" --upload-certs --pod-network-cidr=192.168.0.0/16 
```

![image](https://user-images.githubusercontent.com/44743158/68580013-7bb31f80-049b-11ea-8394-5fb9b9465552.png)


Your output should look like below - 

```
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 \
    --control-plane --certificate-key 824d9a0e173a810416b4bca7038fb33b616108c17abcbc5eaef8651f11e3d146

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use 
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 
```


The output consists of 3 major tasks - 

1. Setup kubeconfig using - 

```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

```

2. Setup new control plane (master) using 

```
  kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 \
    --control-plane --certificate-key 824d9a0e173a810416b4bca7038fb33b616108c17abcbc5eaef8651f11e3d146

```

3. Join worker node using 

```
kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 
```

**NOTE** 

**Your output will be different than what is provided here. While performing the rest of the demo, ensure that you are executing the command provided by your output and dont copy and paste from here.**

Save the output in some secure file for future use. 

---

* Log in to master2 
* Switch to root - `sudo -i` 
* Check the command provided by the output of master1 

You can now use the below command to add another node to the control plane - 

```
kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 \
    --control-plane --certificate-key 824d9a0e173a810416b4bca7038fb33b616108c17abcbc5eaef8651f11e3d146

```

* Execute the kubeadm join command for control plane on master2

![image](https://user-images.githubusercontent.com/44743158/68580399-4ce97900-049c-11ea-881b-a64728ed7b24.png)

Your output should look like - 

```
 This node has joined the cluster and a new control plane instance was created:

* Certificate signing request was sent to apiserver and approval was received.
* The Kubelet was informed of the new secure connection details.
* Control plane (master) label and taint were applied to the new node.
* The Kubernetes control plane instances scaled up.
* A new etcd member was added to the local/stacked etcd cluster.

```

Now that we have initialized both the masters - we can now work on bootstrapping the worker nodes. 

* Log in to **worker1** and **worker2**
* Switch to root on both the machines - ` sudo -i` 
* Check the output given by the init command on **master1** to join worker node - 

```
kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 
```

* Execute the above command on both the nodes - 

* Your output should look like - 

```
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

```

--- 

## Configure kubeconfig on loadbalancer node 

Now that we have configured the master and the worker nodes, its now time to configure Kubeconfig (.kube) on the loadbalancer node. It is completely up to you if you want to use the loadbalancer node to setup kubeconfig. kubeconfig can also be setup externally on a separate machine which has access to loadbalancer node. For the purpose of this demo we will use loadbalancer node to host kubeconfig and kubectl. 

* Log in to loadbalancer node
* Switch to root - `sudo -i` 
* Create a directory - .kube at $HOME of root 

```
mkdir -p $HOME/.kube
```

* SCP configuration file from any one **master** node to **loadbalancer** node 

``` 
scp master1:/etc/kubernetes/admin.conf $HOME/.kube/config

```

**NOTE**

If you havent setup ssh connection, you can manually download the file /etc/kubernetes/admin.conf from any one of the master and upload it to $HOME/.kube location on the loadbalancer node. Ensure that you change the file name as just **config** on the loadbalancer node.


* Provide appropriate ownership to the copied file 

```
chown $(id -u):$(id -g) $HOME/.kube/config
```

![image](https://user-images.githubusercontent.com/44743158/68581453-71465500-049e-11ea-9042-bd283a4e4782.png)

* Install kubectl binary 

```
snap install kubectl --classic
```

* Verify the cluster 

```
kubectl get nodes 

NAME      STATUS     ROLES    AGE     VERSION
master1   NotReady   master   21m     v1.16.2
master2   NotReady   master   15m     v1.16.2
worker1   NotReady   <none>   9m17s   v1.16.2
worker2   NotReady   <none>   9m25s   v1.16.2

```

---

## Install CNI and complete installation 

From the loadbalancer node execute - 

```
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml

```

This installs CNI component to your cluster. 

You can now verify your HA cluster using - 

```
kubectl get nodes 

NAME      STATUS   ROLES    AGE   VERSION
master1   Ready    master   22m   v1.16.2
master2   Ready    master   17m   v1.16.2
worker1   Ready    <none>   10m   v1.16.2
worker2   Ready    <none>   10m   v1.16.2

```

This concludes the demo to create a multi master cluster using kubeadm utility. 

==========================================================================================

# Storage Class on GKE 


In the Kubernetes 1.6 release, dynamic provisioning has been promoted to stable (having entered beta in 1.4). This is a big step forward in completing the Kubernetes storage automation vision, allowing cluster administrators to control how resources are provisioned and giving users the ability to focus more on their application. With all of these benefits, there are a few important user-facing changes (discussed below) that are important to understand before using Kubernetes 1.6.

# Storage Classes and How to Use them

StorageClasses are the foundation of dynamic provisioning, allowing cluster administrators to define abstractions for the underlying storage platform. Users simply refer to a StorageClass by name in the PersistentVolumeClaim (PVC) using the “storageClassName” parameter.

In the following example, a PVC refers to a specific storage class named “gold”.

```
apiVersion: v1

kind: PersistentVolumeClaim

metadata:

  name: mypvc

  namespace: testns

spec:

  accessModes:

  - ReadWriteOnce

  resources:

    requests:

      storage: 100Gi

  storageClassName: gold

```


## Dynamic provisioning of GCP PD 

```
apiVersion: v1

kind: PersistentVolumeClaim

metadata:

  name: mypvc

  namespace: testns

spec:

  accessModes:

  - ReadWriteOnce

  resources:

    requests:

      storage: 100Gi

```

## ADD GCP PD Storage class in kubernetes

```
kind: StorageClass

apiVersion: storage.k8s.io/v1

metadata:

  name: gold

provisioner: kubernetes.io/gce-pd

parameters:

  type: pd-ssd

```

