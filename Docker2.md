# Docker Tutorial for Beginner2

## 6. General Workflow in Reality

- Workflow:

  Docker Hub→MongoDB& `JavaScript` to develop App→Git→Jenkins creates `Docker image`→push to docker repository →<u>Development server</u> pulls the image from private repository, JS application image, and Mongo DB from Docker Hub

- Two Containers:

  - Custom container
  - A public available MongoDB container

## 7. Developing with Containers

Case: JS and Node application, connect to MongoDB docker container

`docker pull mongo`

`docker pull mongo-express`

Run both mongodb and mongo-express containers to make the mangodb database available for application, and connect mongo-express with mongoldb container.

### Docker Network

- Docker creates isolated docker network where the containers are running in. Without local host, port number, etc., the containers can communicate with each other in the same isolated docker network, just by container names.

- While, the *applications* run outside of Docker, like NodeJS, connect them with local host and port number.

- Package the applications into its own docker image. Then it comes inside the isolated docker network, including index.html and  JS for frontend.

- The *brower* from outside the docker network, connecting with JS application with host name and porter number.

So, by default, docker provides some network.

`docker network ls`

*Return:*

```
NETWORK ID     NAME      DRIVER    SCOPE
17f57689d123   bridge    bridge    local
98263072485e   host      host      local
a27160cf1b85   none      null      local
```

`docker network create name`: create a new docker network with a given name. Eg:`docker network create mongo-network`

*Return:* `6cd84d9cab45064b8752fcaf727f62ffc2fb6727a6be07328773504d0aa2db75`

Check: `docker network ls`

Return:

```
NETWORK ID     NAME            DRIVER    SCOPE
17f57689d123   bridge          bridge    local
98263072485e   host            host      local
6cd84d9cab45   mongo-network   bridge    local
a27160cf1b85   none            null      local
```

### Run Mongo Container in Network

`docker run -p 27017:27017 -d -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --net mongo-network mongo`

Reference: https://hub.docker.com/_/mongo

`-p`: open the port of mongoDB on the host, by default the port number for mongodb is 27017

`-d`: in detached mode

`-e`: environmental variable related

`mongo`: declare the image name at final

*Return:*`b01b9268a9b46c1030b40b233f3155dfb56b46566e47c01b7340247d4d015619`

If we separate the command line apart, it is demonstrated as follow:

```
docker run -d\
-p 27017:27017\
-e MONGO_INITDB_ROOT_USERNAME=admin\
-e MONGO_INITDB_ROOT_PASSWORD=password\
--name mongodb\
--net mongo-network\
mongo
```

Then we check what is happening inside the mongo container

`docker logs b01b9268a9b46c1030b40b233f3155dfb56b46566e47c01b7340247d4d015619` with the specific containerID, then lots of activities are listed below.

### Run Mongo Express

References: https://hub.docker.com/_/mongo-express

`docker run -d -p 8081:8081 -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin -e ME_CONFIG_MONGODB_ADMINPASSWORD=password --net mongo-network --name mongo-express -e ME_CONFIG_MONGODB_SERVER=mongodb mongo-express`

- `ME_CONFIG_MONGODB_SERVER`: input the mongodb container name we have already set before

*Return*:`c28b1c0f8a0c75733d45aab847d7f887f9d598ee17990be2d8c303bd44a07803`

##### Search localhost:8081 in Chrome

![8081](4iwrrk.png)

We can create a new database call `user-account` in this UI webpage.

### Connect NodeJS Server with MongoDB Container

`docker ps`

```
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                      NAMES
c28b1c0f8a0c   mongo-express   "tini -- /docker-ent…"   16 minutes ago   Up 16 minutes   0.0.0.0:8081->8081/tcp     mongo-express
b01b9268a9b4   mongo           "docker-entrypoint.s…"   31 minutes ago   Up 31 minutes   0.0.0.0:27017->27017/tcp   mongodb
```

With MongoUI lcoalhost and port, the same as `server.js` file declared.

We create a new collection in user-account database called `users`. If we input the new user name and email, the profile will be updated automatically.

If we only want to check the last activity of MongoDB, then we input `docker logs containerID | tail`

Another way is to tape `docker logs -f` stream the activities, then after the result shown, we add `----------` line behind, update in the website to input new user information, then the new activity of container is listed automatically behind the dash line.

## 8. Docker Compose

- Purpose: for use **multiple docker containers**, we create a docker compose file write in **yaml** format. Take the whole docker comment with its configuration and map it into a file that we have a structured comment.
- Docker compose takes care of creatiing a common network.

### Create the Docker Compose File

```yaml
version:'3'
services:
  mongodb: #the name
    image:mongo #which container the image is built from
    ports:
     - 27017:27017  #Host:Container
    environment:
     - MONGO_INITDB_ROOT_USERNAME=admin
     - MONGO_INITDB_ROOT_PASSWORD=password
    volumes:
     - mongo-data:/data/db
  mongo-express:
    image: mongo-express
    ports: 
     - 8080:8080
    environment:
     - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
     - ME_CONFIG_MONGODB_ADMINPASSWORD=password
     - ME_CONFIG_MONGODB_SERVER=mongodb
  volumes:
   mongo-data:
    driver: local
```

Network configuration is not included in this file.

Start to use the docker compose file:

`docker-compose -f docker-compose.yaml up`

- `docker-compose.yaml`: file name
- `up`: start all the containers which are in the mongo.yaml

Then name called `Network techworld-js-docker-demo-app-with-nana-master_default ` is created in return.

Check`docker network ls`

return: the named network is in the list.

```
NETWORK ID     NAME                                                    DRIVER    SCOPE
17f57689d123   bridge                                                  bridge    local
98263072485e   host                                                    host      local
6cd84d9cab45   mongo-network                                           bridge    local
a27160cf1b85   none                                                    null      local
66e1d9f9d9bb   techworld-js-docker-demo-app-with-nana-master_default   bridge    local
```

When restart the container at **localhost:8080**,everything we have configured in the container previously is gone. Data is lost.

`Volume`: have persistency between the container restarts.

Start our application use `node server.js`, at **localhost:3000**.

### Stop the Containers

`docker-compose -f docker-compose.yaml down`

Return:

```
[+] Running 3/3
 ⠿ Container techworld-js-docker-demo-app-with-nana-master-mongodb-1        Removed                               0.0s
 ⠿ Container techworld-js-docker-demo-app-with-nana-master-mongo-express-1  Removed                               0.1s
 ⠿ Network techworld-js-docker-demo-app-with-nana-master_default            Removed                               0.1s
```

Check: `docker ps` and `docker network ls`

```
CONTAINER ID   IMAGE           COMMAND                  CREATED       STATUS       PORTS                      NAMES
c28b1c0f8a0c   mongo-express   "tini -- /docker-ent…"   5 hours ago   Up 5 hours   0.0.0.0:8081->8081/tcp     mongo-express
b01b9268a9b4   mongo           "docker-entrypoint.s…"   5 hours ago   Up 5 hours   0.0.0.0:27017->27017/tcp   mongodb
```

```
➜  techworld-js-docker-demo-app-with-Nana-master git:(main) ✗ docker network ls
NETWORK ID     NAME            DRIVER    SCOPE
17f57689d123   bridge          bridge    local
98263072485e   host            host      local
6cd84d9cab45   mongo-network   bridge    local
a27160cf1b85   none            null      local
```

## 9. Build Our Docker Image

### Dockerfile

- To deployed the application to the docker container, build in docker image from JS, Node.js backend application.
- Copy the content of applications into docker file.
- Use blueprint for building images, which is called dockerfile.

#### Syntax

- Reference: https://www.geeksforgeeks.org/what-is-dockerfile-syntax/

```dockerfile
FROM node  #define which image we start from and download, start by basing it on another image. For multiple images, dockerfile can have multiple FROM statements.Install node.
ENV MONGO_DB_USERNAME=admin\
    MONGO_DB_PWD=password     #optionally define environment variables,set the password and username
RUN mkdir -p /Desktop/techworld-js-docker-demo-app-with-nana-master/app #create the folder. It tells what process will be running inside the container at the run time. This directory is created inside of the container. RUN+any linux command is allowed.
COPY ./Desktop/techworld-js-docker-demo-app-with-nana-master/app #copy current folder files to /.../.../app folder, working on the host
CMD ["node","server.js"] #start the app with: "node server.js". It specifies the whole command to run, passing into ENTRYPOINT, to launch the software required in a container. CMD has to be only one, cannot be multiple.
```

- Other written format

```dockerfile
MAINTAINER Doris Wang <DorisWang0917@outlook.com> #defines the author who is creating this Dockerfile
ADD project.tar.gz /install/ #add some files, give instructions to copy new files, directories, remote URLs
ENTRYPOINT ["/start.sh"] #specifies the starting of the command expression to use when starting your container.
EXPOSE 3030 #maps a port into the container.
USER 4000 #sets which user’s container will run as, using fixed user name or number
WORKDIR /directory-name #to set the working directory for all future Dockerfile commands.
VOLUME [“/host/path” “/container/path/”] #defines ephemeral volumes
VOLUME [“/shared-data”] #defines shared volumes
```

### Use the Dockfile in Terminal

`docker build -t my-app:1.0 .`

- `-t`:tag
- `my-app`: the application name
- `1.0`: version
- `.`: directory

After running the command line, the image ID is created in return result. `sha256:3f11185e9db7be2c226d4fed8f276804c4ad3f69741d833a53a333b222d4df1b `

check with `docker images`

Return:

```
REPOSITORY           TAG       IMAGE ID       CREATED              SIZE
my-app               1.0       3f11185e9db7   About a minute ago   120MB
redis                latest    5f2e708d56aa   9 days ago           117MB
postgres             latest    9f3ec01f884d   9 days ago           379MB
mongo                latest    0850fead9327   6 weeks ago          700MB
mongo-express        latest    2d2fb2cabc8f   15 months ago        136MB
hello-world          latest    feb5d9fea6a5   16 months ago        13.3kB
scrapinghub/splash   latest    9364575df985   2 years ago          1.89GB
redis                4.0       191c4017dcdd   2 years ago          89.3MB
```

my-app is shown above.

### Start 'my-app' Container to Verify app and Environment Configuration 

`docker run my-app:1.0`

Return:`app listening on port 3000!`

check with `docker ps`

Return:

```
CONTAINER ID   IMAGE           COMMAND                  CREATED         STATUS         PORTS                      NAMES
62d8af210985   my-app:1.0      "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes                              busy_lewin
c28b1c0f8a0c   mongo-express   "tini -- /docker-ent…"   6 hours ago     Up 6 hours     0.0.0.0:8081->8081/tcp     mongo-express
b01b9268a9b4   mongo           "docker-entrypoint.s…"   7 hours ago     Up 7 hours     0.0.0.0:27017->27017/tcp   mongodb
```

```
docker logs 62d8af210985
return: app listening on port 3000!
```

Get the command line terminal `docker exec -it 62d8af210985 /bin/sh`

Then we are in the root directory

```
/Desktop/techworld-js-docker-demo-app-with-nana-master/app # ls
images             index.html         node_modules       package-lock.json  package.json       server.js
```

Check the environment 

```
/Desktop/techworld-js-docker-demo-app-with-nana-master/app # env
NODE_VERSION=13.14.0
HOSTNAME=62d8af210985
YARN_VERSION=1.22.4
SHLVL=1
HOME=/root
MONGO_DB_USERNAME=admin
TERM=xterm
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MONGO_DB_PWD=password
PWD=/Desktop/techworld-js-docker-demo-app-with-nana-master/app
```

Check the directory:

```
/Desktop/techworld-js-docker-demo-app-with-nana-master/app # ls /Desktop/techworld-js-docker-demo-app-with-nana-master/app/
images             index.html         node_modules       package-lock.json  package.json       server.js
```

If we modify the dockerfile, we need to recreate the image, by stop the container, remove the container, remove the image, then recreate it.

```shell
docker images #get the image id
docker ps #get the container id
docker stop 62d8af210985 #stop the container
docker rm 62d8af210985 #delete the container
docker rmi 3f11185e9db7 #delete the image
docker build -t my-app:1.0 . #re-build 
```

















