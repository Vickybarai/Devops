# 🌐 Docker Practical Flow – NGINX & HTTPD

> This document demonstrates **container lifecycle**, **port mapping (80 vs random)**, **index.html editing**, **container IP access**, **cleanup**, **push/pull**, and **save/load** — exactly how interviewers expect you to explain Docker networking.

---

## 🧠 Interview Context

> Running NGINX and HTTPD containers helps validate **Docker networking**, **port exposure**, **container isolation**, and **image lifecycle**.

---

## 🧱 High-Level Flow

```
Pull Image
 → Run Container
 → Expose Port
 → Modify index.html
 → Access via Browser & Curl
 → Inspect IP
 → Cleanup Containers
 → Push / Pull Image
 → Save / Load Image
```

---

## 🖥️ Prerequisite: Create Instance & Install Docker (Ubuntu)

### Update system

```bash
sudo apt update
```

### Install Docker

```bash
sudo apt install -y docker.io
```

### Start & enable Docker

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### Verify Docker installation

```bash
docker --version
```

---

## 🔹 STEP 1: Run NGINX on Port 80 (Fixed Port)

```bash
docker run -d --name demonginx -p 80:80 nginx
```

**Explanation**

* `-d` → Run container in background
* `--name demonginx` → Assign container name
* `-p 80:80` → Host port 80 → Container port 80
* `nginx` → Image name

📌 
> Port mapping allows external traffic to reach services running inside containers.

---

## 🔹 STEP 2: Run HTTPD on Random Port

```bash
docker run -d --name demohttp -P httpd
```

**Explanation**

* `-P` → Automatically maps container ports to random host ports
* Random ports range: **32768–61000**

📌 

> `-P` is useful when you don’t care about a fixed port and want Docker to auto-assign.

---

## 🔹 STEP 3: Verify Running Containers

```bash
docker ps
```

✔ Shows container ID, image, status, and port mapping.

---

## 🔹 STEP 4: Modify NGINX `index.html`

```bash
docker exec -it demonginx bash
```

Inside container:

```bash
cat > /usr/share/nginx/html/index.html
Hello World from NGINX
```

Press **CTRL + D** to save and exit.

📌 

> `docker exec` lets you access a running container without restarting it.

---

## 🔹 STEP 5: Modify HTTPD `index.html`

```bash
docker exec -it demohttp bash
```

Inside container:

```bash
cat > /usr/local/apache2/htdocs/index.html
Hello World from HTTPD
```

Press **CTRL + D**.

---

## 🔹 STEP 6: Find Container IP Address

```bash
docker inspect demonginx | grep IPAddress
```

**Meaning**

* Displays internal container IP
* Used when container is **not exposed via ports**

---

## 🔹 STEP 7: Access Application (Browser & Curl)

### 🔸 NGINX (Port 80)

```text
http://localhost
```

### 🔸 HTTPD (Random Port)

Check mapped port:

```bash
docker ps
```

Open in browser:

```text
http://localhost:<random_port>
```

Or via curl:

```bash
curl http://localhost:<random_port>
```

---

## ⚠️ Interview Concept: Container Isolation

> If you do **not** use `-p` or `-P`, the container is **isolated**.

### Internet access?

❌ **NO**

### Internal access?

✅ **YES**

```bash
curl http://<container_ip>:80
```

📌 

> Without port mapping, containers are accessible only inside Docker’s private network.

---

## 🧹 STEP 8: Cleanup Containers (Professional Way)

List all container IDs:

```bash
docker ps -a -q
```

Remove all containers forcefully:

```bash
docker rm -f $(docker ps -aq)
```

📌 

> Commonly used during lab cleanup and CI test environments.

---

9.1 Docker Login (Correct & Secure Way)

> Docker no longer recommends password-based login.
Personal Access Tokens (PAT) are the industry standard in real-world DevOps.



✅ Prerequisites

Docker Hub account

Personal Access Token (Read/Write recommended)

Docker installed on EC2 / local machine



---

🔑 Login Using Token (Recommended & Secure)

docker login -u <dockerhub_username>

When prompted:

Username → Docker Hub username

Password → Paste your Personal Access Token (NOT account password)


✅ Expected output:

Login Succeeded

📌 :

> “Docker login uses token-based authentication instead of passwords for improved security.”




---

🧹 (Optional) Clean Login Fix – If Login Fails

docker logout
rm -f ~/.docker/config.json
docker login -u <dockerhub_username>

Used when:

Wrong credentials cached

Switching Docker Hub accounts

Token expired or rotated



---

9.2 Docker Images – Core Commands

📦 List Images

docker images

Lists all images available locally.


---

⬇️ Pull Images from Docker Hub

docker pull nginx
docker pull httpd

Downloads official images from Docker Hub registry.

📌 :

> Official images are maintained and security-scanned by Docker.




---

▶️ Run Container from Image

docker run -d --name demonginx -p 80:80 nginx
docker run -d --name demohttp -P httpd

Flags explained:

-d → Detached mode

-p → Fixed port mapping

-P → Random port mapping



---

🔍 Inspect Image / Container

docker inspect demonginx
docker inspect demohttp

Used to find:

Container IP address

Exposed ports

Network & mount details


📌
> “docker inspect helps debug networking and runtime configuration issues.”




---

9.3 Create Custom Image (docker commit)

> ⚠️ Real-world note:
docker commit is for learning & debugging.
Dockerfile is used in CI/CD and production.

---

✏️ Modify Running Container (Example)

docker exec -it demonginx bash
echo "Hello from Custom NGINX" > /usr/share/nginx/html/index.html
exit


---

🧱 Create Image from Container

docker commit demonginx <dockerhub_username>/demonginx:v1

Creates a reusable custom image from a running container.

📌

> “docker commit snapshots container state into an image.”




---

9.4 Push Image to Docker Hub

⬆️ Push Image

docker push <dockerhub_username>/demonginx:v1

Uploads image to your Docker Hub repository.


---

9.5 Pull & Run Image from Docker Hub

⬇️ Pull

docker pull <dockerhub_username>/demonginx:v1

▶️ Run

docker run -d -p 8080:80 <dockerhub_username>/demonginx:v1

Access via:

http://localhost:8080


---

9.6 Image Cleanup Commands

🗑️ Remove Image

docker rmi <image_id>

🧹 Remove All Unused Images

docker image prune

Used to:

Free disk space

Clean unused layers

Optimize servers



---

9.7 Save & Load Images (Offline / Air-Gapped)

💾 Save Image to File

docker save -o demonginx.tar <dockerhub_username>/demonginx:v1

📂 Load Image from File

docker load -i demonginx.tar

Used when:

No internet access

Air-gapped servers

Backup & migration



---
---



## ⚡ Quick Interview Q&A (High-Frequency)

**Q1. `-p` vs `-P`?**
👉 `-p` = manual
👉 `-P` = automatic

**Q2. Access container without port mapping?**
👉 Browser ❌
👉 Internal curl ✅

**Q3. `docker commit` vs Dockerfile?**
👉 Commit = manual snapshot
👉 Dockerfile = automated & repeatable

**Q4. save/load vs push/pull?**
👉 save/load = offline
👉 push/pull = registry required

**Q5. What happens in `docker run`?**
👉 pull → create → network → start

📌 Interview line

> `docker run = docker pull + docker create + docker start`

**Q6. Why random ports 32768–61000?**
👉 Avoid system port conflicts

**Q7. Default Docker networking?**
👉 Bridge network + private IP + NAT

**Q8. EXPOSE vs `-p`?**
👉 EXPOSE = documentation
👉 `-p` = actual port open

**Q9. Port conflict scenario?**
👉 Second container fails to start

**Q10. When to use `docker inspect`?**
👉 IP, ports, env vars, volumes

**Q11. stop vs kill?**
👉 stop = graceful
👉 kill = force

**Q12. Dangling image?**
👉 Untagged & unused

**Q13. Move images without internet?**
👉 `docker save` + `docker load`

**Q14. Security risk of port 80?**
👉 Public exposure → firewall needed

**Q15. Lightweight isolation?**
👉 Namespaces + cgroups

**Q16. Container IP vs Host IP?**
👉 Internal vs external

**Q17. Container-to-container communication?**
👉 Docker networks + container name

---
