# 📘 YAML & Docker Compose –
---

## Part 1: YAML File (Foundation)

### 1. What is a YAML File

**Definition**
YAML (YAML Ain’t Markup Language) is a human-readable data-serialization format used to define configuration.

**Purpose**
Used to describe application configuration, infrastructure, and service relationships in a structured text format.

**Key Characteristics**

* Indentation-based
* Key–value oriented
* No brackets `{}` or semicolons `;`
* Designed for readability

**Common Uses**

* Docker Compose
* Kubernetes manifests
* CI/CD pipelines
* Application configuration files

---

### 2. YAML Syntax Rules (Mandatory)

#### a. Key–Value Format

```yaml
key: value
```

#### b. Indentation

* Spaces only (no tabs)
* Same level → same indentation
* Usually 2 spaces

```yaml
services:
  backend:
    image: myapp
```

#### c. Lists

```yaml
ports:
  - "8080:8080"
  - "3306:3306"
```

#### d. Maps (Nested Objects)

```yaml
environment:
  DB_USER: root
  DB_PASSWORD: redhat
```

#### e. Strings

```yaml
name: "student-app"
```

---

### 3. YAML Data Types

| Type    | Example        |
| ------- | -------------- |
| String  | `"redhat"`     |
| Integer | `3306`         |
| Boolean | `true / false` |
| List    | `- item1`      |
| Map     | `key: value`   |

---

### 4. YAML Common Mistakes

* Using tabs instead of spaces
* Incorrect indentation
* Missing colon after key
* Mixing list and map indentation
* Forgetting quotes around ports

---

## Part 2: Docker Compose (Concept)

### 5. What is Docker Compose

**Definition**
Docker Compose is a tool that allows defining and running multi-container Docker applications using a YAML file.

**Purpose**

* Manage multiple containers as one application
* Remove repetitive Docker CLI commands
* Centralize configuration
* Enable one-command startup

---

### 6. Core Docker Compose Keywords

| Keyword     | Purpose                     |
| ----------- | --------------------------- |
| version     | Compose file format version |
| services    | Define containers           |
| image       | Use prebuilt image          |
| build       | Build image from Dockerfile |
| ports       | Map container ports         |
| environment | Pass environment variables  |
| volumes     | Persistent storage          |
| networks    | Container communication     |
| depends_on  | Startup order               |

---

## Part 3: Docker Compose File – 

## [Project Complete Setup](https://github.com/Vickybarai/project/blob/main/3-Tier_EasyCRUD_(using_yaml).md)

### Step 1: Folder Structure

```
EasyCRUD
├── docker-compose.yml
├── backend/
│   └── Dockerfile
└── frontend/
    └── Dockerfile
```

`docker-compose.yml` must be at the project root.

---

### Step 2: docker-compose.yml (Correct & Working)

```yaml
version: '3.8'

services:
  database:
    image: mariadb:latest
    container_name: mariadb-container
    environment:
      MARIADB_ROOT_PASSWORD: "redhat"
      MARIADB_DATABASE: "studentapp"
    volumes:
      - my-vol123:/var/lib/mysql
    ports:
      - "3306:3306"
    networks:
      - school-net

  backend:
    build: ./backend
    container_name: backend-container
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: "jdbc:mariadb://database:3306/studentapp"
      DB_USER: "root"
      DB_PASSWORD: "redhat"
    depends_on:
      - database
    networks:
      - school-net

  frontend:
    build: ./frontend
    container_name: frontend-container
    ports:
      - "80:80"
    environment:
      PUBLIC_IP: "13.212.151.46"
    depends_on:
      - backend
    networks:
      - school-net

volumes:
  my-vol123:

networks:
  school-net:
```

---

### Step 3: Why This Works (Logic Flow)

* All services join the same network (`school-net`)
* Containers communicate using **service names**
* `database` becomes the hostname for MariaDB
* No container IP lookup required
* Volume ensures database persistence
* Ports expose services to host/browser

---

## Part 4: Execution

### Step 4: Start Application

Run from the directory containing `docker-compose.yml`.

```bash
docker-compose up -d --build
```

**Flags**

* `up` → create and start services
* `-d` → run in background
* `--build` → rebuild images if code changed

---

### Step 5: Verify Containers

```bash
docker-compose ps
```

Expected:

* database → running
* backend → running
* frontend → running

---

### Step 6: Logs (If Required)

```bash
docker-compose logs backend
docker-compose logs database
```

---

### Step 7: Access Application

```text
http://localhost
```

or

```text
http://<SERVER_PUBLIC_IP>
```

---

## Part 5: YAML & Docker Compose – Interview Doubts

### YAML Questions

**Q1. Why YAML uses indentation?**
To define hierarchy and relationships without brackets.

**Q2. Tabs allowed in YAML?**
No. Only spaces.

**Q3. Is YAML a programming language?**
No. It is a configuration format.

---

### Docker Compose Questions

**Q1. Why service name instead of container IP?**
Docker DNS resolves service names automatically.

**Q2. What does depends_on do?**
Controls startup order, not service readiness.

**Q3. Difference between build and image?**

* `build` → build image from Dockerfile
* `image` → pull existing image

**Q4. Where is environment variable applied?**
Inside the container at runtime.

**Q5. Why use custom network?**
Allows containers to communicate by name.

---

## Part 6: Final Execution Summary

* YAML defines infrastructure declaratively
* Docker Compose removes manual container wiring
* One file controls DB, backend, frontend
* One command starts entire application
* Configuration is reproducible and scalable
