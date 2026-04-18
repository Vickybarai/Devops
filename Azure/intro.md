```markdown
# Azure Lecture Notes: AWS vs. Azure & Core Services

## 📌  Topics Covered

1.  **Azure Account Creation:** Step-by-step setup, prerequisites (Credit Card, Mobile), and Free Tier details ($200 credit for 30 days).
2.  **Console Overview:** Home page, Cloud Shell (Bash/PowerShell), Search Bar, and Notifications.
3.  **The "Middleman" Concept (ARM):** Understanding Azure Resource Manager and how it differs from AWS's direct interaction model.
4.  **Infrastructure as Code (IaC):** Introduction to ARM Templates and comparison with Terraform and CloudFormation.
5.  **Resource Groups:** Logical organization and lifecycle management.
6.  **Virtual Machines (VM):** Deep dive into Azure VM creation compared to AWS EC2 (Instance Types, Authentication, Networking, Storage).

---

## 1. Azure Account Creation Process

### Prerequisites
*   **Email:** A valid email address (Gmail works).
*   **Mobile:** For OTP verification.
*   **Payment:** **Visa or MasterCard** only.
    *   *Note:* Local Rupee debit cards often do not work. UPI options are currently not supported (unlike GCP/AWS which may accept them in some regions).
    *   If you don't have a card, you can use a relative's card. The amount deducted is usually refunded later.

### Steps to Create Account
1.  Go to **`azure.microsoft.com`** and click **"Start Free"**.
2.  **Microsoft Account:** If you don't have one, create it first (fill basic details like Name, Country, Email, Phone). It is mandatory to have a Microsoft account to access Azure.
3.  **Plan Selection:** Select **"Personal Account"**.
    *   You get **$200 credit for 30 days**.
    *   After 30 days, services suspend; they won't auto-debit unless you upgrade.
4.  **Identity Details:** Fill in Name, Email, Phone.
    *   **Address:** Only the **City Name** is required in the address line. State and Postal code are needed.
    *   **Company Name:** If mandatory and you are a student, write **"Student"**.
5.  **Payment:** Enter Credit/Debit card details (Cardholder name, Number, Expiry, CVV).
6.  **Verification:** You may be asked for MFA (Multi-Factor Authentication), but you can skip this initially.
7.  **Console Access:** Once verified, you will land on the **Azure Portal Dashboard**.

---

## 2. Azure Console Overview

Once logged in, you will see the following key areas:

*   **Hamburger Menu (Three lines):** Shows recent services and pinned shortcuts (similar to AWS shortcuts).
*   **Home Button (Microsoft Azure text):** Click this to return to the home page from anywhere in the console.
*   **Search Bar:** Use this to find specific services quickly (e.g., "Virtual Machines").
*   **Cloud Shell:** A built-in browser-based terminal.
    *   **Bash:** For Linux users.
    *   **PowerShell:** For Windows users.
*   **Notifications Bell:** Shows alerts about resource creation/deletion or health issues.
*   **Settings:** For portal configuration.

---

## 3. The "Middleman": Azure Resource Manager (ARM)

This is the most critical conceptual difference between AWS and Azure.

### The Difference
*   **AWS:** You interact directly with services (e.g., directly calling EC2).
*   **Azure:** You **never** interact directly with services. There is a layer in between called **ARM (Azure Resource Manager)**.

### What is ARM?
*   ARM acts as a **middleman** or a "Waiter" between you (the User) and the Azure Services (the Kitchen).
*   Whether you use the Console, CLI, SDK, or API, your request always goes to the **ARM API** first.
*   **Function:** It validates your request, checks your permissions (RBAC), and then communicates with the specific Azure service to execute the action.

### The Restaurant Analogy
*   **You (User):** Cannot go into the kitchen and tell the chef to make a pizza.
*   **ARM (Waiter):** Takes your order, validates it, and tells the kitchen what to do.
*   **Azure Services (Kitchen):** Prepares the resource (VM, Storage) and hands it back to ARM, who serves it to you.

---

## 4. Infrastructure as Code: ARM Templates

Just like AWS has CloudFormation, Azure has **ARM Templates**.

### Comparison Table
| Feature | AWS | Azure |
| :--- | :--- | :--- |
| **Tool Name** | CloudFormation | **ARM Template** |
| **Language** | JSON / YAML | **JSON** |
| **Scope** | AWS Only (Single Cloud) | Azure Only (Single Cloud) |
| **Complexity** | Complex structure | Complex structure (vs Terraform) |
| **Comparison** | | Like **Terraform** but Azure-specific |

### Why use ARM Templates?
It is Infrastructure as Code (IaC). Instead of manually clicking buttons, you write a script (JSON) to deploy resources like VMs, Networks, and Storage in one click. It ensures repeatability.

### The 5 Main Sections of an ARM Template
1.  **Schema:** Defines the version and rules for validating the template structure.
2.  **Parameters:** Inputs provided by the user (e.g., VM Name, Location, Admin Password). This makes the template reusable.
3.  **Variables:** Internal values used for logic/calculations within the template (like a container holding values).
4.  **Resources:** **(Most Important)** This is where you define what you want to create (e.g., Virtual Machine, Storage Account, Virtual Network).
5.  **Outputs:** Values returned after deployment (e.g., Public IP address, VM ID, Connection Keys).

---

## 5. Resource Groups

Before creating any service, you must create a **Resource Group**.

*   **Definition:** A logical container that holds related resources for an Azure solution.
*   **Usage:** Similar to grouping files in a folder.
*   **Lifecycle:** All resources inside a group share the same lifecycle. If you **delete the Resource Group**, all resources within it are deleted automatically.
*   **Billing:** Billing happens at the **Subscription** level, not the Resource Group level, but groups help organize costs.
*   **Strategy:** You can use one Resource Group for multiple small projects, or separate groups for different environments (Dev/Test/Prod).

---

## 6. Virtual Machines (Azure VM) vs. AWS EC2

Creating a VM in Azure follows the same logic as AWS EC2, but the terminology differs.

### Step-by-Step Comparison

| Step | AWS EC2 Term | Azure VM Term | Details |
| :--- | :--- | :--- | :--- |
| **1. Identity** | Instance Name | **Basics / Project Details** | Subscription, Resource Group, and Instance Name. |
| **2. OS Template** | **AMI** (Amazon Machine Image) | **Image** | The template containing the OS (Windows, Ubuntu, CentOS, etc.). |
| **3. Size/Power** | **Instance Type** (t2.micro, m5.large) | **Size** (Series) | Combination of CPU & RAM. See "Instance Families" below. |
| **4. Access** | **Key Pair** (SSH Keys only) | **Authentication** | Azure supports **SSH Key** OR **Password** authentication. |
| **5. Network** | VPC & Security Group | **Virtual Network (VNet)** & **Network Security Group (NSG)** | Controls Inbound/Outbound traffic (Firewall). |
| **6. Storage** | EBS Volumes (Root + EBS) | **OS Disk** & **Data Disk** | SSD or HDD attached to the VM. |

### Instance Families (Sizing)
AWS uses families like T2, M5, C5. Azure uses alphabetical series:

| Azure Series | Equivalent AWS Type | Best For |
| :--- | :--- | :--- |
| **B-series** (Burstable) | T2 / T3 | Testing, Dev, Small web apps. |
| **D-series** | M5 / General Purpose | General usage (Balanced CPU/RAM). |
| **E-series** | R5 / Memory Optimized | Memory-heavy workloads (Databases). |
| **F-series** | C5 / Compute Optimized | CPU-heavy workloads. |
| **N-series** | P/G / GPU | AI, Machine Learning, Graphics. |
| **L-series** | High Storage | Storage intensive applications. |
| **H-series** | High Performance Compute | Super computing tasks. |

### Authentication Methods
*   **AWS:** Strictly Key-Pairs (Public/Private).
*   **Azure:** Flexible. You can choose:
    1.  **Password:** Set a username and password.
    2.  **SSH Public Key:** Upload your public key (similar to AWS).

### Storage Types (Disks)
*   **Standard HDD:** Cheap, slow. Good for development/testing (Cost Effective).
*   **Standard SSD:** Balanced performance and cost.
*   **Premium SSD:** High performance, low latency. Good for production workloads.
*   *(Note: Ultra Disk was mentioned but may not be visible in all subscriptions immediately).*

---

## 7. Summary: Key Differences AWS vs Azure

| Feature | AWS | Azure |
| :--- | :--- | :--- |
| **Management Layer** | Direct Service Interaction | **ARM** (Azure Resource Manager) acts as a middleman. |
| **IaC Tool** | CloudFormation (JSON/YAML) | **ARM Templates** (JSON). |
| **Console Organization** | Regions/VPCs directly | **Resource Groups** (Logical containers) are mandatory. |
| **Naming** | Security Group | **Network Security Group (NSG)**. |
| **VM Authentication** | Key Pairs only | **Password OR SSH Keys**. |

---

```