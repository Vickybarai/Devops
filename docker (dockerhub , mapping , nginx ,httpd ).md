
🌐 Docker Practical Flow – NGINX & HTTPD

> End-to-end Docker hands-on flow covering containers, ports, isolation, image lifecycle, registry usage, and cleanup.




---

🧱 FLOW

Pull Image
   ↓
Run Container
   ↓
Expose Port
   ↓
Modify index.html
   ↓
Access App (Browser / curl)
   ↓
Inspect Container
   ↓
Commit Image
   ↓
Login → Push → Pull
   ↓
Save / Load
   ↓
Cleanup

📌 Interview framing:

> This flow covers development → testing → packaging → distribution in Docker.




---

🖥️ Prerequisites (Ubuntu)

🔹 Update OS

sudo apt update


---

🔹 Install Docker

sudo apt install -y docker.io


---

🔹 Start & Enable Docker

sudo systemctl start docker
sudo systemctl enable docker

📌 Interview line:

> Docker runs as a daemon (dockerd) managed by systemd.




---

🔹 Verify Installation

docker --version


---

🔹 STEP 1: Run NGINX (Fixed Port Mapping)

docker run -d --name demonginx -p 80:80 nginx

Meaning (Beginner-Friendly)

-d → run in background

--name demonginx → human-readable container name

-p 80:80 → host port 80 mapped to container port 80

nginx → image name


📌 Interview line:

> Fixed port mapping is used when predictable access is required.




---

🔹 STEP 2: Run HTTPD (Random Port Mapping)

docker run -d --name demohttp -P httpd

Meaning

-P → Docker assigns a random host port

Port range: 32768–61000


Find assigned port:

docker ps

📌 Interview line:

> -P helps avoid port conflicts in shared environments.




---

🔹 STEP 3: Verify Running Containers

docker ps

Shows:

Container ID

Image

Status

Port mappings



---

🔹 STEP 4: Edit NGINX index.html

docker exec -it demonginx bash

Inside container:

echo "Hello World from NGINX" > /usr/share/nginx/html/index.html
exit

📌 Concept:

> Containers are isolated, but writable unless explicitly read-only.




---

🔹 STEP 5: Edit HTTPD index.html

docker exec -it demohttp bash

Inside container:

echo "Hello World from HTTPD" > /usr/local/apache2/htdocs/index.html
exit


---

🔹 STEP 6: Inspect Container IP (Internal Networking)

docker inspect demonginx | grep IPAddress

📌 Interview use-case:

> Used when containers communicate internally without port mapping.




---

🔹 STEP 7: Access the Applications

Browser

NGINX → http://localhost

HTTPD → http://localhost:<random_port>



---

curl

curl http://localhost

curl http://localhost:<random_port>


---

⚠️ Concept: Container Isolation

Without -p or -P:

Browser access ❌

Internal access ✅


Example:

curl http://<container_ip>:80

📌 Interview line:

> Containers are isolated by default; ports must be explicitly exposed.




---

🧹 STEP 8: Cleanup All Containers (Safe Pattern)

docker rm -f $(docker ps -aq)

📌 Interview note:

> -f stops and removes containers in one step.




---

🔐 STEP 9: Docker Login (Token-Based)

docker login -u <dockerhub_username>

When prompted:

Password → Paste Docker Hub Personal Access Token


If login issues occur:

docker logout
rm -f ~/.docker/config.json
docker login -u <dockerhub_username>

📌 Interview line:

> Token-based authentication is the industry standard for registries.




---

📦 STEP 10: Core Image Commands

List Images

docker images


---

Pull Images

docker pull nginx
docker pull httpd


---

Inspect Container/Image

docker inspect demonginx


---

🧱 STEP 11: Create Custom Image (docker commit)

> ⚠️ Educational purpose only. Dockerfile is preferred in production.



docker exec -it demonginx bash

Inside:

echo "Custom NGINX Image" > /usr/share/nginx/html/index.html
exit

Commit container to image:

docker commit demonginx <dockerhub_username>/demonginx:v1

📌 Interview line:

> docker commit captures container state as an image snapshot.




---

⬆️ STEP 12: Push Image to Docker Hub

docker push <dockerhub_username>/demonginx:v1


---

⬇️ STEP 13: Pull & Run Custom Image

docker pull <dockerhub_username>/demonginx:v1

docker run -d -p 8080:80 <dockerhub_username>/demonginx:v1

Access:

http://localhost:8080


---

🗑️ STEP 14: Remove Containers & Images

Stop & Remove Containers

docker stop demonginx demohttp
docker rm demonginx demohttp


---

Remove Images

docker rmi nginx
docker rmi httpd
docker rmi <dockerhub_username>/demonginx:v1


---

Prune Unused Images

docker image prune


---

💾 STEP 15: Save & Load Images (Offline Transfer)

Save Image

docker save -o demonginx.tar <dockerhub_username>/demonginx:v1


---

Load Image

docker load -i demonginx.tar

📌 Interview line:

> docker save/load is used for air-gapped or offline environments.






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
