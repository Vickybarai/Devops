# Docker 3-Tier Architecture Project (Without RDS)

**Frontend → Backend (Tomcat) → Database (MySQL)**
Artifacts are stored in **AWS S3** (WAR + MySQL Connector JAR).


## 📌 Project Objective

Deploy a **Student Management** 3-tier web application on an EC2 instance using Docker:

* **Frontend**: HTML + CSS + JavaScript
* **Backend**: Apache Tomcat + Java WAR
* **Database**: MySQL (Docker container)
* **Artifacts**: Stored in AWS S3 (replaces manual copy / wget)

---

## 🧭 Architecture Overview

```
Browser
   ↓
Frontend Container (Port 80)
   ↓
Backend Container – Tomcat (Port 8080)
   ↓
Database Container – MySQL (Port 3306)
            ↑
        S3 Bucket (student.war, mysql-connector.jar)
```

---

## 🧱 Phase 0 – EC2 Setup (One Time Only)

### 1️⃣ Launch EC2

* OS: **Ubuntu 22.04**
* Instance Type: **t2.micro (Free Tier)**

### 2️⃣ Security Group Rules

| Port | Purpose                    |
| ---- | -------------------------- |
| 22   | SSH access                 |
| 80   | Frontend UI                |
| 8080 | Backend (Tomcat)           |
| 3306 | Database (MySQL container) |

### 3️⃣ Install Docker

```bash
sudo -i
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

### 4️⃣ Clone Project Repository

```bash
git clone https://github.com/Anilbamnote/cdec-46.git
cd cdec-46/Docker/student-docker
```

---

## 🎒 Phase 1 – S3 Setup (Artifacts Layer)

**Purpose:** Store `.war` and `.jar` files externally so Docker images can download them during build.

### 🔗 Artifact Source (Provided)

Artifacts are available here:

```
https://1drv.ms/f/c/d30a1566de7dcd23/IgAhnxz1oI06Tb6om2JIhs7BAQTMx5oHJlgG6XAXGglOG_c
```

Download from the above link and upload to S3.

### Steps

1️⃣ Create S3 Bucket

* Name: `student-assets-<yourname>`
* Disable **Block Public Access**

2️⃣ Upload Files

* `student.war`
* `mysql-connector.jar`

3️⃣ Make Files Public

* Select objects → **Actions → Make public using ACL**

4️⃣ Copy Object URLs

* These URLs will be used inside the Backend Dockerfile

✔ This replaces old manual file copy and wget steps.

---

## 🗄 Phase 2 – Database Layer (MySQL Container)

### 1️⃣ Move to DB Directory

```bash
cd DB/
```

### 2️⃣ Build MySQL Image

```bash
docker build -t db-image:v1 .
```

### 3️⃣ Run MySQL Container

```bash
docker run -d -p 3306:3306 --name db-cont db-image:v1
```

### 4️⃣ Get Database Container IP (Critical)

```bash
docker inspect db-cont | grep IPAddress
```

Example output:

```
172.17.0.2
```

✔ This IP will be used by the backend instead of an RDS endpoint.

---

## 🖥 Phase 3 – Backend Layer (Tomcat + WAR)

### 1️⃣ Move to Backend Directory

```bash
cd ../BE/
```

---

### A️⃣ Update Dockerfile (S3 Artifact URLs)

```bash
vim Dockerfile
```

Replace the `ADD` lines with:

```dockerfile
ADD https://student-assets-<yourname>.s3.amazonaws.com/student.war /opt/apache-tomcat/webapps/
ADD https://student-assets-<yourname>.s3.amazonaws.com/mysql-connector.jar /opt/apache-tomcat/lib/
```

Save and exit:

```
:wq
```

---

### B️⃣ Update Database Connection (context.xml)

```bash
vim context.xml
```

Update JDBC configuration using DB container IP:

```
url="jdbc:mysql://172.17.0.2:3306/student"
username="root"
password="root"
```

Save and exit:

```
:wq
```

---

### C️⃣ Build & Run Backend Container

```bash
docker build -t bk-image:v1 .
docker run -d -p 8080:8080 --name bk-cont bk-image:v1
```

Backend test:

```
http://<EC2_PUBLIC_IP>:8080/student
```

---

## 🌐 Phase 4 – Frontend Layer (UI Container)

### 1️⃣ Move to Frontend Directory

```bash
cd ../FE/
```

### 2️⃣ Update Backend API URL

```bash
vim index.html
```

Update API endpoint:

```
http://<EC2_PUBLIC_IP>:8080/student/
```

Save and exit:

```
:wq
```

### 3️⃣ Build & Run Frontend Container

```bash
docker build -t fe-image:v1 .
docker run -d -p 80:80 --name fe-cont fe-image:v1
```

---

## 🔍 Phase 5 – Verification

Open in browser:

```
http://<EC2_PUBLIC_IP>
```

### Expected Result

* Frontend UI loads
* Backend responds correctly
* Database operations succeed

### Quick Debug Commands

```bash
docker logs db-cont
docker logs bk-cont
docker logs fe-cont
```

---

## 🧠 Old Manual vs New Docker-Based Flow

| Old Method             | Docker-Based Method | Benefit                   |
| ---------------------- | ------------------- | ------------------------- |
| Install MySQL manually | MySQL container     | Isolation                 |
| Copy WAR to server     | S3-based ADD        | Repeatable builds         |
| Manual Tomcat setup    | Docker image        | Faster deployment         |
| Localhost DB           | Container IP        | Real microservice pattern |

