🌐 Docker Practical Flow – NGINX & HTTPD 

---

🧱 High-Level Flow (Mental Model)

Pull Image
 → Run Container
 → Expose Port
 → Edit index.html
 → Access (Browser / curl)
 → Inspect IP
 → Commit Image
 → Login
 → Push / Pull
 → Save / Load
 → Cleanup


---

🖥️ Prerequisites (Ubuntu)

Update OS

sudo apt update

Install Docker

sudo apt install -y docker.io

Start & Enable

sudo systemctl start docker
sudo systemctl enable docker

Verify

docker --version


---

🔹 STEP 1: Run NGINX (Fixed Port 80)

docker run -d --name demonginx -p 80:80 nginx

Meaning (Easy)

-d → background

--name → readable name

-p 80:80 → host:container

nginx → image


📌 Interview line: Fixed port mapping is used for predictable access.


---

🔹 STEP 2: Run HTTPD (Random Port)

docker run -d --name demohttp -P httpd

Meaning

-P → Docker auto-assigns a free host port (32768–61000)


Find port:

docker ps

📌 Interview line: -P avoids port conflicts.


---

🔹 STEP 3: Verify Containers

docker ps

Shows: ID | Image | Status | Ports


---

🔹 STEP 4: Edit NGINX index.html

docker exec -it demonginx bash

Inside:

echo "Hello World from NGINX" > /usr/share/nginx/html/index.html
exit


---

🔹 STEP 5: Edit HTTPD index.html

docker exec -it demohttp bash

Inside:

echo "Hello World from HTTPD" > /usr/local/apache2/htdocs/index.html
exit


---

🔹 STEP 6: Inspect Container IP (Internal Access)

docker inspect demonginx | grep IPAddress

📌 Used when no port mapping exists.


---

🔹 STEP 7: Access App

Browser

NGINX: http://localhost

HTTPD: http://localhost:<random_port>


curl

curl http://localhost
curl http://localhost:<random_port>


---

⚠️ Concept: Container Isolation

Without -p or -P

Browser ❌

Internal curl ✅



curl http://<container_ip>:80


---

🧹 STEP 8: Cleanup Containers

docker ps -aq
docker rm -f $(docker ps -aq)


---

🔐 STEP 9: Docker Login (Token-Based)

docker login -u <dockerhub_username>

Password → Paste Personal Access Token


If issues:

docker logout
rm -f ~/.docker/config.json
docker login -u <dockerhub_username>

📌 Interview line: Token-based auth is industry standard.


---

📦 STEP 10: Image Commands (Core)

List Images

docker images

Pull Images

docker pull nginx
docker pull httpd

Inspect

docker inspect demonginx


---

🧱 STEP 11: Create Custom Image (docker commit)

docker exec -it demonginx bash
echo "Custom NGINX Image" > /usr/share/nginx/html/index.html
exit

docker commit demonginx <dockerhub_username>/demonginx:v1

📌 Note: Dockerfile is preferred in production.


---

⬆️ STEP 12: Push Image

docker push <dockerhub_username>/demonginx:v1


---

⬇️ STEP 13: Pull & Run Custom Image

docker pull <dockerhub_username>/demonginx:v1
docker run -d -p 8080:80 <dockerhub_username>/demonginx:v1

Access: http://localhost:8080


---

🗑️ STEP 14: Remove Containers & Images

Stop & Remove Containers

docker stop demonginx demohttp
docker rm demonginx demohttp

Remove Images

docker rmi nginx httpd
docker rmi <dockerhub_username>/demonginx:v1

Prune Unused

docker image prune


---

💾 STEP 15: Save & Load Images (Offline)

Save

docker save -o demonginx.tar <dockerhub_username>/demonginx:v1

Load

docker load -i demonginx.tar


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
