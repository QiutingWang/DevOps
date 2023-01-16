# Docker Tutorial for Beginners

## 1. Docker

### What is Container Concepts?

- to pakeage application with all the necessary dependencies and configuration.
- Portable artifact, easily shared and moved around
- Make development and deployment processes more efficient

### Where do Containers Live?

- In container repository: for Postgres, Redis, Nodejs, Ngins...
- private repository of companies
- public repository for Docker container `DockerHub`

### How Container Improves the Application Development?

#### Before Docker Containers:

- Installation process are different on each OS environment.
- Multiple steps of  where could go wrong

#### With Containers

- Own isolated environment layer with linux images and everything packaged(PostgresSQL, Configuration, Start Script)
- Only 1 docker command to install the app, which is the same for different OS.
- run same application with mulitiple versions without any conflicts

### How Container Improves the Application Deployment?

#### Before Docker Containers

- Need to configure  and install everything directly on the operating system, leading to conficts with dependency version
- Misunderstanding between development team and operation team with textual guide of deployment

#### After Containers

- Developer and operator work together to package the application in a container
- No enviormental configuration needed on server except setting the docker runtime

## 2. Container

### What is a container?

- Make up with <u>layers of images</u>
- Most are linux image in small size(alpine), on the bottom
- On the top are application image, usually use Postgres:10.10
- only *different layers* are downloaded, the same layers will not be downloaded again.

#### Example:

```
docker run postgres
```

Then the terminal will install the Postgres automatically.

### Docker Image & Docker Container

#### Docker Image(Not running)

- the actual package:configuration, PostgresSQL,Start Script
- artifact that can be moved around

#### Docker Container(Running)

- pull the image on the local machine and start the application
- container envoirment is created
- Has port binded: talk to application running inside the container
- Container is a running environment for Image
- Virtual file system

## 3. Docker vs. Virtual Machine

### Components of Operating System

- 2 layers
  - OS kernel(the first layer)
    - Communiates with hardware: CPU and memory
  - Applications(the second layer)
    - Run on the kernel layer

### What part of the Operating System Virtualize?

- **Docke**r virtualizes the application layer using the kernel of the host.
- The **virtual machines** virtualize application and OS kernel layers, without using the kernel of host.

### Differences between Docker and Virtual Machine

- Size: Docker image much smaller than VM
- Speed: Docker container faster than VM
- Compatibility: Virtue machine of any operating system can run on any other operating system host, but Docker cannot.
  - to check whether the kernels are compatible with docker images version.
  - install `Docker ToolBox` to ensure that your hosts to run different docker images.

## 4. Installation

- Docker Desktop for Mac: https://docs.docker.com.zh.xy2401.com/docker-for-mac/
- Docker Toolbox for Mac: https://docs.docker.com.zh.xy2401.com/toolbox/toolbox_install_mac/

## 5. Docker Command Line

`docker pull redis` pulls the image from the repository to local environment.

`docker images`:gives you all the images you have locally

`docker run redis` (terminate it use `control+c`) : pulls(if not locally exists) and starts new container with a command working on image

`docker ps` =list running docker containers

`docker run -d redis`: docker container release is running in a detached mode with a **container ID** 

- return: `e87e4727d9be2cd84a72ea6bf5a48761bb91e4dd3d6bee8b31e9fb554b4ff2ad` if you want to restart it, docker container ID is needed.

`docker stop ContainerID` eg: `docker stop e87e4727d9be` Then stop running the container.

`docker start ContainerID` Then start the specific container again.

`docker ps -a` Show you all the containers history which lists running and stopped container. Then use the **shown ID** and restart it.

Suppose we have 2 versions of redis, we need 2 containers of redis images

`docker run redis:4.0`: pull the image and start the container with another version, then use `docker ps` it shows 2 versions of redis is running, and both containers open the <u>same port</u>.

#### Container Port vs. Host Port

- multiple containers can run on the host machine

- Laptop has several ports, binding the container and the specific port

  `docker run -pHostPort:ContainerPort redis` eg: `docker run -p6000:6379 redis`

  Return: 

  ```
  1:C 16 Jan 2023 03:53:49.992 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
  1:C 16 Jan 2023 03:53:49.992 # Redis version=7.0.7, bits=64, commit=00000000, modified=0, pid=1, just started
  1:C 16 Jan 2023 03:53:49.992 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
  1:M 16 Jan 2023 03:53:49.993 * monotonic clock: POSIX clock_gettime
  1:M 16 Jan 2023 03:53:49.994 * Running mode=standalone, port=6379.
  1:M 16 Jan 2023 03:53:49.994 # Server initialized
  1:M 16 Jan 2023 03:53:49.995 * Ready to accept connections
  ```

  `docker ps`

  Return:

  ```
  CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                    NAMES
  0dcca72ec74f        redis               "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:6000->6379/tcp   clever_brown
  ```

  `docker run -p6000:6379 -d redis`

  Start the second container with another host port, if bind this container with the same host post, the error will occur.

  `docker run -p6001:6379 redis:4.0`

  `docker ps`

  ```
  CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
  650ce95287d0        redis:4.0           "docker-entrypoint.s…"   6 seconds ago       Up 6 seconds        0.0.0.0:6001->6379/tcp   exciting_darwin
  acd16cd379fb        redis               "docker-entrypoint.s…"   4 minutes ago       Up 4 minutes        0.0.0.0:6000->6379/tcp   intelligent_tu
  ```

  Then 2 different versions of redis are running in the terminal, binded with different host posts with the same container port.

  ## 5. Debug Tricks

  - See what logs redis container is producing

    `docker logs containerID` eg: `docker logs 650ce95287d0`

    OR without container id, we use container name to specify

    `docker logs containerName` eg: `docker logs exciting_darwin`

  -  Container Name: randomly generated names when the container is created. We can rename it .

    `docker stop 650ce95287d0` we first stop the redis4.0 version container with specific name

    `docker run -d -p6001:6379 --name redis-older redis:4.0` rename it and create a docker container with binding porter for redis 4.0

    return: `650ce95287d0b0d7945904940c350616bcca7b02ebf3aecf8e6c4cf44aec6043`

    Check it `docker ps`

      return:

    ```
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
    ec9201030c9e        redis:4.0           "docker-entrypoint.s…"   35 seconds ago      Up 34 seconds       0.0.0.0:6001->6379/tcp   redis-older
    acd16cd379fb        redis               "docker-entrypoint.s…"   19 minutes ago      Up 19 minutes       0.0.0.0:6000->6379/tcp   intelligent_tu
    ```

    Then do it for redis as well, renaming it with `redis-latest` binding with host port 6000

    - check

    ```
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
    219a5e714f1a        redis               "docker-entrypoint.s…"   58 seconds ago      Up 57 seconds       0.0.0.0:6000->6379/tcp   redis-latest
    ec9201030c9e        redis:4.0           "docker-entrypoint.s…"   4 minutes ago       Up 4 minutes        0.0.0.0:6001->6379/tcp   redis-older
    ```

  - Docker exec: get the terminal of the running container

    `docker exec -it containerID /bin/bash`, then the cursor changed as `root@219a5e714f1a:/data#`

    - it: interactive terminal

    OR we can use containerName to replace containerID `docker exec -it containerName /bin/bash`

    Then we can do the operation with z-shell command directly.

    `root@219a5e714f1a:/data# exit`, then get out.

    

















