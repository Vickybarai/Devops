---

# 🐳 Docker Fundamentals

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

**🐧 Docker Installation (Ubuntu)**

| **Command**                                                                                    | **Meaning / What It Does**                                                                                          |
| ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `sudo apt update`                                                                              | Refreshes the local APT package index so the system is aware of the latest available packages.                      |
| `sudo apt install ca-certificates curl`                                                        | Installs security certificates for HTTPS validation and `curl` for secure data transfer from Docker servers.        |
| `sudo install -m 0755 -d /etc/apt/keyrings`                                                    | Creates a secure directory for storing trusted GPG keys with controlled permissions.                                |
| `sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc` | Downloads Docker’s official GPG key to verify package authenticity and prevent tampering.                           |
| `sudo chmod a+r /etc/apt/keyrings/docker.asc`                                                  | Grants read access to the GPG key so APT can validate Docker packages system-wide.                                  |
| `sudo tee /etc/apt/sources.list.d/docker.sources <<EOF ... EOF`                                | Registers Docker’s official repository, dynamically matching the Ubuntu version and enforcing signed packages only. |
| `sudo apt update`                                                                              | Re-syncs the package index to include Docker packages from the newly added repository.                              |
| `sudo apt install docker-ce docker-ce-cli containerd.io`                                       | Installs Docker Engine, Docker CLI, and the container runtime required to run containers.                           |
| `docker --version`                                                                             | Confirms Docker is installed and accessible from the command line.                                                  |
| `sudo docker run hello-world`                                                                  | Runs a test container to validate that Docker Engine is operational and correctly configured.                       |




---

# 🧾 Docker Commands — 
---

## 1️⃣ Info & Version

| **Command**        | **Meaning**                      |
| ------------------ | -------------------------------- |
| `docker --version` | Check installed Docker version   |
| `docker version`   | Client vs Server version details |
| `docker info`      | Docker engine configuration      |


## 2️⃣ Container (Lifecycle Management)

| **Command**                     | **Meaning**                 |
| ------------------------------- | --------------------------- |
| `docker run [image]`            | Create and start container  |
| `docker run -d [image]`         | Run container in background |
| `docker create [image]`         | Create container only       |
| `docker start [container_id]`   | Start container             |
| `docker stop [container_id]`    | Stop container              |
| `docker restart [container_id]` | Restart container           |
| `docker pause [container_id]`   | Pause container             |
| `docker unpause [container_id]` | Resume container            |
| `docker rm [container_id]`      | Remove stopped container    |
| `docker rm -f [container_id]`   | Force remove container      |


## 3️⃣ Container Listing & Bulk Operations

| **Command**                       | **Meaning**                   |
| --------------------------------- | ----------------------------- |
| `docker ps`                       | List running containers       |
| `docker ps -a`                    | List all containers           |
| `docker ps -q`                    | Show running container IDs    |
| `docker ps -a -q`                 | Show all container IDs        |
| `docker stop $(docker ps -q)`     | Stop all running containers   |
| `docker rm $(docker ps -a -q)`    | Remove all stopped containers |
| `docker rm -f $(docker ps -a -q)` | Remove all containers         |


## 4️⃣ Images

| **Command**                    | **Meaning**            |
| ------------------------------ | ---------------------- |
| `docker images`                | List local images      |
| `docker images -q`             | Show image IDs         |
| `docker pull [image]`          | Download image         |
| `docker rmi [image_id]`        | Remove image           |
| `docker rmi -f [image_id]`     | Force remove image     |
| `docker tag [image] [new_tag]` | Tag image              |
| `docker push [image]`          | Push image to registry |
| `docker history [image]`       | Show image layers      |
| `docker inspect [image]`       | Inspect image metadata |


## 5️⃣ Cleanup & Disk Management

| **Command**              | **Meaning**                 |
| ------------------------ | --------------------------- |
| `docker image prune`     | Remove dangling images      |
| `docker image prune -a`  | Remove unused images        |
| `docker container prune` | Remove stopped containers   |
| `docker network prune`   | Remove unused networks      |
| `docker volume prune`    | Remove unused volumes       |
| `docker system prune`    | Clean unused Docker objects |
| `docker system prune -a` | Aggressive cleanup          |
| `docker system df`       | Docker disk usage           |


## 6️⃣ Logs & Monitoring

| **Command**                     | **Meaning**                |
| ------------------------------- | -------------------------- |
| `docker logs [container_id]`    | View container logs        |
| `docker logs -f [container_id]` | Stream logs                |
| `docker stats`                  | Live resource usage        |
| `docker top [container_id]`     | Processes inside container |
| `docker events`                 | Docker event stream        |


## 7️⃣ Access & Execution

| **Command**                           | **Meaning**                 |
| ------------------------------------- | --------------------------- |
| `docker exec -it [container_id] bash` | Shell inside container      |
| `docker attach [container_id]`        | Attach to container output  |
| `docker cp src dest`                  | Copy files host ↔ container |


## 8️⃣ Networking

| **Command**                            | **Meaning**         |
| -------------------------------------- | ------------------- |
| `docker network ls`                    | List networks       |
| `docker network inspect [network]`     | Inspect network     |
| `docker run -p host:container [image]` | Port mapping        |
| `docker run -P [image]`                | Random port mapping |


## 9️⃣ Volumes (Persistence)

| **Command**                            | **Meaning**    |
| -------------------------------------- | -------------- |
| `docker volume ls`                     | List volumes   |
| `docker volume inspect [volume]`       | Inspect volume |
| `docker run -v host:container [image]` | Mount volume   |

---

