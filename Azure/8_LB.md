

# 📚 Lecture Notes: Azure Load Balancer

## 1. Introduction: What is Load Balancer?

**Definition:**
A Load Balancer is a service that distributes incoming network traffic across multiple backend resources (servers).
*   **Analogy:** Think of it as a "Traffic Police" or "Distributor." It stands at the front door and ensures that no single server gets crushed by too many visitors.

**Why do we need it? (The Problem):**
*   **Single Point of Failure:** If you host a website on just **one server** and that server crashes, your website goes completely offline.
*   **High Traffic:** If 1000 users visit your site at once, a single server's CPU might hit 100% and the site becomes unresponsive or slow.
*   **Connection Timeouts:** Users see errors like "Connection Timed Out" because the server cannot handle the load.

**How does it solve it? (The Solution):**
*   You use **multiple servers** (e.g., Web Server 1, Web Server 2, Web Server 3).
*   The **Load Balancer** sits in front of them.
*   It routes user requests to the server that is **least busy** or available.
*   If one server crashes, the Load Balancer detects it (via Health Check) and stops sending traffic to it, automatically sending users to the other healthy servers.

---

## 2. AWS vs. Azure Comparison

*   **AWS:** The service is called **ELB (Elastic Load Balancer)**.
*   **Azure:** The service is simply called **Load Balancer**.
*   **Functionality:** Both work exactly the same—distributing traffic to ensure high availability and reliability.

---

## 3. Key Components of Azure Load Balancer

When creating a Load Balancer, you configure these main parts:

### A. Frontend IP Configuration
*   This is the "public face" of your infrastructure.
*   It provides a **Public IP Address**.
*   Users hit this IP to reach your application.

### B. Backend Pool (बैकएंड पूल)
*   This is a group of your actual servers (Virtual Machines).
*   You add your VMs (e.g., `VM-1`, `VM-2`, `VM-3`) to this pool.
*   The Load Balancer only distributes traffic to VMs that are inside this pool.

### C. Health Probes (हेल्थ प्रोब्स)
*   The Load Balancer needs to know if a server is alive or dead.
*   **Health Check:** The LB sends a small signal (request) to the server periodically (e.g., every 30 seconds).
*   **Path:** Usually checks a specific URL (like `/`).
*   **Protocol:** HTTP, HTTPS, or TCP.
*   If the server responds, it is **Healthy**. If not, it is **Unhealthy**, and the LB stops sending traffic to it.

### D. Load Balancing Rules
*   This connects the **Frontend** (Public IP) to the **Backend Pool**.
*   **Protocol:** e.g., TCP on Port 80 (for HTTP traffic).
*   **Port Mapping:** User hits Frontend Port 80 -> LB sends it to Backend Port 80.

---

## 4. Step-by-Step Documentation (Creating a Load Balancer)

**Prerequisite:** A **Resource Group** (e.g., `Resources`). If not created, create one first.

#### Step 1: Search for Service
*   In Azure Portal Search Bar, type: **Load Balancers**.
*   Click **Create**.

#### Step 2: Basics Tab
*   **Name:** `my-load-balancer` (Give a meaningful name).
*   **Region:** Select the same region where your VMs exist (e.g., Central India).
*   **SKU:** **Standard** (Recommended for production; Basic is legacy).
*   **Tier:** Regional.

#### Step 3: Frontend IP Configuration
*   **Type:** IPv4.
*   **IP Address:** Click "Create new".
*   **Public IP Address:** Create a new one (e.g., `public-ip-lb`).
*   *Note:* This IP is what users will type in their browser (or map to DNS).

#### Step 4: Backend Pools
*   Click **Add a backend pool**.
*   **Name:** `backend-pool-1`.
*   **IP Version:** IPv4.
*   *Note:* This is just creating the bucket (group) for now. You don't select VMs here, you usually do it after the LB is created or via VM settings.

#### Step 5: Health Probes
*   Click **Add a health probe**.
*   **Name:** `http-probe`.
*   **Protocol:** Select **HTTP** (since we are hosting a web server).
*   **Port:** `80`.
*   **Path:** `/` (It checks the root directory).
*   **Interval:** How often to check (e.g., 5 seconds).
*   *Logic:* It sends a request to `http://<server-ip>/`. If it gets a 200 OK response, the server is marked Healthy.

#### Step 6: Load Balancing Rules
*   Click **Add a load balancing rule**.
*   **Name:** `http-rule`.
*   **Frontend IP Configuration:** Select the IP address created in Step 3.
*   **Protocol:** **TCP**.
*   **Port:** `80`.
*   **Backend Pool:** Select `backend-pool-1`.
*   **Health Probe:** Select `http-probe` created in Step 5.
*   **Session Persistence:** Depends on app needs (None/Client IP/Source IP).

#### Step 7: Review + Create
*   Click **Review + create**.
*   Wait for deployment to finish.

---

## 5. Important: Connecting VMs & DNS

### Adding VMs to Backend Pool
Creating the LB isn't enough; you must tell the LB **which** servers to balance.
1.  Go to your **Load Balancer** resource once created.
2.  Click **Backend pools** in the left menu.
3.  Select your pool (`backend-pool-1`).
4.  Click **Add** -> Select the **Virtual Machines** you want to include.

### DNS Configuration (Crucial Step)
*   The Load Balancer provides a **Public IP** (e.g., `20.10.5.1`).
*   Users cannot type numbers to open a website easily.
*   **Solution:** You need to buy a domain (e.g., from GoDaddy, Google Domains) and create an **A Record**.
*   **A Record Mapping:**
    *   **Host/Name:** `@` (or `www`).
    *   **Value/Points to:** The **Public IP** of your Azure Load Balancer.
*   Without this, users cannot access your site via `www.myshop.com`.

---

## 6. Troubleshooting / Common Issues (From Lecture)

*   **Finding the Service:** In the Azure Portal, if you don't see "Load Balancer" immediately, check under the **Networking** blade. Sometimes "Application Gateway" appears first (Application Gateway is Layer 7, Load Balancer is Layer 4).
*   **NAT Rules:** Ensure your NSG (Network Security Group) allows **Port 80** or **Port 443** from the internet.
*   **VM Health:** Ensure the VMs are actually running and the web server (Apache/IIS) is started. If the service is down, the Health Probe will fail.

---

## 🎯 Interview Preparation (Q&A)

**Q1: What is the difference between Application Gateway and Load Balancer in Azure?**
*   **Answer:**
    *   **Load Balancer:** Operates at **Layer 4 (Transport layer - TCP/UDP)**. It is fast and cheap, good for non-HTTP traffic or simple high-performance needs.
    *   **Application Gateway:** Operates at **Layer 7 (Application layer)**. It understands HTTP/HTTPS, can do SSL termination (offloading), URL path-based routing, and Web Application Firewall (WAF), but it is more expensive.

**Q2: What is a Health Probe?**
*   **Answer:** A health probe is a mechanism used by the Load Balancer to determine the health of backend instances. It sends periodic requests to a specific port and path. If the instance responds within the threshold, it is marked 'Healthy'; otherwise, it is marked 'Unhealthy' and removed from rotation.

**Q3: What happens if a server fails in the Backend Pool?**
*   **Answer:** The Load Balancer detects the failure via the Health Probe. It immediately stops sending new traffic to that specific server (or VM) and routes the user requests to the remaining healthy servers in the pool.

**Q4: How do you map a custom domain to an Azure Load Balancer?**
*   **Answer:** Azure Load Balancer creates a Public IP address. To use a custom domain (like `example.com`), you must go to your DNS provider and create an **A Record** that points to this Public IP address.

**Q5: Can Load Balancer help if the application code is slow?**
*   **Answer:** No. Load Balancer only distributes **network traffic**. If the application itself is slow (bad code) or the CPU is maxed out, the user will still experience slowness. Load Balancer helps with **availability**, not **application performance** (unless you scale out/add more servers).