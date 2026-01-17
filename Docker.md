# 🐳 Docker Fundamentals & Installation (Ubuntu)

---
### 🔹 What is Docker?

**Docker is an open-source containerization platform** that allows you to package applications along with their dependencies into lightweight, portable containers.



### 🔹 What is a Container?

A **container** is a lightweight, isolated runtime environment that includes:

* Application code
* Libraries
* Dependencies
* Runtime

Containers **share the host OS kernel**, making them faster than virtual machines.

### 🔹 What is Containerization?

**Containerization** is the process of packaging an application and its dependencies into a container so it can run consistently across environments.

✔ Faster startup
✔ Less resource usage
✔ High portability

---

## 🏗️ Architecture Comparison (Very Important)

### 🔸 Monolithic Architecture

* Single large application
* Tightly coupled components
* One failure can bring down the whole app

📌 Example:
A single WAR/JAR file running entire backend.

❌ Hard to scale
❌ Slow deployments


### 🔸 Microservices Architecture

* Application split into small independent services
* Each service runs in its own container
* Communicates via APIs

📌 Example:
Auth service, payment service, product service (all separate)

✅ Easy scaling
✅ Faster deployments
✅ Fault isolation

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

🐧 Docker Installation on Ubuntu (Official Method)

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



## 🎯 Quick Answers 
**Q. Docker vs VM**
👉 Containers share OS kernel, VMs don’t

**Q. Why Docker?**
👉 Faster deployments, consistency, scalability

**Q. Detached mode?**
👉 Runs container in background

**Q. docker run vs docker start?**
👉  `run` creates + starts, `start` only starts

**Q. Port mapping?**
👉 Exposes container services to host

**Q. Difference between image and container?**
👉 Image is static, container is running instance.

**Q. What is a dangling image?**
👉 An image with no tag and not used by any container.

**Q. Where are Docker images stored?**
👉 In Docker’s local storage (`/var/lib/docker`).

**Q. Why images are layered?**
👉 For caching, reuse, and faster builds.

---
