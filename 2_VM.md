
# Lecture 2: Azure Resource Groups, VMs, and High Availability

## 📌 Today's Agenda
1.  **Resource Groups (RG):** Creation and purpose (Logical Containers).
2.  **Regions & Availability Zones:** Critical differences between AWS and Azure availability architecture.
3.  **Virtual Machine Options:** Understanding VM, Scale Sets, and Presets.
4.  **Creating a VM:** Step-by-step configuration (Basics, Size, Disks, Authentication).
5.  **Availability Options:** Deep dive into "No Infrastructure Redundancy" vs "Availability Zones".

---

## 1. Resource Groups (The Logical Container)

### What is a Resource Group?
A **Resource Group** is a logical container that holds related Azure resources together. It acts like a folder on your computer where you group related files.

### Why is it Important? (Interview Answer)
*   **Lifecycle Management:** You can delete an entire Resource Group, and it will automatically delete every resource inside it (VMs, Networks, Storage) simultaneously.
*   **Organization:** Helps apply permissions (RBAC) and tags to a group of resources collectively rather than individually.
*   **Billing:** While billing occurs at the Subscription level, Resource Groups help organize costs by project.

### How to Create
1.  Search for **"Resource Groups"** in the Azure Portal.
2.  Click **"Create"**.
3.  **Details:**
    *   **Subscription:** Select your pay-as-you-go subscription.
    *   **Resource Group Name:** Give it a unique name (e.g., `Resources-Name`).
    *   **Region:** Select a region (e.g., Central India).
4.  **Tags:** Optional labels for identification (e.g., `Project=Training`).
5.  **Review + Create:** ARM (Azure Resource Manager) validates the request before creating.

---

## 2. Regions & Availability Zones (Critical Concept)

### The Concept
*   **Region:** A geographical area containing datacenters (e.g., East US, West India).
*   **Availability Zone (AZ):** Physically separated datacenters within a single region. Each zone has independent power, cooling, and networking.

### ⚠️ Key Difference: AWS vs. Azure
*   **AWS:** Almost *all* regions have 3 or more Availability Zones.
*   **Azure:** **Only selected regions** support Availability Zones.

> **Example from Lecture:**
> *   **Central India (Pune):** Supports Availability Zones.
> *   **West India (Mumbai) & South India (Chennai):** (As per specific lecture context) Do not support Availability Zones or have limited options.
>
> **Note:** When creating resources, the Availability Zone dropdown will only appear if the selected region supports it.

---

## 3. Virtual Machine Options

When you navigate to "Virtual Machines" in Azure, you will see four main options for deployment:

| Option | Concept | Use Case |
| :--- | :--- | :--- |
| **1. Virtual Machine** | A single, standalone server (IaaS). | General use, testing, learning, hosting a single website. Similar to **AWS EC2**. |
| **2. Virtual Machine Scale Sets (VMSS)** | A group of identical VMs with **Auto-Scaling**. | Production apps with variable traffic. Automatically increases/decreases VM count based on load. |
| **3. Presets** | Pre-configured, ready-made templates. | Beginners or quick demos. Azure pre-configures the OS and settings for you. |
| **4. Hybrid Benefit / Pre-configured** | Solutions for integrating on-premise servers with Azure. | Migration scenarios, hybrid cloud setups. |

---

## 4. Creating a Virtual Machine (Step-by-Step)

### Step 1: Basics Tab
*   **Project Details:**
    *   **Subscription:** Where the billing happens.
    *   **Resource Group:** Select the group created earlier (e.g., `Resources-Name`).
*   **Instance Details:**
    *   **Virtual Machine Name:** Unique DNS name (e.g., `Ubuntu-Server`).
    *   **Region:** Choose based on latency and cost (e.g., **Central India**).
    *   **Availability Options:** (See detailed explanation in Section 5 below).
    *   **Image:** Choose the OS (e.g., **Ubuntu Server 20.04 LTS**). Similar to **AWS AMI**.
    *   **Size:** Select VM Series (CPU/RAM). Similar to **AWS Instance Type**.

### Step 2: Choosing the Right Size (Series)
Azure uses alphabetical series to denote hardware specialization:
*   **B-Series:** Burstable (Testing/Dev).
*   **D-Series:** General Purpose (Standard workloads).
*   **E-Series:** Memory Optimized (Databases).
*   **F-Series:** Compute Optimized (High CPU).
*   **N-Series:** GPU (AI/ML/Graphics).
*   **L-Series:** Storage Optimized.
*   **H-Series:** High Performance Computing (Supercomputing).

### Step 3: Authentication
*   **SSH Public Key:** Azure generates a key pair automatically if you don't provide one. (Similar to AWS Key Pairs).
*   **Password:** You can choose to set a username (e.g., `azureuser`) and a password manually.
*   **Note:** Azure supports both **Password** and **SSH Key** authentication, whereas AWS primarily relies on Keys for Linux.

### Step 4: Disks
*   **OS Disk Type:**
    *   **Premium SSD:** High performance (Production).
    *   **Standard SSD:** Balanced cost/performance.
    *   **Standard HDD:** Cost-effective (Cheaper), slower. Good for non-critical workloads.
*   **Default Size:** Usually 30 GB for OS disk.

---

## 5. Deep Dive: Availability Options (Interview Critical)

When creating a VM, you must choose one of the following availability strategies.

### Option A: No Infrastructure Redundancy Required
*   **Definition:** The VM is placed on a single physical rack or update domain. There is no backup or failover mechanism provided by Azure.
*   **SLA (Service Level Agreement):** None or very low (e.g., 95%).
*   **Cost:** Cheapest option.
*   **Use Case:** Development, Testing, Non-critical apps where downtime is acceptable.
*   **Risk:** If the physical hardware fails, your application goes down immediately.

### Option B: Availability Zones
*   **Definition:** Azure automatically replicates your VM across **multiple physical zones** (e.g., Zone 1, 2, and 3) within the region.
*   **Mechanism:** If you select "Zone 1, 2, 3", Azure creates 3 separate VM instances in different data centers.
*   **SLA:** High (e.g., 99.99%).
*   **Pros:**
    *   **High Availability:** If one data center floods or loses power, the others in different zones keep running.
    *   **Load Balancing:** Traffic is distributed across zones.
*   **Cons:**
    *   **Cost:** You are billed for **multiple VMs** (one per zone).
*   **Use Case:** Production environments, Banking, E-commerce, Critical systems where downtime is unacceptable.

### Option C: Availability Sets (Brief Mention)
*   **Definition:** Logical grouping of VMs within the same data center but placed on different physical hardware (Fault Domains) and update groups (Update Domains).
*   **Use Case:** Legacy applications or when you need isolation within a single site without the cost of multi-zone redundancy.

---

## 📝 Summary for Interview

**Q: What is the difference between Availability Zones in AWS and Azure?**
*   **Answer:** In AWS, almost every region has Availability Zones. In Azure, only specific regions support Availability Zones (like Central India). You must check region capabilities before designing HA architecture.

**Q: When would you choose "No Infrastructure Redundancy"?**
*   **Answer:** I would choose this for Dev/Test environments or non-critical workloads where cost is the priority and potential downtime due to hardware failure is acceptable.

**Q: What is a Virtual Machine Scale Set?**
*   **Answer:** A VMSS is an Azure compute resource that lets you deploy and manage a set of identical VMs. With VMSS, the number of VM instances can automatically increase or decrease based on demand or a defined schedule.

---
