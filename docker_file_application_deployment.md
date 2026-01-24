# Dockerized EasyCRUD Application – Step-by-Step Guide

This guide explains how to run a **MariaDB + Java Spring Boot backend + frontend** application using Docker, in a clear execution order.

---

## Phase 1: Database (Foundation)

### Goal

Run MariaDB with persistent storage and make it accessible to the backend.

---

### Step 1: Create Docker Volume

**Purpose**
Persist database data outside the container lifecycle.

**MariaDB data directory**

```
/var/lib/mysql
```

**Command**

```bash
docker volume create student-db-vol
```

**Result**

* Volume created for database persistence.

---

### Step 2: Run MariaDB Container

**Purpose**
Start MariaDB using the created volume.

**Command**

```bash
docker run -d \
 --name mariadb-container \
 -e MARIADB_ROOT_PASSWORD=redhat \
 -e MARIADB_DATABASE=studentdb \
 -v student-db-vol:/var/lib/mysql \
 mariadb:latest
```

**Result**

* MariaDB container starts
* Database `studentdb` is created
* Data stored in `student-db-vol`

---

### Step 3: Obtain Database Container IP

**Purpose**
Identify database IP for backend connectivity.

**Command**

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mariadb-container
```

**Example Output**

```
172.17.0.2
```

**Result**

* Database accessible via this IP inside Docker host

---

## Phase 2: Backend (Java – Spring Boot)

### Goal

Build backend image and connect it to MariaDB.

---

### Step 4: Clone Repository and Create Branch

**Command**

```bash
git clone https://github.com/shubhamkalsait/EasyCRUD.git
cd EasyCRUD
git checkout -b deploy-fix
cd backend
```

**Result**

* Backend source code ready for deployment

---

### Step 5: Configure Database Connection

**File**

```
src/main/resources/application.properties
```

**Configuration**

```properties
server.port=8080
spring.datasource.url=jdbc:mariadb://172.17.0.2:3306/studentdb
spring.datasource.username=root
spring.datasource.password=redhat
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

**Result**

* Backend configured to connect to MariaDB container

---

### Step 6: Backend Dockerfile

**Dockerfile**

```dockerfile
# Stage 1: Build
FROM maven:3.8.3-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Result**

* Optimized multi-stage backend image definition

---

### Step 7: Build and Push Backend Image

**Command**

```bash
docker build -t shubhamkalsait1/easycrud-backend:v1 .
docker push shubhamkalsait1/easycrud-backend:v1
```

**Result**

* Backend image available in Docker registry

---

## Phase 3: Frontend

### Goal

Build frontend and expose it through Nginx.

---

### Step 8: Update Frontend API URL

**Configuration**

```text
API_BASE_URL=http://<SERVER_PUBLIC_IP>:8080
```

**Examples**

* Local: `http://localhost:8080`
* Cloud VM: `http://<public-ip>:8080`

**Result**

* Frontend sends requests to backend correctly

---

### Step 9: Frontend Dockerfile

**Dockerfile**

```dockerfile
# Stage 1: Build
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=build /app/dist/frontend /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Note**

* Confirm build output directory:

```bash
ls dist/
```

---

### Step 10: Build and Push Frontend Image

**Command**

```bash
docker build -t shubhamkalsait1/easycrud-frontend:v1 .
docker push shubhamkalsait1/easycrud-frontend:v1
```

**Result**

* Frontend image available in Docker registry

---

## Phase 4: Runtime Execution

### Goal

Run all containers in correct order.

---

### Step 11: Run Backend Container

**Command**

```bash
docker run -d \
 --name backend-container \
 -p 8080:8080 \
 shubhamkalsait1/easycrud-backend:v1
```

**Verify**

```bash
docker logs backend-container
```

**Expected**

```
Started EasyCrudApplication
```

---

### Step 12: Run Frontend Container

**Command**

```bash
docker run -d \
 --name frontend-container \
 -p 80:80 \
 shubhamkalsait1/easycrud-frontend:v1
```

---

### Step 13: Browser Validation

**URL**

```
http://localhost
```

or

```
http://<SERVER_PUBLIC_IP>
```

**Expected Result**

* Frontend UI loads
* API requests reach backend
* Backend communicates with MariaDB

---
---
---
## Additional Dockerfile (Single-Stage Sort process Variant)

**Dockerfile**

```dockerfile
FROM ubuntu:22.04
LABEL name="shubhamkalsait"

USER root
VOLUME ["/var/www/html"]

RUN apt update && apt install -y openjdk-17-jdk git maven

WORKDIR /opt
RUN git clone https://github.com/shubhamkalsait/EasyCRUD.git

WORKDIR /opt/EasyCRUD/backend
COPY application.properties src/main/resources/application.properties

RUN mvn clean package -DskipTests

EXPOSE 8080
CMD ["java", "-jar", "target/student-registration-backend-0.0.1-SNAPSHOT.jar"]
```

**Important**

* Use **only one** of `CMD` or `ENTRYPOINT`, not both.
* Application configuration must match database runtime values.
---
