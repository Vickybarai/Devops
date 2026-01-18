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

📌 Interview line

> Port mapping allows external traffic to reach services running inside containers.

---

## 🔹 STEP 2: Run HTTPD on Random Port

```bash
docker run -d --name demohttp -P httpd
```

**Explanation**

* `-P` → Automatically maps container ports to random host ports
* Random ports range: **32768–61000**

📌 Interview line

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

📌 Interview line

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

📌 Interview line

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

📌 Interview tip

> Commonly used during lab cleanup and CI test environments.

---

## 📥 STEP 9: Pull Images Explicitly

```bash
docker pull nginx
docker pull httpd
```

📌 Meaning

* Downloads images
* Does **not** start containers

---

## 📦 STEP 10: Commit Container as New Image

```bash
docker commit demonginx mydockerhubuser/demonginx:v1
```

📌 Meaning

* Saves container state as image
* Includes modified `index.html`

⚠️ Interview warning

> `docker commit` is not recommended for CI/CD. Dockerfile is preferred.

---

## 📤 STEP 11: Push Image to Docker Hub

Login first:

```bash
docker login
```

Push image:

```bash
docker push mydockerhubuser/demonginx:v1
```

---

## 📥 STEP 12: Pull Custom Image

```bash
docker pull mydockerhubuser/demonginx:v1
```

---

## ▶ STEP 13: Run Custom Image

```bash
docker run -d -p 8080:80 mydockerhubuser/demonginx:v1
```

Access:

```text
http://localhost:8080
```

---

## 💾 STEP 14: Save Image to TAR File

```bash
docker save -o demonginx.tar mydockerhubuser/demonginx:v1
```

📌 Use case

* Offline transfer
* Air-gapped environments

---

## 📂 STEP 15: Load Image from TAR File

```bash
docker load -i demonginx.tar
```

📌 Interview line

> `docker save/load` is used when Docker Hub or internet is unavailable.

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
