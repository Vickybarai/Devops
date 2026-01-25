
---

# 🐳 Docker

---

## 🔹 What is Docker?

Docker is an **open-source containerization platform** that enables developers and operations teams to **build, package, ship, and run applications** in isolated environments called **containers**.

From a systems and platform engineering perspective, Docker standardizes and abstracts:

* Application runtime
* Dependencies and libraries
* Environment configuration

into a **single, immutable unit** that runs consistently across **development, testing, and production** environments.

📌 **Key Benefit**
Docker eliminates the *“works on my machine”* problem by enforcing runtime consistency.

---

## 🔹 What is a Container?

A **container** is a **lightweight, isolated process** that runs on a shared host operating system kernel using Linux kernel primitives such as:

A container includes:

* Application binaries
* Required libraries
* Dependencies
* Runtime configuration

### 🔑 Technical Insight

Containers are **not virtual machines**.

| Containers            | Virtual Machines          |
| --------------------- | ------------------------- |
| Share host OS kernel  | Run a full guest OS       |
| Lightweight           | Heavyweight               |
| Start in seconds      | Slow boot times           |
| Low resource overhead | High resource consumption |

This architectural difference enables containers to:

* Start almost instantly
* Consume fewer system resources
* Support high-density deployments

---

## 🔹 What is Containerization?

**Containerization** is the process of packaging an application together with its dependencies and configuration into a **single deployable unit** that behaves identically across environments.

From an operational standpoint, containerization ensures:

* Environment consistency
* Predictable deployments
* Reduced configuration drift

### Key Advantages

* **Fast startup** – no operating system boot required
* **Efficient resource usage** – shared kernel model
* **High portability** – runs anywhere Docker is available


Containerization decouples applications from underlying infrastructure.

---

## 🏗️ Architecture Comparison

---

### 🔸 Monolithic Architecture

In a **monolithic architecture**, the entire application is developed, deployed, and scaled as a single unit.

**Characteristics**

* Single codebase
* Tightly coupled components
* Shared memory and runtime

📌 **Example**
A single WAR or JAR file containing UI, business logic, and database access.

**Limitations**

* Scalability bottlenecks — entire application must scale together
* Slow deployments — small changes require full redeployment
* Large blast radius — one failure can impact the entire system

> Monoliths are simple to begin with but difficult to scale and evolve.

---

### 🔸 Microservices Architecture

In a **microservices architecture**, the application is decomposed into small, independent services, each responsible for a specific business capability.

**Characteristics**

* Independently deployable services
* Each service runs in its own container
* Communication via APIs (REST, gRPC, messaging systems)

📌 **Example**

* Authentication service
* Payment service
* Product service

Each service can be developed, deployed, and scaled independently.

**Advantages**

* Independent scaling — scale only what is required
* Faster deployments — smaller, isolated releases
* Fault isolation — failures are contained to individual services

📌 **Key Insight**
Docker and containerization are foundational enablers of microservices architecture.

---

## ⚙️ Traditional vs Virtualization vs Containerization

| Feature        | Traditional | Virtualization | Containerization |
| -------------- | ----------- | -------------- | ---------------- |
| OS             | One OS      | Multiple OS    | Shared OS Kernel |
| Performance    | High        | Medium         | Very High        |
| Boot Time      | Fast        | Slow           | Instant          |
| Resource Usage | High        | High           | Low              |
| Isolation      | Low         | Strong         | Process-level    |

> Containers are lighter than VMs because they **do not need a separate OS**.
---

## 🐳 Docker Installation (Ubuntu)

| **Command**                                                                                    | **Simple Meaning**                                                       |
| ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `sudo apt update`                                                                              | Updates the package list so Ubuntu knows about the latest software.      |
| `sudo apt install ca-certificates curl`                                                        | Installs tools needed to securely download Docker files.                 |
| `sudo install -m 0755 -d /etc/apt/keyrings`                                                    | Creates a safe folder to store Docker’s security key.                    |
| `sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc` | Downloads Docker’s official security key to ensure trusted installation. |
| `sudo chmod a+r /etc/apt/keyrings/docker.asc`                                                  | Allows the system to read Docker’s security key.                         |
| `sudo tee /etc/apt/sources.list.d/docker.sources <<EOF ... EOF`                                | Adds Docker’s official repository to Ubuntu.                             |
| `sudo apt update`                                                                              | Updates the package list again to include Docker packages.               |
| `sudo apt install docker-ce docker-ce-cli containerd.io`                                       | Installs Docker Engine, command-line tools, and container runtime.       |
| `docker --version`                                                                             | Checks if Docker is installed successfully.                              |
| `sudo docker run hello-world`                                                                  | Runs a test container to confirm Docker is working correctly.            |


---

# 🧾 Docker Commands — 


---

## 1. Docker Engine & System
| Command | Description |
|------|------------|
| docker --version | Check Docker version |
| docker version | Client & Server version info |
| docker info | Docker engine configuration |
| docker system df | Disk usage by Docker |
| docker system prune | Remove unused objects |
| docker system prune -a --volumes | Full cleanup |
| docker events | Real-time Docker events |

### Docker Service (Linux)

| Command | Description |
|------|------------|
| systemctl start docker | Start Docker service |
| systemctl stop docker | Stop Docker service |
| systemctl restart docker | Restart Docker |
| systemctl status docker | Check Docker status |

---

## 2. Images (Image Management)

| Command | Description |
|------|------------|
| docker images | List local images |
| docker pull image | Download image |
| docker push image | Push image to registry |
| docker rmi image | Remove image |
| docker rmi -f image | Force remove image |
| docker tag img newimg | Tag image |
| docker history image | Show image layers |
| docker inspect image | Inspect image |
| docker save img > img.tar | Save image to file |
| docker load < img.tar | Load image from file |

---

## 3. Containers (Lifecycle Management)

| Command | Description |
|------|------------|
| docker run image | Create & start container |
| docker run -d image | Run in background |
| docker create image | Create container only |
| docker start container | Start container |
| docker stop container | Stop container |
| docker restart container | Restart container |
| docker pause container | Pause container |
| docker unpause container | Resume container |
| docker rm container | Remove container |
| docker rm -f container | Force remove |

---

## 4. Container Listing & Monitoring

| Command | Description |
|------|------------|
| docker ps | List running containers |
| docker ps -a | List all containers |
| docker ps -q | Show container IDs |
| docker logs container | View logs |
| docker logs -f container | Live logs |
| docker stats | Resource usage |
| docker top container | Running processes |
| docker inspect container | Container details |
| docker diff container | File system changes |

---

## 5. Execute Commands Inside Container

| Command | Description |
|------|------------|
| docker exec -it container bash | Shell access |
| docker exec container command | Run command |
| docker attach container | Attach terminal |
| docker cp src dest | Copy files |
| docker rename old new | Rename container |

---

## 6. Networking

| Command | Description |
|------|------------|
| docker network ls | List networks |
| docker network create net | Create network |
| docker network inspect net | Inspect network |
| docker network connect net cont | Connect container |
| docker network disconnect net cont | Disconnect container |
| docker network rm net | Remove network |
| docker run -p 8080:80 image | Port mapping |
| docker run -P image | Random port mapping |

---

## 7. Volumes (Persistent Storage)

| Command | Description |
|------|------------|
| docker volume ls | List volumes |
| docker volume create vol | Create volume |
| docker volume inspect vol | Inspect volume |
| docker volume rm vol | Remove volume |
| docker run -v vol:/path image | Mount volume |
| docker volume prune | Cleanup volumes |

---

## 8. Build & Dockerfile

| Command | Description |
|------|------------|
| docker build . | Build image |
| docker build -t app:1.0 . | Build with tag |
| docker build -f Dockerfile.dev . | Custom Dockerfile |
| docker build --no-cache . | Disable cache |
| docker builder prune | Remove build cache |
| docker commit cont img | Create image from container |

---

## 9. Registry / Docker Hub

| Command | Description |
|------|------------|
| docker login | Login to Docker Hub |
| docker logout | Logout |
| docker search image | Search images |
| docker tag img user/img:tag | Prepare for push |
| docker push user/img:tag | Push image |

---

## 10. Backup & Migration

| Command | Description |
|------|------------|
| docker save img > img.tar | Backup image |
| docker load < img.tar | Restore image |
| docker export cont > cont.tar | Export container |
| docker import cont.tar img | Import container |

---

docker create [image]	Create only
docker start [container]	Start
docker stop [container]	Stop
docker restart [container]	Restart
docker pause [container]	Pause
docker unpause [container]	Resume
docker rm [container]	Remove
docker rm -f [container]	Force remove



---

4️⃣ Container Listing & Monitoring

Command	Purpose

docker ps	Running containers
docker ps -a	All containers
docker logs [container]	Logs
docker logs -f [container]	Live logs
docker stats	CPU/RAM usage
docker top [container]	Processes
docker inspect [container]	Container details
docker diff [container]	File changes



---

5️⃣ Command Execution Inside Container

Command	Purpose

docker exec -it cont bash	Interactive shell
docker exec cont ls /app	Run command
docker attach [container]	Attach terminal
docker cp file cont:/path	Copy host → container
docker cp cont:/path file	Copy container → host



---

6️⃣ Networking

Command	Purpose

docker network ls	List networks
docker network create net1	Create network
docker network inspect net1	Inspect network
docker network connect net1 cont	Connect container
docker network disconnect net1 cont	Disconnect
docker network rm net1	Remove network
docker run -p 8080:80 nginx	Port mapping



---

7️⃣ Volumes (Storage Layer)

Command	Purpose

docker volume ls	List volumes
docker volume create vol1	Create volume
docker volume inspect vol1	Inspect volume
docker volume rm vol1	Remove volume
docker run -v vol1:/data nginx	Attach volume
docker volume prune	Cleanup unused



---

8️⃣ Build & Dockerfile

Command	Purpose

docker build .	Build image
docker build -t app:1.0 .	Build with tag
docker build --no-cache .	No cache build
docker builder prune	Clear build cache
docker commit cont img	Image from container



---

9️⃣ Registry / Docker Hub

Command	Purpose

docker login	Login
docker logout	Logout
docker search nginx	Search images
docker tag img user/img:tag	Prepare for push
docker push user/img:tag	Push to Hub



---

🔟 Backup / Migration

Command	Purpose

docker save img > img.tar	Backup image
docker load < img.tar	Restore image
docker export cont > cont.tar	Export container
docker import cont.tar img	Create image



---
