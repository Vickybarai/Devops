L7**,  7: Azure Networking Security (NSG) & Hybrid Connectivity

## 1. Introduction: AWS vs. Azure Security
In AWS, security relies on four main pillars:
1.  **Encryption**
2.  **Security Groups (SG)**
3.  **NACL (Network Access Control List)**
4.  **IAM (Identity and Access Management)**

Azure provides all these features plus more (like MFA). In this lecture, we focus on **Networking Security** within the VNet (Virtual Network).

### Key Difference: AWS vs. Azure Network Security
*   **AWS:** You have **Security Groups** (Instance level) and **NACLs** (Subnet level). You have to configure them separately.
*   **Azure:** You have only one service called **NSG (Network Security Group)**.
    *   **NSG is a combination of both Security Group and NACL.**
    *   You can attach an NSG to a **Subnet** or a **Virtual Machine (NIC)**.
    *   *Analogy:* Think of an NSG as a **Bouncer** standing at the door. He checks the ID of anyone trying to enter (Inbound Traffic) and decides if they can come in.

---

## 2. Deep Dive: Network Security Group (NSG)

### Step-by-Step Documentation: Creating an NSG

**Prerequisite:** A Resource Group (e.g., `Resources`). If not created, create one first.

1.  **Create NSG:**
    *   Go to the Azure Portal -> Search for **Network Security Groups**.
    *   Click **Create**.
    *   **Basics Tab:**
        *   *Subscription:* Select your subscription.
        *   *Resource Group:* Select `Resources`.
        *   *Name:* `securitygroup` (Must be lowercase, no special characters).
        *   *Region:* Select your region (e.g., Central India).
    *   Click **Review + Create** -> **Create**.

2.  **Configuring Inbound Rules (The "Bouncer"):**
    *   Once deployed, go to the resource `securitygroup`.
    *   In the left menu, under **Settings**, click **Inbound rules**.
    *   Click **+ Add**.

### Understanding Rule Fields (Detailed Explanation)

When adding a rule, you will see the following fields. This is crucial for configuration:

1.  **Source:** Where is the request coming from?
    *   **Any:** Anyone from anywhere (Internet).
    *   **IP Addresses:** A specific IP or range (e.g., 192.168.1.10).
    *   **My IP:** Automatically fills your current public IP.
    *   **Service Tag:** A predefined label by Azure (e.g., "Internet", "Storage") that manages IPs for you.
    *   **Application Security Group (ASG):** A custom nickname for a group of VMs.

2.  **Source Port Ranges:** The port used by the sender.
    *   Usually set to `*` (Any), as we rarely filter based on the client's port.

3.  **Destination:** Where is the traffic going?
    *   **Any:** Any resource in the VNet.
    *   **IP Addresses:** Specific internal IP.
    *   **Service Tag / ASG:** Logical labels.

4.  **Service / Destination Port Ranges:** The port on the destination VM.
    *   **Service:** Pre-defined protocols (SSH = 22, HTTP = 80, HTTPS = 443, RDP = 3389).
    *   **Custom:** If using a non-standard port (e.g., 8080).

5.  **Protocol:**
    *   **TCP:** For reliable connections (Web, SSH).
    *   **UDP:** For fast connections (Streaming, DNS).
    *   **Any:** Both.
    *   **ICMP:** Used for `ping` commands.

6.  **Action:**
    *   **Allow:** Let the traffic in.
    *   **Deny:** Block the traffic.

7.  **Priority:** A number between 100 and 4096.
    *   **Lower number = Higher Priority.**
    *   Rules are processed in order. If a rule at Priority 100 allows traffic, the rule at 200 is never checked.
    *   *Example:* Allow SSH (100), Deny All (200).

8.  **Name:** A meaningful name for the rule (e.g., `Allow_SSH`).

**Example Rule:**
*   **Source:** Any (or Service Tag: Internet)
*   **Destination:** Any
*   **Service:** SSH (Port 22)
*   **Action:** Allow
*   **Priority:** 100

---

## 3. Advanced Concepts: Simplifying Management

Managing IP addresses in rules is difficult because IPs change. Azure provides two features to make this easier:

### A. Service Tags (Azure Managed Labels)
Instead of writing `0.0.0.0/0` for the entire Internet, or a complex range of IPs for "Azure Load Balancer", you simply select the **Service Tag**.
*   Azure automatically manages the IP addresses behind these tags.
*   *Example:* Select "Internet" in Source instead of typing IP ranges.

### B. Application Security Group (ASG) (Your Custom Labels)
This allows you to create logical groups of VMs and use the group name in rules instead of IPs.

**Scenario:** You have 3 Web Servers. You want to allow Port 80 (HTTP) only to them.
*   **Old Way:** Create 3 rules, one for each IP (10.0.0.4, 10.0.0.5, 10.0.0.6). If an IP changes, you must edit the rule.
*   **ASG Way:**
    1.  Create an ASG named `WebServers`.
    2.  Add the 3 VMs to this ASG.
    3.  Create **one** NSG Rule: Source -> Any, Destination -> `WebServers`, Port -> 80, Action -> Allow.
    4.  If you add a 4th Web Server later, just add it to the ASG. No need to touch the NSG Rule.

**Steps to Create ASG:**
1.  Search for **Application Security Group**.
2.  Create it in the same Resource Group (`Resources`).
3.  Name it (e.g., `WebServers`).
4.  When creating or editing a **VM**, under the **Networking** tab, you will see an option to select the **Application Security Group**. Select `WebServers` here.

---

## 4. Hybrid Connectivity: Connecting On-Premises to Azure

When you need to connect your office (On-Premises) data center to the Cloud (Azure) securely, you have two main options:

### A. ExpressRoute
*   **Definition:** A private, dedicated connection between your on-premises network and Azure. It does **not** use the public Internet.
*   **Technology:** Uses a direct fiber link from a connectivity provider.
*   **Key Features:**
    *   **Higher Security:** Doesn't touch the public internet.
    *   **High Speed/Low Latency:** Consistent performance.
    *   **Reliability:** More stable than internet connections.
*   **Use Cases:**
    *   Banking systems.
    *   Manufacturing (heavy data transfer).
    *   Disaster Recovery sites.
    *   Mission-critical hybrid clouds.
*   **Cost:** Expensive.

### B. VPN Gateway (Virtual Private Network)
*   **Definition:** Connects on-premises to Azure over the **public Internet** securely using encryption (tunneling).
*   **Key Features:**
    *   **Secure Tunnel:** Data is encrypted, so hackers can't read it.
    *   **Cost-Effective:** Cheaper than ExpressRoute.
    *   **Easy Setup:** Faster to deploy.
    *   **Speed:** Limited by internet speed; higher latency than ExpressRoute.
*   **Use Cases:**
    *   Small to Medium businesses.
    *   Temporary projects.
    *   Backup connection (if ExpressRoute fails).
    *   Remote users connecting to Azure.

### Comparison Summary: ExpressRoute vs. VPN

| Feature | ExpressRoute | VPN Gateway |
| :--- | :--- | :--- |
| **Path** | Private/Dedicated Fiber | Public Internet (Encrypted Tunnel) |
| **Speed** | Very Fast, Consistent | Good, but varies with Internet traffic |
| **Security** | Very High (Never touches Internet) | High (Encryption/Tunneling) |
| **Cost** | Expensive | Affordable/Cost-Effective |
| **Best For** | Large Enterprises, Banking, High Data loads | SMBs, Quick setup, Backup connections |

---

## 5. 🎯 Interview Preparation: AWS vs. Azure

### Q1: What is the difference between AWS Security Groups/NACLs and Azure NSGs?
*   **AWS:** Security Groups (Stateful, Instance level) and NACLs (Stateless, Subnet level) are separate.
*   **Azure:** NSG (Network Security Group) is a single service that functions as both. You can attach an NSG to a Subnet (like NACL) or to a Network Interface (like Security Group). Azure NSGs are **Stateful** by default.

### Q2: How do you handle rules for a group of servers in Azure without managing individual IPs?
*   **Answer:** Use **Application Security Groups (ASG)**. You group VMs logically (e.g., "WebTier") and reference the ASG name in NSG rules. This abstracts the underlying IP addresses.

### Q3: What are Service Tags in Azure?
*   **Answer:** Service Tags are predefined identifiers for groups of IP addresses provided by Azure (e.g., "AzureCloud", "Storage"). Instead of manually entering IP ranges for Azure services, you use the Service Tag, and Azure automatically handles the IP updates.

### Q4: When would you choose ExpressRoute over VPN Gateway?
*   **Answer:** I would choose **ExpressRoute** for mission-critical scenarios requiring high security, speed, and reliability (e.g., Banking, Hybrid Cloud for large enterprises) because it provides a private dedicated connection that doesn't traverse the public internet.
*   **VPN Gateway** is better for cost-effective connectivity, small businesses, or temporary setups where internet-based speed is acceptable.

### Q5: How does Azure NSG rule priority work?
*   **Answer:** Rules are processed in ascending order of priority (lowest number = highest priority). As soon as a rule matches, processing stops. For example, a rule with Priority 100 is checked before Priority 200.

### Q6: If you know AWS, how do you approach learning Azure?
*   **Answer:** The concepts remain the same; only the implementation and names differ. For example, I know that VPC in AWS is VNet in Azure. I know that Security Groups/NACL in AWS combine to become NSG in Azure. I focus on the concept (e.g., filtering traffic) and look for the equivalent service in the Azure portal.