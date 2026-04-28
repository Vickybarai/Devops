

# 🎓 Lecture Notes: Azure Load Balancer

## 1. Introduction: What is a Load Balancer?

### The Concept
*   **Definition:** A Load Balancer is a service that distributes incoming network traffic across multiple healthy backend resources (Virtual Machines).
*   **Purpose:**
    *   To ensure no single server is overwhelmed with traffic.
    *   To provide high availability (if one server fails, others take over).
    *   **AWS Equivalent:** Elastic Load Balancer (ELB).
*   **Key Terminology:**
    *   **Traffic Distributor:** Like a receptionist at a hotel who guides guests to different rooms.
    *   **Backend Pool:** The group of servers actually doing the work.

### Azure vs. AWS Load Balancer
*   **AWS:** Uses **Elastic Load Balancer (ELB)**. You have Target Groups.
*   **Azure:** Uses **Azure Load Balancer**. You have **Backend Pools**.
*   **Core Logic:** Identical in both—Distribute traffic $\rightarrow$ Check Health $\rightarrow$ Forward Request.

---

## 2. Key Components & Prerequisites

To implement a Load Balancer in Azure, you must understand three main components:

### A. Availability Set (Availability Set)
This is a logical grouping capability for VMs that you **must create before creating VMs** if you plan to use a Load Balancer.
*   **Why use it?**
    *   To ensure that the VMs are spread across **Fault Domains** (Hardware isolation).
    *   To ensure they are spread across **Update Domains** (Software updates isolation).
*   **Benefit:** If a physical rack or network switch fails in the data center, only VMs in that specific domain go down. VMs in other domains remain up, ensuring 99.95%+ availability.
*   **Analogy:** Don't put all your eggs in one basket. Spread them across different physical racks.

### B. Frontend IP Configuration
*   **Public IP:** This is the IP address exposed to the internet.
*   **Limitation:** In many scenarios, you might be allocated only **one Public IP** for the Load Balancer.
*   **Function:** This is the "entry point" for all traffic. Users hit this IP, and the LB decides which internal server (VM) handles it.

### C. Backend Pool
*   This is the collection of your Virtual Machines.
*   You attach the VMs created inside the **Availability Set** to this pool.
*   The Load Balancer only sends traffic to VMs present in the Backend Pool.

### D. Health Probes
*   **Definition:** A check mechanism to see if a server is "Alive."
*   **How it works:**
    *   The LB sends a small request (e.g., Ping or HTTP check) to a specific port on the VM.
    *   **Success:** VM is marked "Healthy" and receives traffic.
    *   **Failure:** VM is marked "Degraded/Unhealthy," and the LB stops sending traffic to it automatically.

---

## 3. Step-by-Step Documentation: Implementation

**Goal:** Create a Load Balancer to distribute traffic between two web servers (VMs).

### Step 1: Create Resource Group
*   Go to Azure Portal $\rightarrow$ **Resource Groups**.
*   Click **Create**.
*   Name: e.g., `LoadBalancerRG`.

### Step 2: Create Availability Set
*   *Note: Do this BEFORE creating VMs.*
*   Go to **Availability Sets**.
*   Click **Create**.
*   **Basics:**
    *   Name: `WebAvailabilitySet`.
    *   Region: Select your region (e.g., Central India).
    *   **Fault Domains:** 2 or 3 (Standard).
    *   **Update Domains:** 5 (Standard).
*   Click **Create**.

### Step 3: Create Virtual Machines (VMs)
*   Create **two VMs** (e.g., `VM1`, `VM2`) for a Web Application.
*   **Important Setting:** In the "High Availability" tab during VM creation, select the **Availability Set** you created in Step 2 (`WebAvailabilitySet`).
*   **Network Security Group (NSG):** Allow port **80 (HTTP)** and **22 (SSH)** so traffic can reach the VMs.
*   **Deployment:** Click Create.

### Step 4: Create Load Balancer
*   Go to **Load Balancers** $\rightarrow$ **Create**.
*   **Basics Tab:**
    *   **Name:** `MyPublicLB`.
    *   **Type:** **Public** (since we want internet traffic).
    *   **SKU:** **Basic** (Free/Limited features) or **Standard** (Zone redundant/Recommended). *For this demo, we might choose Basic, but Standard is better for production.*
    *   **Region:** Same as your VMs.
*   **Frontend IP Configuration:**
    *   **IP Address Type:** IPv4.
    *   **Public IP Address:** Create new (e.g., `PublicIP-LB`).
*   **Backend Pools Tab:**
    *   Click **Add a backend pool**.
    *   **Name:** `BackendPoolWeb`.
    *   **Associated with:** Select the Network and the Availability Set (`WebAvailabilitySet`).
    *   **Target Configuration:** NIC (Network Interface Card) based.
*   **Health Probes Tab:**
    *   Click **Add a health probe**.
    *   **Name:** `HTTPHealthCheck`.
    *   **Protocol:** HTTP.
    *   **Port:** 80.
    *   **Path:** `/` (for websites).
    *   *Logic:* If VM doesn't respond on Port 80, mark it unhealthy.
*   **Load Balancing Rules Tab:**
    *   Click **Add a load balancing rule**.
    *   **Name:** `HTTPRule`.
    *   **Frontend IP:** Select `LoadBalancerFrontEnd`.
    *   **Backend Pool:** Select `BackendPoolWeb`.
    *   **Health Probe:** Select `HTTPHealthCheck`.
    *   **Protocol:** TCP.
    *   **Port:** 80.

### Step 5: Verify Connectivity
*   Once created, copy the **Public IP** of the Load Balancer.
*   Paste it in a browser.
*   **Result:** You should see the default Apache/NGINX page. If you refresh the page, the Load Balancer might send the request to `VM1` first, and then `VM2` (Round Robin).

---

## 4. Advanced Topics

### A. Session Affinity (Source IP)
*   **Scenario:** You have a multi-step login process. The first request goes to `VM1`. If the second request goes to `VM2`, the session breaks (user is logged out).
*   **Solution:** Enable **Session Affinity** (or Sticky Sessions).
*   **Configuration:** Set it to "Source IP". This ensures that if `User A` connects, all subsequent requests from `User A` go to the *same* server (`VM1`) for the duration of the session.

### B. Application Gateway vs. Load Balancer
The transcript mentions confusion between "Network Load Balancer" and "Application Gateway".
*   **Network Load Balancer (Layer 4):**
    *   Works on TCP/UDP level.
    *   Does not look at the content (URL) of the packet, just the IP/Port.
    *   Fast, low latency.
*   **Application Gateway (Layer 7):**
    *   Works on HTTP/HTTPS level.
    *   Can route based on **URL Path** (e.g., `/video` goes to one server, `/images` goes to another).
    *   Supports SSL Termination (offloading).
    *   **Web Traffic Focused:** Like "Classic Load Balancer" or "ALB" in AWS.

---

## 5. 🎯 Interview Preparation

### Q1: What is the difference between an Availability Set and an Availability Zone?
*   **Answer:**
    *   **Availability Zone:** Physically separate data centers within a region (protects against data center fire/flood).
    *   **Availability Set:** Logical grouping *within* a data center that spreads VMs across **Fault Domains** (racks) and **Update Domains**. It protects against hardware rack failure or OS update failures.

### Q2: What is a Health Probe and why is it important?
*   **Answer:** A Health Probe is a mechanism the Load Balancer uses to check if a backend VM is reachable and responding (e.g., via Port 80). It is critical because the LB must know which servers are healthy to avoid sending traffic to a crashed server, which would cause user errors.

### Q3: What is Session Affinity?
*   **Answer:** Session Affinity (or Sticky Sessions) is a setting that ensures a client's requests are always sent to the same backend VM for a specific duration. This is required for applications that store session state locally on the server (stateful applications) so users don't get logged out repeatedly.

### Q4: Can I attach a standalone VM to a Load Balancer without an Availability Set?
*   **Answer:** Yes, technically you can add individual NICs to the Backend Pool. However, for a High Availability (HA) setup guaranteed by the SLA, it is highly recommended to place VMs inside an **Availability Set** so Azure can distribute them across Fault Domains effectively.

### Q5: How many Public IPs are usually assigned to a standard Load Balancer?
*   **Answer:** Usually **one** Standard SKU Public IP acts as the frontend for all rules, though you can configure multiple frontend IPs if needed.

### Q6: What is the difference between Basic and Standard SKU Load Balancer?
*   **Answer:**
    *   **Basic:** Free, limited features, no Zone redundancy. (Good for dev/test).
    *   **Standard:** Paid, Zone-redundant, supports Secure by Default (HTTPS), and better reliability. (Recommended for Production).