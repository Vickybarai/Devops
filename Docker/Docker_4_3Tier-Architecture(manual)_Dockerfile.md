

# 🚀 Docker 3-Tier Architecture Project (Beginner Guide)

This project demonstrates a **3-Tier Architecture** using:
- **Frontend**: Angular (Dockerized)
- **Backend**: Spring Boot (Dockerized)
- **Database**: MariaDB (AWS RDS – Free Tier)

> ⚠️ Note:  
> This guide follows a **manual learning approach**  
> – we edit config files ourselves  
> – we build Docker images manually  
> – no docker-compose, no automation (yet)

---

## 🧱 Architecture Overview

Browser | |  HTTP (80) v Angular Frontend (Docker) | |  REST API (8080) v Spring Boot Backend (Docker) | |  MySQL (3306) v AWS RDS (MariaDB)

---

# 🔹 PART 1: AWS RDS (MariaDB – Free Tier)

### 1️⃣ Create RDS Database
- AWS Console → RDS → Create database
- Engine: **MariaDB**
- Template: **Free tier**
- DB username: `admin`
- DB password: (your choice)
- Instance: `db.t3.micro`
- Storage: `20 GB`
- Public access: **Yes**
- Security Group: Allow **3306** from EC2 SG
- Create database

📌 Copy **RDS Endpoint** after status = Available

---

### 2️⃣ Connect to RDS from EC2
```bash
mysql -h <RDS-ENDPOINT> -u admin -p
```

---

3️⃣ Create Application Database
```
bash
CREATE DATABASE springdatabase;
EXIT;
```

---

4️⃣ Import Tables
```bash
mysql -h <RDS-ENDPOINT> -u admin -p springdatabase < springbackend.sql
```
---

5️⃣ Verify Database
```bash
mysql -h <RDS-ENDPOINT> -u admin -p
SHOW DATABASES;
USE springdatabase;
SHOW TABLES;
DESC tbl_workers;
EXIT;
```
✔ RDS setup completed


---

🔹 PART 2: EC2 SERVER SETUP

1️⃣ Update Server
```bash
sudo apt update -y
sudo apt upgrade -y
```
---

2️⃣ Install Docker
```bash
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu
```
🔁 Logout & login again


---

3️⃣ Install Required Tools
```bash
sudo apt install git mariadb-client ca-certificates curl -y

```
---

4️⃣ Clone Project Repository
```bash
git clone https://github.com/cloud-blitz/angular-java.git
cd angular-java
```

---

🔹 PART 3: BACKEND (Spring Boot)

1️⃣ Configure Backend Database
```bash
cd spring-backend/src/main/resources/
vim application.properties
```
Update:
```bash
spring.datasource.url=jdbc:mysql://<RDS-ENDPOINT>:3306/springdatabase
spring.datasource.username=admin
spring.datasource.password=<RDS-PASSWORD>
```
Save and exit (ESC :wq)


---

2️⃣ Build Backend Docker Image
```bash
cd ../../
docker build -t backend-image:v1 .
```

---

3️⃣ Run Backend Container
```bash
docker run -d -p 8080:8080 --name backend backend-image:v1
```

---

4️⃣ Test Backend

Open browser:

http://<EC2_PUBLIC_IP>:8080/

✔ Seeing Whitelabel Error Page = Backend + DB working


---

🔹 PART 4: FRONTEND (Angular)

1️⃣ Configure Frontend API URL
```bash
cd angular-frontend/src/app/services/
vim worker.service.ts
```
Update:

private baseUrl = "http://<EC2_PUBLIC_IP>:8080/api/workers";

Save and exit.


---

2️⃣ Build Frontend Docker Image
```bash
cd ../../../
docker build -t frontend-image:v1 .
```

---

3️⃣ Run Frontend Container
```bash
docker run -d -p 80:80 --name frontend frontend-image:v1
```

---

4️⃣ Access Application

Open browser:

http://<EC2_PUBLIC_IP>

✔ Angular UI loads
✔ UI → Backend → RDS works


---

🔍 TROUBLESHOOTING COMMANDS

Check running containers

docker ps

Backend logs

docker logs backend

Frontend logs

docker logs frontend


---
