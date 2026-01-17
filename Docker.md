# 🐳 Docker Fundamentals & Installation (Ubuntu)

---

## 📌 What You Will Learn

✅ Docker & Containerization concepts

✅ Monolithic vs Microservices

✅ Virtualization vs Containerization

✅ Docker installation on Ubuntu (official method)

✅ Essential Docker commands (with meaning)
---


### 🔹 What is Docker?

**Docker is an open-source containerization platform** that allows you to package applications along with their dependencies into lightweight, portable containers.

---

### 🔹 What is a Container?

A **container** is a lightweight, isolated runtime environment that includes:

* Application code
* Libraries
* Dependencies
* Runtime

Containers **share the host OS kernel**, making them faster than virtual machines.

---

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

---

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

-----------------------------------------------------------------------

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




---------------------------------------------------------------------------------------------------------------------------------------------



## 🧰 <h1>Docker Commands Cheat Sheet </h1>
---

### ▶ Run a Container

```bash
docker run [ContainerImage]
```

Runs a container from an image.

---

### ▶ Run in Detached Mode

```bash
docker run -d [ContainerImage]
```

Runs container in background.

---

### ▶ List Running Containers

```bash
docker ps
```

---

### ▶ List All Containers

```bash
docker ps -a
```

---

### ▶ Create Container (Not Start)

```bash
docker create [ContainerImage]
```

---

### ▶ Start Container

```bash
docker start [ContainerID]
```

---

### ▶ Stop Container

```bash
docker stop [ContainerID]
```

---

### ▶ Remove Container

```bash
docker rm [ContainerID]
```

---

### ▶ Force Remove Container

```bash
docker rm -f [ContainerID]
```

---

### ▶ Port Mapping

```bash
docker run -p [HostPort]:[ContainerPort] [ContainerImage]
```

📌 Example:

```bash
docker run -p 8080:80 nginx
```

---

### ▶ Access Container Shell

```bash
docker exec -it [ContainerID] bash
```

---

### ▶ Random Port Mapping

```bash
docker run -P [ContainerImage]
```

Maps container ports to random host ports (32768–61000).

---

### ▶ View Logs

```bash
docker logs [ContainerID]
```

---

### ▶ Resource Usage

```bash
docker stats [ContainerID]
```

---




## 📌 Docker Images Commands (Must-Know)
---

### ▶ List Docker Images

```bash
docker images
```

📘 Meaning:

* Displays all locally available Docker images
* Shows repository, tag, image ID, size

> Used to verify whether an image already exists locally.

---

### ▶ Pull Image from Docker Hub

```bash
docker pull nginx
```

```bash
docker pull nginx:latest
```

📘 Meaning:

* Downloads image from Docker Hub
* `latest` is the default tag

> Pulling does not run the container, it only downloads the image.

---

### ▶ Remove Docker Image

```bash
docker rmi [IMAGE_ID]
```

📘 Meaning:

* Deletes image from local system
* Container using the image must be stopped first

---

### ▶ Force Remove Image

```bash
docker rmi -f [IMAGE_ID]
```

📘 Meaning:

* Removes image even if containers depend on it

⚠️ Use carefully in production.

---

### ▶ Inspect Image (Very Important)

```bash
docker inspect [IMAGE_NAME]
```

📘 Meaning:

* Shows metadata of image
* Layers, environment variables, architecture

📌 Interview favorite:

> Helps in debugging and understanding image internals.

---

### ▶ Image History (Layers)

```bash
docker history [IMAGE_NAME]
```

📘 Meaning:

* Displays image layers
* Shows how image was built step-by-step

📌 Interview line:

> Docker images are built in layers to optimize caching.

---

### ▶ Tag an Image

```bash
docker tag nginx mynginx:v1
```

📘 Meaning:

* Creates a new tag for an existing image
* Commonly used before pushing to registry

---

### ▶ Push Image to Docker Hub

```bash
docker push mynginx:v1
```

📘 Meaning:

* Uploads image to Docker registry
* Requires `docker login`

---

### ▶ Remove Unused Images

```bash
docker image prune
```

📘 Meaning:

* Deletes dangling (unused) images
* Helps free disk space

---

### ▶ Remove All Unused Images

```bash
docker image prune -a
```

📘 Meaning:

* Removes all images not associated with containers

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
