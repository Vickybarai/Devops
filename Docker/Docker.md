

🐳 Docker

---


___

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



Here’s a clean, structured, beginner-to-intermediate Docker guide with definitions, explanations, and commands, ready for README or notes. I’ve included all the Docker topics you mentioned: Docker, Container, Image, Dockerfile, Volume, Network, Docker Hub, and Docker Compose (YAML).

No extra commentary, no comparisons unless structural, just definition → purpose → command → best practice.


---



🔹 What is a Container?

Definition
A container is a lightweight, isolated process running on a shared host OS kernel, containing application binaries, dependencies, and configuration.

Purpose

Isolates applications

Reduces resource usage

Enables high-density deployments


Command Example

docker run -d --name my-container nginx:latest

Best Practice

Use containers for consistent runtime environments

Avoid running multiple applications in a single container



---

🔹 What is Containerization?

Definition
Containerization packages an application with all its dependencies into a single deployable unit.

Purpose

Ensures environment consistency

Enables predictable deployments

Reduces configuration drift


Key Advantages

Fast startup

Efficient resource usage

High portability



---

🔹 What is a Docker Image?

Definition
A Docker image is a read-only template used to create containers. It contains filesystem, application code, dependencies, and configuration.

Purpose

Blueprint for containers

Enables reproducible deployments


Command Examples

docker build -t myapp:1.0 .
docker images

Best Practice

Tag images with versions

Keep images minimal



---

🔹 What is a Dockerfile?

Definition
A Dockerfile is a script containing instructions to build a Docker image.

Purpose

Automates image creation

Defines base image, dependencies, configuration, and startup commands


Command Example

FROM ubuntu:22.04
WORKDIR /app
COPY . .
RUN apt update && apt install -y python3
CMD ["python3", "app.py"]

Best Practice

Use multi-stage builds for optimized images

Keep instructions clear and minimal



---

🔹 What is a Volume?

Definition
A volume is a persistent storage area managed by Docker, independent of container lifecycle.

Purpose

Stores database or application data persistently

Shares data between containers


Command Examples

docker volume create my-volume
docker run -d -v my-volume:/data mysql:latest

Best Practice

Use named volumes

Avoid storing persistent data inside container filesystem



---

🔹 What is a Network?

Definition
A Docker network enables containers to communicate securely with each other and the host.

Purpose

Isolates container traffic

Allows service discovery using container names


Command Examples

docker network create my-network
docker run -d --name db --network my-network mysql
docker run -d --name app --network my-network myapp

Best Practice

Use bridge networks for isolated apps

Use overlay networks for multi-host environments



---

🔹 What is Docker Hub?

Definition
Docker Hub is a public registry to store, share, and pull Docker images.

Purpose

Centralized image distribution

Supports CI/CD workflows


Command Examples

docker login
docker push username/myapp:1.0
docker pull username/myapp:1.0

Best Practice

Use official images as base

Use private repositories for sensitive apps



---

🔹 What is Docker Compose (YAML)?

Definition
Docker Compose is a tool to define and run multi-container applications using a YAML file.

Purpose

Orchestrates multiple services

Defines networks, volumes, and environment variables


docker-compose.yml Example

version: '3.8'

services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: redhat
      MYSQL_DATABASE: studentdb
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - app-network

  backend:
    image: my-backend:1.0
    ports:
      - "8080:8080"
    environment:
      DB_HOST: db
    networks:
      - app-network

volumes:
  db-data:

networks:
  app-network:

Command Examples

docker-compose up -d
docker-compose down

Best Practice

Use environment variables for configuration

Keep services, volumes, and networks organized

Version control your docker-compose.yml


___


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

