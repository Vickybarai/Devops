

# 🐳 Docker Networking & Docker Volumes



---
---

# 🌐 PART 1: Docker Networking (Beginner Friendly)

---

## 🧠 First Understand the Problem

By default, containers are **isolated**.

If you run two containers:

```bash
docker run -d --name c1 nginx
docker run -d --name c2 nginx
```

They **cannot talk** to each other automatically like normal servers.

👉 Docker Networking solves this communication problem.

---

## 1️⃣ What is Docker Networking?

Docker Networking is the system that allows containers to:

* Talk to **other containers**
* Talk to the **Docker host**
* Access the **Internet**
* Be accessed by **users**

Think of it like:

> **Networking in Docker = LAN setup for containers**

---

## 2️⃣ How Docker Networking Works Internally (Simple)

When Docker starts:

* It creates a virtual network called **bridge**
* Each container gets:

  * A **private IP**
  * A **virtual network interface**
* Docker uses a built-in DNS to resolve container names (in custom networks)

So containers behave like **mini virtual machines** connected to a virtual switch.

---

# 🚦 Docker Network Drivers (Modes)

Docker uses **drivers** to decide how networking behaves.

---

## 🔹 1. Bridge Network (DEFAULT)

📌 This is what Docker uses automatically.

### 🧩 What happens?

* Docker creates a virtual bridge called `docker0`
* Containers connect to this bridge
* Each container gets an IP like:

  ```
  172.17.0.x
  ```

### ✅ Good For:

* Single-host applications
* Testing
* Dev environments

### ❗ Important Beginner Points

| Feature                  | Bridge                           |
| ------------------------ | -------------------------------- |
| Container to container   | Yes (via IP)                     |
| Container to internet    | Yes                              |
| Internet to container    | Only with `-p`                   |
| Name-based communication | ❌ Default bridge doesn't support |

### 🌍 Expose Container to Outside World

```bash
docker run -d -p 8080:80 nginx
```

➡ Maps **Host Port 8080 → Container Port 80**

---

### 🧠 Interview Line

> Bridge network provides isolated networking on a single Docker host.

---

## 🔹 2. Custom Bridge Network (BEST PRACTICE)

This is what you should use in real projects.

### 🚀 Why Custom Bridge is Better?

| Feature                  | Default Bridge | Custom Bridge |
| ------------------------ | -------------- | ------------- |
| Name-based communication | ❌              | ✅             |
| Better isolation         | ❌              | ✅             |
| Manual IP control        | ❌              | ✅             |

---

### 🔧 Create Custom Network

```bash
docker network create my_network
```

### ▶ Run Containers in Same Network

```bash
docker run -d --name app --network my_network nginx
docker run -d --name db --network my_network nginx
```

Now inside **app container**, you can ping:

```bash
ping db
```

✅ Works because Docker DNS resolves container names.

---

## 🔹 3. Host Network

Here, the container shares the host’s network.

```bash
docker run --network host nginx
```

### What changes?

* Container uses **host IP**
* No port mapping needed
* Faster
* Less secure

🧠 Think of it like:

> Container is directly running on your system network.

---

## 🔹 4. None Network

```bash
docker run --network none nginx
```

Container gets:

❌ No IP
❌ No internet
❌ No communication

Used for:

* Secure workloads
* Batch processing

---

## 🔹 5. Overlay Network

Used in **Docker Swarm (cluster of machines)**.

Allows containers on **different servers** to communicate.

🧠 Think of it as:

> Bridge network but across multiple hosts.

---

## 🔹 6. Macvlan / IPvlan

Advanced networking.

Container gets its **own IP from your LAN router**.

It looks like a real physical device on your network.

Used in:

* Legacy apps
* Special network policies

---

# 🛠 Docker Network Commands (Must Know)

### 📋 List Networks

```bash
docker network ls
```

### 🔍 Inspect Network Details

```bash
docker network inspect bridge
```

### ➕ Create Network

```bash
docker network create my_network
```

### 🔗 Connect Container to Network

```bash
docker network connect my_network container_name
```

### ❌ Disconnect Container

```bash
docker network disconnect my_network container_name
```

---

# 🎯 Beginner Summary (Very Important)

| Network Type      | Use Case                           |
| ----------------- | ---------------------------------- |
| **Bridge**        | Default, simple apps               |
| **Custom Bridge** | Real-world container communication |
| **Host**          | High performance apps              |
| **None**          | Full isolation                     |
| **Overlay**       | Multi-host clusters                |
| **Macvlan**       | Container gets real LAN IP         |

---

💡 **Golden Rule for Beginners:**

> Always use **custom bridge networks** when multiple containers need to communicate.

---

---

# 💾 PART 2: Docker Volumes

---

## 🧠 First Understand the Core Problem

Containers are **temporary (ephemeral)**.

If you store data inside a container:

```bash
docker rm container_name
```

🚨 Container deleted
🚨 Data inside container deleted

That is dangerous for:

* Databases
* User uploads
* Logs
* Application files

👉 **Docker Volumes solve this data-loss problem.**

---

## 1️⃣ What is a Docker Volume?

**Definition:**
A Docker Volume is a special storage location **outside the container filesystem** that Docker manages, used to persist data even if the container is removed.

🧠 Think of it like:

> **Container = Laptop**
> **Volume = External Hard Drive**

Even if laptop crashes, data in external drive stays safe.

---

## 2️⃣ Where Are Volumes Stored? (Interview Question)

On Linux host:

```
/var/lib/docker/volumes/<volume-name>/_data
```

Docker handles this path — you normally don’t modify it manually.

Check details:

```bash
docker volume inspect my_vol
```

---

## 3️⃣ Why Volumes Are Better Than Container Storage

| Feature                      | Container Storage | Volume        |
| ---------------------------- | ----------------- | ------------- |
| Survives container deletion  | ❌ No              | ✅ Yes         |
| Managed by Docker            | ❌ No              | ✅ Yes         |
| Safe for databases           | ❌ Risky           | ✅ Recommended |
| Shareable between containers | ❌ No              | ✅ Yes         |

---

## 4️⃣ Volume Lifecycle (Hands-On Flow)

---

### 🔹 Step A: Create Volume

```bash
docker volume create my_vol
docker volume ls
```

---

### 🔹 Step B: Mount Volume to Container

📌 Apache document root:

```
/usr/local/apache2/htdocs
```

```bash
docker run -d \
  -p 8080:80 \
  --name web1 \
  -v my_vol:/usr/local/apache2/htdocs \
  httpd
```

👉 Now website files are stored in **volume**, not container.

---

### 🔹 Step C: Add Data (Test Persistence)

```bash
docker exec -it web1 bash
```

Inside container:

```bash
echo "<h1>Hello from Docker Volume!</h1>" > /usr/local/apache2/htdocs/index.html
exit
```

---

### 🔹 Step D: Delete Container

```bash
docker rm -f web1
```

Container gone ❌
Volume still exists ✅

---

### 🔹 Step E: Reuse Same Volume

```bash
docker run -d \
  -p 8081:80 \
  --name web2 \
  -v my_vol:/usr/local/apache2/htdocs \
  httpd
```

Open browser → data still there 🎉

✔ Persistence confirmed.

---

## 5️⃣ Volume Mount Syntax (Interview Important)

### Old Style (Short)

```bash
-v volume_name:/container/path
```

### New Style (Recommended)

```bash
docker run -d \
  --mount source=my_vol,target=/usr/local/apache2/htdocs \
  httpd
```

---

## 6️⃣ Volume Types (Very Important)

| Type           | Description       | Use Case                 |
| -------------- | ----------------- | ------------------------ |
| **Volume**     | Managed by Docker | Production apps          |
| **Bind Mount** | Uses host folder  | Dev/testing              |
| **tmpfs**      | Stored in RAM     | Sensitive temporary data |

---

### 🔹 Bind Mount Example

```bash
docker run -d \
  -v /home/user/data:/app/data \
  nginx
```

Here, host folder is directly used.

---

## 7️⃣ Sharing Volume Between Containers

```bash
docker run -d --name c1 -v shared_vol:/data nginx
docker run -d --name c2 -v shared_vol:/data nginx
```

Both containers read/write same data.

---

## 8️⃣ Removing Volumes

List:

```bash
docker volume ls
```

Remove:

```bash
docker volume rm my_vol
```

Remove unused:

```bash
docker volume prune
```

⚠ This deletes unused volumes permanently.

---

## 9️⃣ Real-World Use Cases

| Application        | Why Volume Needed |
| ------------------ | ----------------- |
| MySQL / PostgreSQL | Database files    |
| Web Apps           | User uploads      |
| Logging            | Persistent logs   |
| Config files       | Shared configs    |

---


## 🏁 Beginner Golden Rule

> If data is important → **always use volumes**
> Never rely on container internal storage.

---
