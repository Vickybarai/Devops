
# 🐳 Docker Image Deployment Guide  
A practical, end-to-end guide to building, tagging, and pushing Docker images the correct industry way.

---

## 📌 1. What is Docker (In Simple Terms)

| Term | Meaning |
|------|---------|
| Image | Blueprint of your app (code + OS + dependencies) |
| Container | Running instance of an image |
| Dockerfile | Script used to build an image |
| Tag | Version label of an image |
| Repository | Storage location on Docker Hub |

---

## 🏗️ 2. Basic Dockerfile Example

```dockerfile
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "<h1>Hello, World!</h1>" > /var/www/html/index.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]

What this does

Instruction	Purpose

FROM	Base OS image
RUN	Install software
EXPOSE	Open container port
CMD	Default startup command



---

🔨 3. Build Image (Correct Way)

docker build -t <dockerhub-username>/<repo-name>:<tag> .

Example

docker build -t myuser/project_demo:v1 .


---

🧠 Why This Format Matters

Docker Hub requires this format:

<username>/<repository>:<tag>

If you don’t follow this format, push will fail.


---

🏷️ 4. Understanding Tags (CRITICAL)

Tag = Version label of your image.

Tag	Meaning

latest	Default tag (not always newest)
v1	Version 1
v2.1	Specific release
dev	Development build



---

❌ Wrong Tagging Examples

Command	Problem

docker tag image demo_app	No username → local only
docker push demo_app	Docker tries public library repo
docker tag img user/repo/app:v1	Too many path levels
docker push user/repo	No tag specified



---

⚠️ What Happens If Tag Is Wrong?

Mistake	Result

Missing username	Push denied
Wrong repo name	Repository not found
No tag	Defaults to latest unexpectedly
Local-only tag	Image never reaches Docker Hub



---

🏷️ 5. How to Fix Wrong Tagging

Check images:

docker images

Tag correctly:

docker tag IMAGE_ID username/repo:v1


---

🚀 6. Login to Docker Hub

docker login

Use a Personal Access Token instead of password (recommended).


---

📤 7. Push Image to Docker Hub

docker push username/repo:v1

If successful:

✔ Image available globally

✔ Others can pull it

✔ Ready for deployment



---

🧪 8. Run Container (Testing)

docker run -d -p 8080:80 username/repo:v1

Access in browser:

http://SERVER-IP:8080


---

🔍 9. Difference: Image vs Container

Image	Container

Static	Running
Can be pushed	Cannot be pushed
Blueprint	Instance


Renaming containers does not affect image push.


---

📦 10. Professional Workflow

docker build -t username/repo:v1 .
docker login
docker push username/repo:v1

No re-tagging chaos.


---

🧹 11. Cleanup Commands

docker ps            # Running containers
docker ps -a         # All containers
docker images        # All images
docker stop <id>
docker rm <id>
docker rmi <image>


---

🚨 12. Most Common Beginner Errors

Error	Cause

push access denied	Wrong repo name
repository does not exist	Repo not created on Hub
tag does not exist	Image not tagged properly
login failed	Wrong credentials



---

🧠 Key Takeaway

Docker push success depends 100% on correct naming discipline.

Local Name ❌  
Container Name ❌  
Image ID Alone ❌  
username/repository:tag ✅


