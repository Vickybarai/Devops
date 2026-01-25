
# 🐳 Dockerized EasyCRUD Application

### MariaDB + Spring Boot Backend + Frontend (Beginner Deployment Guide)

This project runs a **full-stack CRUD application** using Docker:

| Layer    | Technology       | Purpose              |
| -------- | ---------------- | -------------------- |
| Database | MariaDB          | Stores student data  |
| Backend  | Java Spring Boot | Business logic & API |
| Frontend | HTML/JS App      | User interface       |

We run everything using **containers**, in the correct order.

---

# 🧱 PHASE 1 — Database Setup (Foundation)

Backend cannot start without database. So DB comes first.

---

## Step 1: Create Volume (Data Safety)

**Why?**
Containers can be deleted. We don’t want database data to disappear.

MariaDB stores data in:

```
/var/lib/mysql
```

Create persistent volume:

```bash
docker volume create student-db-vol
```

✔ Now database files are stored outside container.

---

## Step 2: Start MariaDB Container

```bash
docker run -d \
 --name mariadb-container \
 -e MARIADB_ROOT_PASSWORD=redhat \
 -e MARIADB_DATABASE=studentdb \
 -v student-db-vol:/var/lib/mysql \
 mariadb:latest
```

What happens here:

| Setting          | Meaning          |
| ---------------- | ---------------- |
| Root password    | `redhat`         |
| Database created | `studentdb`      |
| Data stored in   | `student-db-vol` |

---

## Step 3: Get Database Container IP

Backend needs DB IP.

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mariadb-container
```

Example:

```
172.17.0.2
```

📌 Save this IP — used in backend config.

---

# ⚙️ PHASE 2 — Backend (Spring Boot API)

Backend connects frontend ↔ database.

---

## Step 4: Clone Code

```bash
git clone https://github.com/shubhamkalsait/EasyCRUD.git
cd EasyCRUD
git checkout -b deploy-fix
cd backend
```

---

## Step 5: Configure Database Connection

File:

```
src/main/resources/application.properties
```

```properties
server.port=8080
spring.datasource.url=jdbc:mariadb://172.17.0.2:3306/studentdb
spring.datasource.username=root
spring.datasource.password=redhat
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

✔ Backend now knows where DB is.

---

## Step 6: Backend Dockerfile (Multi-Stage)

```dockerfile
FROM maven:3.8.3-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

🧠 Stage 1 builds JAR
🧠 Stage 2 runs only JAR → smaller image

---

## Step 7: Build & Push Backend Image

```bash
docker build -t shubhamkalsait1/easycrud-backend:v1 .
docker push shubhamkalsait1/easycrud-backend:v1
```

---

# 🎨 PHASE 3 — Frontend

Frontend talks to backend API.

---

## Step 8: Set API URL

```text
API_BASE_URL=http://<SERVER_PUBLIC_IP>:8080
```

Examples:

* Local → `http://localhost:8080`
* Cloud → `http://your-ip:8080`

---

## Step 9: Frontend Dockerfile

```dockerfile
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist/frontend /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## Step 10: Build & Push Frontend

```bash
docker build -t shubhamkalsait1/easycrud-frontend:v1 .
docker push shubhamkalsait1/easycrud-frontend:v1
```

---

# 🚀 PHASE 4 — Run the Application

Order matters:

### 1️⃣ Database → already running

### 2️⃣ Backend

```bash
docker run -d \
 --name backend-container \
 -p 8080:8080 \
 shubhamkalsait1/easycrud-backend:v1
```

Check:

```bash
docker logs backend-container
```

You should see:

```
Started EasyCrudApplication
```

---

### 3️⃣ Frontend

```bash
docker run -d \
 --name frontend-container \
 -p 80:80 \
 shubhamkalsait1/easycrud-frontend:v1
```

---

# 🌍 Access Application

Open browser:

```
http://localhost
```

or

```
http://<SERVER_PUBLIC_IP>
```

✔ UI loads
✔ CRUD operations work
✔ Backend ↔ DB connected

---

# 🧠 Architecture (Simple View)

```
Browser
   ↓
Frontend (Nginx Container)
   ↓ API Calls
Backend (Spring Boot Container)
   ↓ JDBC
MariaDB (Database Container)
```

---

# ⚠ Important Notes

* DB must start **before** backend
* Use correct DB IP
* Only one of `CMD` or `ENTRYPOINT` in Dockerfile
* If DB IP changes → update backend config
* while creating EC2 S.G will be All TCP - IPV4
---
