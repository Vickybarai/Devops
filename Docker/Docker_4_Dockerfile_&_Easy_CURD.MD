
# 🐳 Dockerized EasyCRUD Application

### MariaDB + Spring Boot Backend + Frontend (Beginner Deployment Guide)

This project runs a **full-stack CRUD application** using Docker:

| Layer    | Technology       | Purpose              |
| -------- | ---------------- | -------------------- |
| Database | MariaDB          | Stores student data  |
| Backend  | Java Spring Boot | Business logic & API |
| Frontend | HTML/JS App      | User interface       |

---

## 📦 Project Structure

Structure

```
EasyCRUD/
├── backend/   # Spring Boot API
├── frontend/  # React UI
└── README.md
```

---

✅ Prerequisites

- Linux server (Ubuntu / EC2)  
- Docker  
- Git  
- Java 17  
- Maven  
- Node.js + npm  

---

🐳 METHOD 1 — Docker Deployment

Step 1 — Install Docker

```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version
```

Step 2 — Start Database (MariaDB)

```bash
docker volume create student-db-vol

docker run -d \
  --name mariadb-container \
  -e MARIADB_ROOT_PASSWORD=redhat \
  -e MARIADB_DATABASE=studentdb \
  -v student-db-vol:/var/lib/mysql \
  mariadb:latest
```

Step 3 — Get Database IP

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mariadb-container
```

Save this IP for the backend config.

Step 4 — Backend Setup

```bash
git clone https://github.com/shubhamkalsait/EasyCRUD.git
cd EasyCRUD/backend
```

Edit `backend/src/main/resources/application.properties`:

```
server.port=8080
spring.datasource.url=jdbc:mariadb://<DB_IP>:3306/studentdb
spring.datasource.username=root
spring.datasource.password=redhat
spring.jpa.hibernate.ddl-auto=update
```

Create `backend/Dockerfile`:

```
FROM maven:3.8.3-openjdk-17
WORKDIR /opt/app
COPY . .
RUN mvn clean package -DskipTests
EXPOSE 8080
ENTRYPOINT ["java","-jar","target/student-registration-backend-0.0.1-SNAPSHOT.jar"]
```

Build & push:

```bash
docker build -t yourdockerhub/curd_app:backend-v1 .
docker push yourdockerhub/curd_app:backend-v1
```

Run:

```bash
docker run -d \
  --name backend-container \
  -p 8080:8080 \
  yourdockerhub/curd_app:backend-v1
```

Step 5 — Frontend Setup

```bash
cd ../frontend
```

Edit `frontend/.env`:

```
VITE_API_URL="http://<BACKEND_PUBLIC_IP>:8080/api"
```

Create `frontend/Dockerfile`:

```
FROM node:22-alpine
WORKDIR /opt/app
COPY . .
RUN npm install && npm run build
RUN apk add --no-cache apache2
RUN cp -rf dist/* /var/www/localhost/htdocs/
EXPOSE 80
CMD ["httpd","-D","FOREGROUND"]
```

Build & push:

```bash
docker build -t yourdockerhub/curd_app:frontend-v1 .
docker push yourdockerhub/curd_app:frontend-v1
```

Run:

```bash
docker run -d \
  --name frontend-container \
  -p 80:80 \
  yourdockerhub/curd_app:frontend-v1
```

Access:  

```
http://YOUR_SERVER_IP
```

---

🖥 METHOD 2 — Manual Deployment

Backend

```bash
apt install openjdk-17-jdk maven -y
cd backend
# edit src/main/resources/application.properties
mvn clean package
java -jar target/spring-backend-v1.jar
```

Frontend

```bash
apt install nodejs npm apache2 -y
cd frontend

# edit .env
Create file `.env`:

```
VITE_API_URL="http://your-server-ip:8080/api"
```

npm install
npm run build
cp -rf dist/* /var/www/html/
systemctl restart apache2
```

---

❌ Common Errors

Symptom	Fix	
Backend can't connect DB	Check DB IP in `application.properties`	

React API error	Check `VITE_API_URL` in `.env`	


Port already used	Change host port or stop conflicting service	
Container exits	`docker logs <container>`	

---

🔧 Files You Must Edit

File	Purpose	
`backend/src/main/resources/application.properties`	DB IP, user, password	
`frontend/.env`	Backend public IP	
Docker image tags	Your Docker Hub username	

---

🏁 Architecture

```
Browser → Frontend (80) → Backend (8080) → MariaDB
```


[EasyCRUD Repository](https://github.com/shubhamkalsait/EasyCRUD.git)