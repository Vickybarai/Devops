

# 🐳 Dockerfile Project: Simple Apache Web Server

A step-by-step guide for beginners to **build, run, and deploy a Docker image** using a basic Dockerfile.

---

## 📌 1. What is Docker? (Beginner Friendly)

| Term           | Meaning                                      |
| -------------- | -------------------------------------------- |
| **Image**      | Blueprint of your app (OS + software + code) |
| **Container**  | Running instance of an image                 |
| **Dockerfile** | Script with instructions to build an image   |
| **Tag**        | Version label for an image                   |
| **Repository** | Storage location on Docker Hub               |

---

## 🏗️ 2. Simple Dockerfile Example

```dockerfile
# COMMENT
FROM ubuntu:22.04

RUN apt update
RUN apt install apache2 -y

RUN echo "<h1>Hello, World!</h1>" > /var/www/html/index.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
```

### 🔹 Explanation of Instructions

| Instruction | Purpose                                       |
| ----------- | --------------------------------------------- |
| **FROM**    | Base OS image                                 |
| **RUN**     | Install software or run commands inside image |
| **EXPOSE**  | Open container port for access                |
| **CMD**     | Default command when container starts         |

---

## 🔨 3. Build Docker Image (Industry Way)

```bash
docker build -t <dockerhub-username>/<repo-name>:<tag> .
```

**Example:**

```bash
docker build -t myuser/project_demo:v1 .
```

**Why This Format Matters:**

Docker Hub requires `username/repository:tag`. Without this, **push will fail**.

---

## 🏷️ 4. Understanding Tags

| Tag      | Meaning                       |
| -------- | ----------------------------- |
| `latest` | Default tag if none specified |
| `v1`     | Version 1 of image            |
| `v2.1`   | Specific release              |
| `dev`    | Development build             |

---

### ❌ Common Wrong Tag Examples

| Command                           | Problem                          |
| --------------------------------- | -------------------------------- |
| `docker tag image demo_app`       | Missing username → local only    |
| `docker push demo_app`            | Docker tries public library repo |
| `docker tag img user/repo/app:v1` | Too many path levels             |
| `docker push user/repo`           | No tag specified                 |

---

### ⚠️ Consequences of Wrong Tag

| Mistake          | Result                            |
| ---------------- | --------------------------------- |
| Missing username | Push denied                       |
| Wrong repo name  | Repository not found              |
| No tag           | Defaults to `latest` unexpectedly |
| Local-only tag   | Image never reaches Docker Hub    |

---

## 🏷️ 5. Fixing Tagging Issues

1. Check images:

```bash
docker images
```

2. Tag properly:

```bash
docker tag IMAGE_ID username/repo:v1
```

---

## 🚀 6. Login to Docker Hub

```bash
docker login
```

**Tip:** Use a **Personal Access Token** instead of password.

---

## 📤 7. Push Image to Docker Hub

```bash
docker push username/repo:v1
```

✅ Result: Image is now **globally available** and ready to deploy.

---

## 🧪 8. Run Container (Testing Locally)

```bash
docker run -d -p 8080:80 username/repo:v1
```

Open browser:

```
http://localhost:8080
```

You should see: **"Hello, World!"**

---

## 🔍 9. Image vs Container

| Image            | Container        |
| ---------------- | ---------------- |
| Static blueprint | Running instance |
| Can be pushed    | Cannot be pushed |
| Versioned        | Dynamic          |
| Safe to share    | Temporary        |

---

## 📦 10. Professional Workflow (Copy-Paste)

```bash
docker build -t username/repo:v1 .
docker login
docker push username/repo:v1
docker run -d -p 8080:80 username/repo:v1
```

---

## 🧹 11. Cleanup Commands

```bash
docker ps            # Running containers
docker ps -a         # All containers
docker images        # List all images
docker stop <id>     # Stop container
docker rm <id>       # Remove container
docker rmi <image>   # Remove image
docker volume prune  # Remove unused volumes
```

---

## 🚨 12. Most Common Beginner Errors

| Error                     | Cause                     |
| ------------------------- | ------------------------- |
| push access denied        | Wrong repo name           |
| repository does not exist | Repo not created on Hub   |
| tag does not exist        | Image not tagged properly |
| login failed              | Wrong credentials         |

---

## 🧠 Key Takeaways

* Always **use `username/repository:tag`** format.
* Tagging mistakes = most common beginner failure.
* Volumes + Dockerfile + proper network = deployable, persistent app.
* Test locally before pushing.

-