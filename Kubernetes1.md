# Kubernetes Tutorial for Beginner1

## 1. What is K8s?

- Official defintion: 
  - Open source container orchestration tool,it manages containers, <u>speed</u> Docker container or from other technology.
  - Helps you manage hundreds and thousands of containerized applications in different delpoyment environments, such as psychical machine, virtual machines, Cloud, or hybrid environments. 
- Problem solved: trend from Monolith(large) to **Microservice**(small, independent application), increase the usage of containers, calling the needs for a proper way of managing hundreds of containers.

- Tasks: guarantee the following features:

  - High availability or no downtime, always accessable by the users

  - Scalability or high performance, loads fast

  - Disaster recovery, backup, and restore

## 2. Main K8s Components

### Node and Pod

- Node: a simple server, a physical or virtual machine and the basic component 
- Pod: 
  - the smallest unit of Kubernetes
  - abstraction over *container*
  - Usually 1 application per Pod
  - create a running environment or a layer on top of the container, which makes us *only* interact with the <u>Kubernetes layers</u>
  - each pod gets its own **IP address**. Using the internal IP address, pods communicate with each other.
  - Ephemeral: the pod can <u>die easily</u>, probably because run out of resources or crashed → the **new one** will get created in its place→new IP address assigned on re-creation. (This process is complex.)

### Service and Ingress(SVC,ING)

- Service: 
  - **static/permanent IP** address, which can be attached to each pod
  - **load balancer**: catch the request and forward it to whichever part is list busy
  - The lifecycle of Pod and Service NOT connected. Namely, even if the pod dies, the IP address still exists.
  - To make applications be accessible through browser:
    - create an `external service`, for opening communication from external sources
    - create an `internal service` without disclosuring databases
- Ingress:
  - external request →Ingress→Service
  - an API object provides routing rules to <u>manage external users' access</u> to the K8s cluster, typically via HTTPS/HTTP.

### ConfigMap(CM) and Secret

- Background: Database URL(endpoint) usually in the *built* application, if the service name or end point of the service has <u>changed</u>, the corresponding URL needs to be *re-built* →push it to *repository*→pull it in the *pod*→restart. The process is so complicated, we use ConfigMap to simplfy the procedure.
- ConfigMap:
  - external configuration to your application, contains configuration data in a plain text format, such as URL.
  - If we change the service name or end point of service, **configmap adjustment** is the only need, without building the new image.
  - **Credentials** such as usersname, password should **not** be put into ConfigMap.(put in Secret)
- Secret:
  - Used to store secret data connected with pod, such as username, password
  - not stored in a plain text format, base64 encoded
  - The built-in security mechanismism is not enabled by default
  - use it as <u>environmental variables</u> or a <u>properties file</u>.

### Volumes(VOL)

- Background: related with data storage, if the pod or server get restarted, the data would be gone.
- Functionality: volume attaches a **physical storage on a hard drive** to pod, which makes data storage on <u>local machine</u> or in a <u>remote storage machine</u> outside the K8s cluster(eg: cloud, own premise storage), keep the presistance of data.

### Deployment and StatefulSet(deploy, STS)

- If the **application pod dies**, take advantage of **distributed systems and containers**, instead of relying on just one application pod or only one dataset pod. 
  - We can **replicate** everything on multiple servers/nodes.
  - **Deployment**: 
    - define the blue prints for pods, and define how many replicas we would like to run.
    - abstraction on the top of pods
    - in practice, we more interact with deployment, instead of pods.
  - The replica is connected to the same server.
- If the **database pod dies**, we **don't** depend on **deloyment** to make replicas, but depend on **StatefulSet**.
  - Reason: if we clone or replicate the database, we need to access the same shared data storage, the mechanism that decides the write or reads authorities of storage is needed, in order to avoid data inconsistencies.
  - StatefulSet: 
    - used for stateful app or databases
    - replicating the pods, define how many replicas we need, and make sure the database reads and writes are synchronized without any inconsistencies.
    - While, make replicas with StatefulSet is not an easy operation. Hence, databases are often hosted outside of K8s cluster

## 3. Kubernetes Architecture

### 3 Node Processes

1. Container runtime

2. Kubelet

   - interacts with both the <u>container and node</u>

   - take the configuration, and start a pod with the container inside, assigning the resources from that node to the container, such as CPU, RAM

3. Kube proxy

   - forwarding requests from <u>services to pods</u>, installed on every node

   - has intelligent forwording logic inside, sends the application pod request to the database **in the same node**, instead of other different nodes.

### 4 Master Process

- container the cluster state and the worker nodes as well
- do less load of work and need less resources, hence the number of master node<< number of worker nodes.

1. API Server
   - Cluster gateway: get initial request from clients(UI, API, command line) of *updates* into the clusters or the *queries* from the clusters
   - Gatekeeper for authentictication: only authorized requests get through the cluster.
   - Procedure: request→API Server→Validates request→other process→Pod.
   - As the only one entrypoint into the cluster.
2. Scheduler
   - Task: decide where to put the request from API server to the **specific worker node** in Pod.
   - Process: look at the GPU or ARM→then comes to the worker nodes to find the availiable resources→ first target at the node which is the<u> least busy</u>→schedule the <u>new Pod</u> on that node
   - While the actual **executor** is **Kubelet**, getting request from scheduler and executting the requests.
3. Controller Manager
   -  Tasks and Procedure
     - Detect the nodes **died**→make request to scheduler→ re-schedule these died pods ASAP→Kubelet execute→Pod restart.
4. Etcd
   - cluster brain, the core part!
   - cluster *changes* get stored in the key value store. However, the <u>actual application data</u> is **not** stored in etcd.
   - Distributed storage across all master nodes

## 4. Minikube and Kubectl-- Local Setup

### Minikube

- Defintion: 
  - **one** node cluster which contains both <u>Master and Worker</u> nodes processes
  - this node has a Docker `container runtime` pre-installed
  - Create a `virtual box` on your local machine, and the node runs in the virtual box, for testing purpose

### Kubectl

- Interact with the any types of Kubernetes cluster(Minikube or Cloud cluster) with a command line tool

- Installation: https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos and https://minikube.sigs.k8s.io/docs/start/

  `brew install kubectl`

  `kubectl version --client`

  `brew install hyperkit`

  `brew install minikube` #it will install kubectl as well

  `minikube` #check whether it is working or not

- Create a minikube kubernetes cluster

  `minikube start --vm-driver=hyperkit`

  `kubectl get nodes` #get the status of nodes

  Return:

  ```
  NAME       STATUS   ROLES           AGE   VERSION
  minikube   Ready    control-plane   83s   v1.25.2
  ```

  `minikube status`

  Return:

  ```
  minikube
  type: Control Plane
  host: Running
  kubelet: Running
  apiserver: Running
  kubeconfig: Configured
  ```

  











