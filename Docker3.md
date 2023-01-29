# Docker Tutorial for Beginner3

## 10. Private Docker Registry

### Create Docker Private Repository on Alibaba Cloud

- We can use AWS, Google Cloud, Tencent Cloud as well.

- For Alibaba Cloud, the detailed process: Login your Alibaba Cloud account→Container Repository(ACR)https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors→实例列表→个人实例→镜像仓库→创建镜像仓库→填写信息，代码源：本地仓库
  - You save different tags/versions of the same image. In this case, our goal is to push the *My-App* image to the private repository we just created.

### Push the Image to Private Repository

#### 1. Docker Login

```shell
➜  ~ git:(main) ✗ docker login --username=aliyun5550262697 registry.cn-hangzhou.aliyuncs.com
Password:    #input your password of AliCloud
Login Succeeded
```

#### 2. Push the Image in Local to the Repository

##### Image Naming in Docker Registries

- **registryDomain/imageName:tag**

  - registryDomain: host, port...
  - In Docker hub pull an image is simplified:

  `docker pull mongo:4.2`→`docker pull docker.io/library/mongo:4.2`

  - However, in private repository cases, we cannot skip the registryDomain, because of lacking of default configuration.
  - In Alibaba Cloud, we need to specify the <u>imageID</u> and image <u>version</u>, **tag** and **push**

`docker tag 3f11185e9db7 registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app:1.0`

`docker push registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app:1.0`

*return*

```
The push refers to repository [registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app]
5fad40a853ec: Pushed 
5f70bf18a086: Pushed 
7107c2c0d8d0: Pushed 
ea1c7308a3c1: Pushed 
629960860aca: Pushed 
f019278bad8b: Pushed 
8ca4f4055a70: Pushed 
3e207b409db3: Pushed 
1.0: digest: sha256:fd1fe2e5527b05c5698f04d820cc10f0f7210776efbac9792c65575ab57d737e size: 1990
```

check with `docker images`

*Return*

```Shell
REPOSITORY                                                  TAG       IMAGE ID       CREATED         SIZE
my-app                                                      1.0       3f11185e9db7   8 days ago      120MB
registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app   1.0       3f11185e9db7   8 days ago      120MB
redis                                                       latest    5f2e708d56aa   2 weeks ago     117MB
postgres                                                    latest    9f3ec01f884d   2 weeks ago     379MB
mongo                                                       latest    0850fead9327   7 weeks ago     700MB
mongo-express                                               latest    2d2fb2cabc8f   15 months ago   136MB
hello-world                                                 latest    feb5d9fea6a5   16 months ago   13.3kB
scrapinghub/splash                                          latest    9364575df985   2 years ago     1.89GB
redis                                                       4.0       191c4017dcdd   2 years ago     89.3MB
```

From the list, we made the copy and rename *my-app* into *registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app*.

Then on Alibaba Cloud, our image is shown in the private repository.

### Make Changes to the App, Rebuild, and Push a New Version to Alibaba Cloud Repo

#### 1. Build a New Docker Image by Updating the Original One

After changes some codes in our original file,

`docker build -t my-app:1.1 .`

*return*

```
[+] Building 1.7s (10/10) FINISHED                                                                                                
 => [internal] load build definition from Dockerfile                                                                         0.0s
 => => transferring dockerfile: 838B                                                                                         0.0s
 => [internal] load .dockerignore                                                                                            0.0s
 => => transferring context: 2B                                                                                              0.0s
 => [internal] load metadata for docker.io/library/node:13-alpine                                                            1.5s
 => [1/5] FROM docker.io/library/node:13-alpine@sha256:527c70f74817f6f6b5853588c28de33459178ab72421f1fb7b63a281ab670258      0.0s
 => [internal] load build context                                                                                            0.0s
 => => transferring context: 1.60kB                                                                                          0.0s
 => CACHED [2/5] RUN mkdir -p /Desktop/techworld-js-docker-demo-app-with-nana-master/app                                     0.0s
 => CACHED [3/5] COPY ./app /Desktop/techworld-js-docker-demo-app-with-nana-master/app                                       0.0s
 => CACHED [4/5] WORKDIR /Desktop/techworld-js-docker-demo-app-with-nana-master/app                                          0.0s
 => CACHED [5/5] RUN npm install                                                                                             0.0s
 => exporting to image                                                                                                       0.0s
 => => exporting layers                                                                                                      0.0s
 => => writing image sha256:316206c4e2b5b71aee4793993ef47971fb0bf2b08b4ce3985ff9c86064c79d36                                 0.0s
 => => naming to docker.io/library/my-app:1.1                                                                                0.0s
```

Check with `docker images`

*return*

```
REPOSITORY                                                  TAG       IMAGE ID       CREATED         SIZE
my-app                                                      1.1       316206c4e2b5   3 minutes ago   120MB
techworldjsdockerdemoappwithnanamaster                      latest    316206c4e2b5   3 minutes ago   120MB
my-app                                                      1.0       3f11185e9db7   8 days ago      120MB
registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app   1.0       3f11185e9db7   8 days ago      120MB
redis                                                       latest    5f2e708d56aa   2 weeks ago     117MB
postgres                                                    latest    9f3ec01f884d   2 weeks ago     379MB
mongo                                                       latest    0850fead9327   7 weeks ago     700MB
mongo-express                                               latest    2d2fb2cabc8f   15 months ago   136MB
hello-world                                                 latest    feb5d9fea6a5   16 months ago   13.3kB
scrapinghub/splash                                          latest    9364575df985   2 years ago     1.89GB
redis                                                       4.0       191c4017dcdd   2 years ago     89.3MB
```

Now new my-app with 1.1 tag is listed.

#### 2. Push the Updated my-app to Private Repository

`docker tag my-app:1.1 registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app:1.1`

check with `docker images`

```
REPOSITORY                                                  TAG       IMAGE ID       CREATED         SIZE
techworldjsdockerdemoappwithnanamaster                      latest    316206c4e2b5   6 minutes ago   120MB
registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app   1.1       316206c4e2b5   6 minutes ago   120MB
my-app                                                      1.1       316206c4e2b5   6 minutes ago   120MB
my-app                                                      1.0       3f11185e9db7   8 days ago      120MB
registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app   1.0       3f11185e9db7   8 days ago      120MB
redis                                                       latest    5f2e708d56aa   2 weeks ago     117MB
postgres                                                    latest    9f3ec01f884d   2 weeks ago     379MB
mongo                                                       latest    0850fead9327   7 weeks ago     700MB
mongo-express                                               latest    2d2fb2cabc8f   15 months ago   136MB
hello-world                                                 latest    feb5d9fea6a5   16 months ago   13.3kB
scrapinghub/splash                                          latest    9364575df985   2 years ago     1.89GB
redis                                                       4.0       191c4017dcdd   2 years ago     89.3MB
```

Now we get *registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app* with 1.1

`docker push registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app:1.1 `

```
The push refers to repository [registry.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app]
85a25254d27e: Pushed 
5f70bf18a086: Layer already exists 
90d659dcf120: Pushed 
ea1c7308a3c1: Layer already exists 
629960860aca: Layer already exists 
f019278bad8b: Layer already exists 
8ca4f4055a70: Layer already exists 
3e207b409db3: Layer already exists 
1.1: digest: sha256:724f4a71fc3521193f319df7b01ee9f6583e208c5afb8abe1e319a6bc4c240e1 size: 1990
```

Check my private repository on Alibaba Cloud, the docker images with tag 1.1 and 1.0 are demonstrated.

## 11. Deploy Containerized App

### Images from Repository

- Change the **Compose file**, add another service which refers to our private repository on Alibaba Cloud.

  - Docker compose file would be used on the server to <u>deplay</u> all the applications.

- The server needs to login to pull from private repository, while docker login not needed for public repository.

  ```yaml
   my-app:
      image: registry-vpc.cn-hangzhou.aliyuncs.com/doriswang_docker/my-app:1.0
    ports:
        - 3000:3000

- Create a mongo.yaml file, insert the content of docker-composed file after the extra addition, then type `:wq` to save it.

  `vim mongo.yaml` , to open the interaction window

- Start all three containers, then the app is listening on port 3000.

  `docker-compose -f mongo.yaml up`

## 12. Docker Volumes(For Persisting Data)

### When do We Need Volumes?

- For data persistence with databases or other stateful applications.
- Data ususally is stored in virtual file system without persistent when restarting or removing the container, data is gone.

### What is a Docker Volume?

- Folder in physical host file system is mounted/pluged into virtual file system of Docker.
- Container writes to its file system and data gets automatically replicated, vice versa.
- When the container restart, it gets data from host without dropping.

### Three Types of Volume

With `docker run` or `docker-compose` command,

#### 1. Host Volumes

- Format: **docker run -v hostDirectory:containerDirectory**
- Feature: you decide where on the <u>host file system</u> the reference is made. Namely, which folder of host file system you mount into the container.

#### 2. Anonymous Volumes

- Format: **docker run -v containerDirectory**
  - Directory is automatically created by Docker. For each container, a folder is generated that gets mounted to the container.
- Feature: without reference to this automatically generated folder.

#### 3. Named Volumes

- Format: **docker run -v name:containerDirectory**
- Feature: specify the name of the folder on the host system, and the name is decided by ourselves.
- Mostly used in production.

We can mount the one volumen name or reference to <u>multiple</u> containers. (relationship 1:n)

## 13. Docker Volumes Demo

### Start Point: No Persistence

`docker-compose -f docker-compose.yaml up`, without volumes first.

It will return *app listening on port 3000!* Open the `localhost:8080` on Chrome, create *my-db* database and *users* collection.

`npm run start`, then open `localhost:3000` on Chrome. Insert new data to database, after restarting the new data will be dropped.

### Volumes on Docker Compose

```yaml
#inside of mongodb container    
    volumes:
     - mongo.data:/data/db #map the host volume name with path inside of the container, which is mongodb persist the data by default
 #.........
Volumes:
  mongo-data: #the name of the volume reference
    driver: local #the actual storage paires in local file system
```

We can check out where mongoDB store the data in our computer by

`docker ps` to get the containerID of mongoDB

`docker exec -it 35a8aca52c90 sh` ,open the z-shell command program for this container

`ls /data/db`

```
WiredTiger			     collection-0-8231400502756039432.wt  index-1-8231400502756039432.wt  journal
WiredTiger.lock			     collection-0-9053486474110370503.wt  index-1-9053486474110370503.wt  mongod.lock
WiredTiger.turtle		     collection-2-9053486474110370503.wt  index-3-9053486474110370503.wt  sizeStorer.wt
WiredTiger.wt			     collection-4-9053486474110370503.wt  index-5-9053486474110370503.wt  storage.bson
WiredTigerHS.wt			     collection-7-9053486474110370503.wt  index-6-9053486474110370503.wt
_mdb_catalog.wt			     diagnostic.data			  index-8-9053486474110370503.wt
collection-0-6933331040428374077.wt  index-1-6933331040428374077.wt	  index-9-9053486474110370503.wt
```

`exit`

### Restart the Docker Compose and See the Functionality

`docker-compose -f docker-compose.yaml down` we first close the old docker compose file.

```
[+] Running 4/4
 ⠿ Container techworld-js-docker-demo-app-with-nana-master-my-app-1         Removed                                          0.1s
 ⠿ Container techworld-js-docker-demo-app-with-nana-master-mongo-express-1  Removed                                          1.0s
 ⠿ Container techworld-js-docker-demo-app-with-nana-master-mongodb-1        Removed                                          0.8s
 ⠿ Network techworld-js-docker-demo-app-with-nana-master_default            Removed                                          0.1s

```

`docker-compose -f docker-compose.yaml up` restart it.

We update the database by `localhost:3000` and `localhost:8080` on Chrome.

Then we close and restart once again, we check them out on Chrome, the data are persisted.

### Docker Volumes Locations

- **/var/lib/docker/volumes**
- Each volumes has its unique position end with **_data**

- Docker for Mac creates a <u>Linux virtual machine</u> and stores all the Docker data here.







