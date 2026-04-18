
# Lecture 3: Azure VM Connectivity, User Data, Extensions, and Storage Accounts

## 📌 Today's Topics Covered
1.  **Connecting to Azure VMs:** SSH, Password, and Public IPs.
2.  **User Data (Custom Script):** Automating VM configuration at startup.
3.  **VM Extensions:** Managing add-on software and agents.
4.  **Storage Accounts:** Deep dive into Blob, File, Queue, and Table storage.
5.  **Storage Redundancy & Tiers:** LRS, ZRS, GRS, and Access Tiers.

---

## 1. Connecting to Azure Virtual Machines

Once your Virtual Machine (VM) is deployed and running, the status changes to "Running". You will be assigned a **Public IP Address**.

### Connection Methods
Azure supports two primary methods for connecting, similar to AWS but with more flexibility:

| Method | Description | Azure Equivalent |
| :--- | :--- | :--- |
| **Password Authentication** | Connect using a username and password set during creation. | Supported (Default for Windows, optional for Linux). |
| **SSH Key Pair** | Connect using a Private Key file (`.pem`) while the Public Key resides on the VM. | Supported (Preferred for Linux). |

### How to Connect (Demo Steps)
1.  **Get IP:** Navigate to the VM blade -> Overview -> Copy the **Public IP address**.
2.  **Tool:** Use an SSH client like **Putty** (Windows) or Terminal (Mac/Linux).
3.  **Credentials:**
    *   **Username:** e.g., `azureuser` (defined during creation).
    *   **Password:** The password you set, OR use your private key file.

> **Note:** Unlike AWS which often forces Key Pairs for Linux, Azure allows both Password and Key authentication for Linux VMs.

---

## 2. User Data (Custom Script) & Automation

### What is User Data?
**User Data** is a script (or configuration) that you pass to the VM during creation. It executes automatically when the VM boots up. This is similar to **EC2 User Data** in AWS.

### ⚠️ Critical Interview Difference: AWS vs. Azure Execution

| Feature | AWS (EC2) | Azure (VM) |
| :--- | :--- | :--- |
| **Execution Frequency** | Runs **ONLY ONCE** on the very first boot (Launch). | Runs **EVERY TIME** the VM boots/restarts. |
| **Re-Run Trigger** | You must explicitly use a "user data execution" script to force it again. | Automatically re-runs on Stop -> Start or Reboot. |

### Why Use User Data?
*   **Automation:** Instead of manually logging in and typing `sudo apt-get install apache2`, you put the install command in the User Data script.
*   **Consistency:** Ensures every time the VM comes up, it has the required software or updates.
*   **Demo:** The instructor used a script to install a web server or update packages automatically upon boot.

### How to Configure?
1.  Go to the **Advanced** tab while creating the VM.
2.  Find **Custom Data / User Data**.
3.  Paste your **Bash script** (cloud-init format).
4.  **Result:** When the VM boots, Azure executes this script as `root` or the designated user.

---

## 3. VM Extensions

### What are Extensions?
**Extensions** are small software applications that provide post-deployment configuration and management tasks on Azure VMs. They are "Add-ons" packaged by Microsoft or Third Parties.

### Extension vs. User Data
*   **User Data:** Best for **Bash scripts** and one-time configuration. It is "raw" code execution.
*   **Extensions:** Best for **Packaged Software** (e.g., Antivirus, Monitoring Agents, Backup tools) that require ongoing management or updates.

### Key Features of Extensions
1.  **Auto-Update:** Extensions can automatically update themselves without user intervention.
2.  **Configuration:** You can push configuration settings from the Azure Portal to the agent running inside the VM.
3.  **Protected Configuration:** Settings are stored securely in Azure, not just in a text file on the VM.

### Common Use Cases
*   **Network Watcher Agent:** For monitoring network performance.
*   **Azure Monitor (Log Analytics):** To collect logs and metrics.
*   **Custom Script Extension:** A specific extension that runs a script stored in Azure Storage (similar to User Data but managed via the extension framework).

---

## 4. Azure Storage Accounts (Deep Dive)

### What is a Storage Account?
A **Storage Account** is a container that holds all your Azure Storage data objects. It acts as a management umbrella.
*   **Concept:** It is the "Parent" object. You cannot create a Blob without a Storage Account.
*   **AWS Mapping:** Similar to an **S3 Bucket** concept, but in Azure, the "Account" holds multiple "Services" (Blobs, Files, etc.).

### ⚠️ Interview Question: Naming Rules
Storage Accounts have **strict naming rules**. If you break these, creation will fail.
1.  **Length:** 3 to 24 characters.
2.  **Case:** **Lowercase only** (No Uppercase).
3.  **Uniqueness:** Must be **globally unique** across all of Azure (like a Gmail address).
4.  **Characters:** Alphanumeric and hyphens only.

### The 4 Core Services Inside a Storage Account

| Service Name | Description | AWS Equivalent | Use Case |
| :--- | :--- | :--- | :--- |
| **1. Blob Storage** | Binary Large Object storage. Stores unstructured data like text, images, videos. | **S3** | Website hosting, video streaming, backup files. |
| **2. File Storage** | Fully managed file shares. Uses SMB (Server Message Block) protocol. | **EFS** (Elastic File System) | "Lift and shift" legacy apps that use file shares. Mountable as a drive on Linux/Windows. |
| **3. Queue Storage** | Asynchronous messaging service. Stores messages between application components. | **SQS** (Simple Queue Service) | Decoupling microservices (e.g., Order processing). |
| **4. Table Storage** | NoSQL store. Stores data as Key-Value pairs (Properties). | **DynamoDB** | Storing user profiles, telemetry data, fast lookups. |

> **Note:** You access these services via **Storage Account Keys** (Access Keys) or **SAS Tokens** (Shared Access Signatures).

---

## 5. Storage Redundancy & Access Tiers

### Redundancy Options (Disaster Recovery)
When you create a Storage Account, you must choose how data is replicated. This determines cost and durability.

| Redundancy Type | Full Name | Architecture | Interview Answer |
| :--- | :--- | :--- |
| **LRS** | Locally Redundant Storage | **3 Copies** in the **same** datacenter (Rack). | **Cheapest.** If the datacenter burns/floods, data is lost. |
| **ZRS** | Zone Redundant Storage | Copies across **Availability Zones** (different datacenters) in one region. | **High Availability.** If one zone fails, data survives. |
| **GRS** | Geo-Redundant Storage | Copies to a **secondary region** (paired region) hundreds of miles away. | **Disaster Recovery.** Used if the primary region goes down completely. |

*   **Note:** **ZRS** is recommended for most production workloads today requiring HA. **GRS** is for critical apps needing disaster recovery (DR) across regions.

### Access Tiers (Cost Optimization)
Depending on how often you access data, you choose a tier to optimize cost:

1.  **Hot Tier:** Default. Frequent access (accessed daily). Highest storage cost, but lowest access cost.
2.  **Cool Tier:** Infrequent access (data not accessed for >30 days). Lower storage cost.
3.  **Archive Tier:** Rare access (data not accessed for >180 days). Lowest storage cost, but high retrieval cost (hours to retrieve).

---

## 📝 Summary for Interview

**Q: What is the main difference between AWS User Data and Azure User Data?**
*   **Answer:** AWS executes the User Data script **only on the first boot**. Azure executes the script **on every boot/restart**.

**Q: What is a Storage Account Naming Rule?**
*   **Answer:** It must be **3-24 characters**, **lowercase only**, and **globally unique**.

**Q: Which Azure Storage service would you use for migrating legacy file share apps?**
*   **Answer:** **Azure File Storage**, because it supports the SMB protocol and can be mounted as a shared drive, similar to AWS EFS.

**Q: How does ZRS differ from LRS?**
*   **Answer:** **LRS** keeps 3 copies in one datacenter (cheap, vulnerable to site failure). **ZRS** keeps copies across different Availability Zones (expensive, protects against site failure).

---
