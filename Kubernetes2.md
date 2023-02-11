

# Kubernetes Tutorial for Beginners2

## 5. Main Kubectl Commands

### Get status of different components, Create, and Edit a Pod

- get the status of the nodes
  
   `kubectl get nodes`  
   ```
   NAME       STATUS   ROLES           AGE     VERSION
   minikube   Ready    control-plane   7d19h   v1.25.2
   ```

- check the pod status

​    `kubectl get pod`    return: `No resources found in default namespace.`

- check the services status, getting lists of any k8s components

  `kubectl get services` 

  ```
  NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
  kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   7d19h
  ```

- Create a pod. To create any k8s components, we need `kubectl create...` command

  `kubectl create -h`, we can get all relative avaiable commands.

   But from the given list, pod is not shown. That is because, pod is the smallest unit of the k8s cluster, in reality we do not directly work with pods. Instead, we pay attention to **abstraction layer** over pods, called <u>Deployment</u>. It will help to create a pod underneath.

  - create the pod indirectly

    `kubectl create deployment NAME --image=image [--dry-run][options]`🌟

    - give the **name** of the deployment

    - it is created based on some **image** download from docker hub

    - --dry-run: should be none, server, client

  The first two elements are the basic configuration for deployment(name+image)

  - EG: create a nginx deployment：

    - Reference: Nginx for beginner <https://xuexb.github.io/learn-nginx/guide/#nginx%E7%9A%84%E7%89%B9%E7%82%B9-2>

    - `kubectl create deployment nginx-depl --image=nginx`          return: `deployment.apps/nginx-depl created`

    - check: 

      `kubectl get deployments`

    ```
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-depl   1/1     1            1           2m46s
    ```

    Ready: 应用程序的可用的“副本”数。“就绪个数/期望个数”

    ​     `kubectl get pod`

    ```
    NAME                         READY   STATUS    RESTARTS   AGE
    nginx-depl-c88549479-bbdsp   1/1     Running   0          3m33s
    ```

    Deployment has a blue print for creating pods.

- Replicaset: manages the replicas of a pod, the layer between deployment layer and pod.

  `kubectl get replicaset`

  ```
  NAME                   DESIRED   CURRENT   READY   AGE
  nginx-depl-c88549479   1         1         1       35m
  ```

  - we do not need to delete or create replicaset on purpose, we just *interact with deployment* conveniently.
  - automatically create 1 replica

- Interaction with Deployment Layer directly, Edit the Pod

  - If we want to edit the image we got from Docker hub, normally use `kubectl edit deployment [name]`

  - EG: `kubectl edit deployment nginx-depl`

    - We get auto-generated **configuration file** with default values, the full state is downloaded as a temporary file, which is opened in the default text editor.
    - We can fix the configuration manually,press`i` at the position we want to revise, set `nginx:1.16`, then at the end of file press `esc`, type`:wq` to save the change. return: `deployment.apps/nginx-depl edited`

    - Check: `kubectl get pod`

    ```
    NAME                          READY   STATUS    RESTARTS   AGE
    nginx-depl-5b59dcd777-54g6g   1/1     Running   0          80s
    ```

    The new pod with id is running now. While, the original one is terminating.

    `kubectl get replicaset`

    ```
    NAME                    DESIRED   CURRENT   READY   AGE
    nginx-depl-5b59dcd777   1         1         1       3m15s
    nginx-depl-c88549479    0         0         0       177m
    ```

    The original pod doesn't have any repicas, the new pod gains one newly created replica.

    - More about interaction with configuration file: `kubectl apply -f [fileName]`, where `-f` stands for file

      - `#kubectl apply -f nginx-deployment.yaml` # create the file

      - `touch nginx-deployment.yaml`

      - `vim nginx-deployment.yaml `

        - Then the yaml configuration file is created and can be edit.

          ```yaml
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: nginx-deployment
            labels:
              app: nginx
          spec:     #specification for deployment
            replicas: 1
            selector:
              matchLabels:
                app: nginx
            template:
              metadata:
                labels:
                  app: nginx
              spec:  #specification for pod
                containers:
                - name: nginx
                  image: nginx:1.16
                  ports:
                  - containerPort: 8080
          ```

      - `kubectl apply -f nginx-deployment.yaml` Once we edit and save it, we can apply the configuration. Return: `deployment.apps/nginx-deployment created`

      - check it with `kubectl get pod` 

        ```
        NAME                                READY   STATUS    RESTARTS   AGE
        nginx-deployment-78cc6468fb-v7wrb   1/1     Running   0          44s
        ```

      `kubectl get deployment`

      ```
      NAME               READY   UP-TO-DATE   AVAILABLE   AGE
      nginx-deployment   1/1     1            1           102s
      ```

      - if we want to revise the local configuration `vim nginx-deployment`, then the new blank configuration is shown. We can **update** the previous yaml file by setting `replicas:2` , instead of creating a new configuration file.

      - `kubectl apply -f nginx-deployment.yaml` apply this configuration.

      - check `kubectl get deployment`

        ```
        NAME               READY   UP-TO-DATE   AVAILABLE   AGE
        nginx-deployment   2/2     2            2           11m
        ```

    - References: 
      - <https://www.kubermatic.com/blog/introduction-to-kubernetes-deployment/>
      - https://blog.csdn.net/qq_34787054/article/details/90245537

### Debugging Pods

- `kubectl log [pod name]`  #Print the logs for a container in a pod. If the pod has only **one** container, the container name is optional.

  - `minikube image pull mongo`

  - `minikube image pull mongo-express`

  - `kubectl create deployment mongo-depl --image=mongo`

  - `kubectl get pod`

    ```
    NAME                          READY   STATUS              RESTARTS   AGE
    mongo-depl-8fbdb868c-627sx    0/1     ContainerCreating   0          9s
    nginx-depl-5b59dcd777-54g6g   1/1     Running             0          63m
    ```

  - `kubectl describe pod [pod name]` to get the process and more troubleshooting information of each stage.

    `kubectl describe pod mongo-depl-8fbdb868c-627sx`

  - Now, we check it again: `kubectl get pod`

    ```
    NAME                          READY   STATUS    RESTARTS   AGE
    mongo-depl-8fbdb868c-627sx    1/1     Running   0          25h
    nginx-depl-5b59dcd777-54g6g   1/1     Running   0          26h
    ```

  - Finally, `kubectl logs mongo-depl-8fbdb868c-627sx`. If any problems occur, this command helps to debug

- `kubectl exec -it[pod name] --bin/bash`: get the <u>terminal</u> of MongoDB application container in this case.

  - `kubectl exec -it mongo-depl-8fbdb868c-627sx --bin/bash`, then the head is changed as `root@mongo-depl-8fbdb868c-627sx:/#`. The shell script can be used here. 
  - `exit` to leave the terminal interaction

- Reference:<https://copyprogramming.com/howto/imagepull-back-off-kubernetes-mongo-deployment>

### Delete the Pods

First check the deployment and pod:

`kubectl get deployment`

```
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
mongo-depl   1/1     1            1           25h
nginx-depl   1/1     1            1           29h
```

`kubectl get pod`

```
NAME                          READY   STATUS    RESTARTS   AGE
mongo-depl-8fbdb868c-627sx    1/1     Running   0          25h
nginx-depl-5b59dcd777-54g6g   1/1     Running   0          26h
```

- `kubectl delete deployment[name]`

  - `kubectl delete deployment mongo-depl  ` Return: `deployment.apps "mongo-depl" deleted`
  - check the status ``kubectl get pod``

     ```
     NAME                          READY   STATUS    RESTARTS   AGE
     nginx-depl-5b59dcd777-54g6g   1/1     Running   0          26h
     ```

  Now the mongo-depl-8fbdb868c-627sx  pod has been already deleted.

  - `kubectl get replicaset`

    ```
    NAME                    DESIRED   CURRENT   READY   AGE
    nginx-depl-5b59dcd777   1         1         1       26h
    nginx-depl-c88549479    0         0         0       29h
    ```

  - do the same with nginx-depl, the related pod and replica are both dropped out.

## 6. K8s YAML Configuration File

### Three Components of K8s Configuration File

*Nginx-deployment.yaml*

```yaml
apiVersion: apps/v1
kind: Deployment     #the first two lines declare what we want to create
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:     #it also has metadata inside the specification part, configuration inside configuration
  replicas: 2       #this specification belongs to pod, a blueprint for a pod
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:          
      containers:
      - name: nginx
        image: nginx:1.16
        ports:
        - containerPort: 8080
```

*Nginx-service.yaml*

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

1. Metadata

2. Specification

   - attribute of 'spec' are specific to the kind of a component

3. Status

   - Can be **automatically generated** and added by K8s

   - K8s compares the expected and actual status of the component

     - Self-healing feature: if actual status != expected status, K8s will try to fix and update it continuously.

       ```yaml
       status:
         availableReplicas: 1
         conditions:
         - lastTransitionTime: "2023-02-11T10:54:59Z"
           lastUpdateTime: "2023-02-11T10:54:59Z"
           message: Deployment has minimum availability.
           reason: MinimumReplicasAvailable
           status: "True"
           type: Available
         - lastTransitionTime: "2023-02-11T10:54:56Z"
           lastUpdateTime: "2023-02-11T10:54:59Z"
           message: ReplicaSet "nginx-deployment-7d64f4b574" has successfully progressed.
           reason: NewReplicaSetAvailable
           status: "True"
           type: Progressing
         observedGeneration: 1
         readyReplicas: 1
         replicas: 1
         updatedReplicas: 1
       ```

   - Where the Kubernetes get the status data? 
     - From **etcd**, the cluster brain. It holds the current status of any K8s components.

### Format of YAML Configuration File

- Feature:
  - strict indentation.
    - YAML online validator help to fix the code: <https://codebeautify.org/yaml-validator>
  - Where does the configuration file stores? To store them with our code in application.
- References to code yaml:
  -  https://medium.com/@baluramachandra90/yaml-files-in-dbt-part-2-2-fc157764c219
  - https://apekshady.hashnode.dev/yamlmao-understanding-the-aint-markup-language

### Connecting Components

#### Use labels, Selectors, and Ports

- Metadata contains labels

  - give deployment and pod key-value pair

  - pods get the label through templete blueprint

  - **the lables is matched by selector to create the connection**

    ```yaml
    selector:
        matchLabels:
          app: nginx
    ```

- spec contains selectors

  ```yaml
  spec:    
    replicas: 2       
    selector:
      matchLabels:
        app: nginx
    template:
      metadata:
        labels:
          app: nginx
  ```

- build a service configuration which include **selector**, giving the match between service and the deployment.

- Ports in service and deployment or pod

  - service has a port where it is accessible at, and it should match the container port.

  ```yaml
  ports:
      - protocol: TCP
        port: 80 #other serivce sends request to this service effect at port80
        targetPort: 8080 #send out the destination listening pod port address
  ```

  ```yaml
   spec:          
        containers:
        - name: nginx
          image: nginx:1.16
          ports:
          - containerPort: 8080 #listening port
  ```

### Create Deployment and Service Use YAML Files

`kubectl apply -f /Users/macbookpro/desktop/nginx-deployment.yaml` #使用本地路径

`kubectl apply -f /Users/macbookpro/desktop/nginx-service.yaml`

`kubectl get pod`

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-78cc6468fb-v7wrb   1/1     Running   0          80m
nginx-deployment-78cc6468fb-xpslx   1/1     Running   0          15s
```

Two replicas are listed as the configuration declares.

`kubectl get service  `#check the serive status

```
NAME            TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes      ClusterIP   10.96.0.1      <none>        443/TCP   9d
nginx-service   ClusterIP   10.97.74.175   <none>        80/TCP    2m42s
```

Validate the service has the right pods that forward the request. use `kubectl describe service serviceName`

- Eg: `kubectl describe service nginx-service` Return:

```
Name:              nginx-service
Namespace:         default
Labels:            <none>
Annotations:       <none>
Selector:          app=nginx
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.97.74.175
IPs:               10.97.74.175
Port:              <unset>  80/TCP
TargetPort:        8080/TCP
Endpoints:         172.17.0.3:8080,172.17.0.4:8080
Session Affinity:  None
Events:            <none>
```

The target port, port, endpoints are shown.

`kubectl get pod -o  wide`  ,where o: output, for getting more information.

```
NAME                                READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
nginx-deployment-78cc6468fb-v7wrb   1/1     Running   0          85m     172.17.0.3   minikube   <none>           <none>
nginx-deployment-78cc6468fb-xpslx   1/1     Running   0          5m25s   172.17.0.4   minikube   <none>           <none>
```

The IP address in this part is the same as previous one. 

`kubectl get deployment nginx-deployment -o yaml`, generate status in yaml format, inside etcd.

`kubectl get deployment nginx-deployment -o yaml > nginx-deployment-result.yaml` ,save it in a file not in interaction window.

