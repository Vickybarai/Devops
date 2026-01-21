

🐳 Docker Networking & Docker Volumes

(Interview + Hands-On Preparation Notes)


---

PART 1: Docker Networking


---

1️⃣ What is Docker Networking? (Definition)

Docker Networking is the mechanism that allows containers to:

Communicate with each other

Communicate with the host

Communicate with external networks (internet)


Docker achieves this using network drivers.


---

2️⃣ Network Drivers (Modes) – Theory + Interview View

1. Bridge (Default)

Definition:
Default network driver for containers running on a single Docker host.

Key Points:

Containers get private IPs (usually 172.17.x.x)

Containers can talk via IP

Name-based communication works only in custom bridge

Requires -p for external access


Interview Line:

> Bridge is the default isolated network on a single host, best for standalone applications.




---

2. Host

Definition:
Removes network isolation between container and host.

Key Points:

Container uses host IP directly

No private IP for container

-p or -P flags are ignored

Faster networking, less isolation


Interview Line:

> Host network shares the host namespace, eliminating port mapping overhead.




---

3. None (Null)

Definition:
Fully isolated network.

Key Points:

No IP

No internet

No communication

Used for batch jobs / security workloads



---

4. Overlay

Definition:
Used to connect containers across multiple Docker hosts.

Key Points:

Requires Docker Swarm

Used in clusters

Enables cross-host container communication



---

5. Macvlan / IPvlan

Definition:
Advanced drivers that assign real MAC/IP to containers.

Key Points:

Container appears as physical device

Used in legacy systems & strict network control



---

3️⃣ Network Management – Commands

List Networks

docker network ls

Inspect Network (Subnet, Gateway, Containers)

docker network inspect bridge


---

4️⃣ Custom Bridge Network (Best Practice)

Why Custom Bridge?

Container-to-container communication via name

Better isolation

Predictable IP range



---

Create Network with Subnet

docker network create \
  --driver bridge \
  --subnet 172.18.0.0/16 \
  my_network

Verify

docker network inspect my_network


---

5️⃣ Running Container Inside a Network

Syntax

docker run --network <network_name> IMAGE

Command

docker run -d \
  --name web_server \
  --network my_network \
  httpd


---

6️⃣ Attach / Detach Network (Hot Plugging)

Connect Running Container

docker network connect my_network web_server

Disconnect

docker network disconnect bridge web_server

Interview Insight:

> Docker allows live network attachment without restarting containers.




---

🗂️ PART 2: Docker Volumes


---

1️⃣ What is a Docker Volume? (Definition)

Docker Volume is a mechanism to store data outside the container lifecycle, ensuring data persistence.


---

2️⃣ Why Volumes are Needed? (Concept)

Containers are ephemeral

docker rm ⇒ data gone
Volumes survive container deletion



---

3️⃣ Volume Storage Location (Important Interview Point)

📍 On Host:

/var/lib/docker/volumes/<volume-name>/_data

Inspect Volume

docker volume inspect my_vol


---

4️⃣ Volume Lifecycle – Practical Workflow

Step A: Create Volume

docker volume create my_vol
docker volume ls


---

Step B: Mount Volume to Container

⚠️ Corrected from notes:
Mounting to /mnt does nothing for Apache.

📌 Apache document root:

/usr/local/apache2/htdocs

Correct Command

docker run -d \
  -p 8080:80 \
  --name web1 \
  -v my_vol:/usr/local/apache2/htdocs \
  httpd


---

Step C: Modify Data (Persistence Test)

docker exec -it web1 bash

Inside container:

echo "<h1>Hello from Docker Volume!</h1>" > /usr/local/apache2/htdocs/index.html
exit


---

Step D: Delete Container

docker rm -f web1


---

Step E: Attach Same Volume to New Container

docker run -d \
  -p 8081:80 \
  --name web2 \
  -v my_vol:/usr/local/apache2/htdocs \
  httpd

✅ Result:
Same data appears → Persistence confirmed


---

5️⃣ Volume Mount Syntax (Interview)

Old Style

-v volume_name:/container/path

New Style (Recommended)

--mount source=volume_name,target=/container/path


---

6️⃣ Volume Use Cases

Database storage (MySQL, PostgreSQL)

Logs

Uploads

Shared config files

Zero-data-loss container recreation



---
