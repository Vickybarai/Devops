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

## 🐧 Docker Installation on Ubuntu (Official Method)

> Source: Docker Official Ubuntu Installation Guide

---

### 🔹 Step 1: Update Package Index

```bash
sudo apt update
```

📌 **Meaning**:
Refreshes the local package list from Ubuntu repositories.

---

### 🔹 Step 2: Install Required Packages

```bash
sudo apt install ca-certificates curl
```

📌 **Why needed?**

* `ca-certificates` → verifies HTTPS certificates
* `curl` → downloads Docker GPG key securely

---

### 🔹 Step 3: Create Keyrings Directory

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

📌 **Meaning**:

* Creates a secure directory to store trusted GPG keys
* `0755` → read & execute permissions

---

### 🔹 Step 4: Download Docker GPG Key

```bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
```

📌 **Why?**

* Verifies Docker packages are authentic
* Prevents malicious or tampered packages

---

### 🔹 Step 5: Set Key Permissions

```bash
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

📌 **Meaning**:

* Allows all users to read the key
* Required for APT package verification

---

### 🔹 Step 6: Add Docker Repository

```bash
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

📌 **Explanation (Interview Depth)**:

* Adds Docker’s official repository
* Uses Ubuntu version dynamically
* Ensures only signed Docker packages are installed

---

### 🔹 Step 7: Update Package Index Again

```bash
sudo apt update
```

📌 **Why again?**

* Ubuntu now fetches packages from Docker’s repo

---

## 📦 Install Docker Engine

```bash
sudo apt install docker-ce docker-ce-cli containerd.io
```

📌 Components:

* `docker-ce` → Docker Engine
* `docker-ce-cli` → Docker CLI
* `containerd.io` → Container runtime

---

## 🧪 Verify Installation

```bash
docker --version
```

```bash
sudo docker run hello-world
```

✔ Confirms Docker is installed and running correctly.




----------------------------------------------------------

## 🧰 Docker Commands Cheat Sheet (Interview Favorite)

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

## 🎯 Quick Answers 

* **Docker vs VM**: Containers share OS kernel, VMs don’t
* **Why Docker?**: Faster deployments, consistency, scalability
* **Detached mode?**: Runs container in background
* **docker run vs docker start?**: `run` creates + starts, `start` only starts
* **Port mapping?**: Exposes container services to host

---
