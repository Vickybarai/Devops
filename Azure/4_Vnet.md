
# Lecture 4: Azure Networking Services

## 📌 Today's Topics Covered
1.  **Virtual Networks (VNet):** Logical isolation and addressing (CIDR).
2.  **Subnetting:** Segmenting networks (Public vs. Private subnets).
3.  **Network Security Groups (NSG):** Controlling traffic flow (Inbound/Outbound).
4.  **VPN Gateway:** Connecting On-Premise to Azure (Hybrid Cloud).
5.  **DNS (Domain Names):** Resolving names to IP addresses.

---

## 1. Virtual Network (VNet)

### What is a VNet?
A **Virtual Network (VNet)** is a representation of your own network in the cloud. It logically isolates your Azure resources.
*   **AWS Equivalent:** **VPC (Virtual Private Cloud)**.
*   **Purpose:** Just like you have a network at home/office, VNet allows Azure resources (VMs, DBs) to talk to each other privately and securely.

### Address Space (CIDR)
When creating a VNet, you must define an **Address Space**.
*   **Format:** Defined using **CIDR** notation (Classless Inter-Domain Routing).
*   **Example:** `10.0.0.0/16` or `192.168.0.0/16`.
*   **Meaning:** This defines the range of IP addresses available within that network.

### How to Create?
1.  **Prerequisite:** You must have a **Resource Group** created first.
2.  **Steps:**
    *   Go to **Virtual Networks** in Azure Portal.
    *   Click **Create**.
    *   Provide **Name** (e.g., `myVNet`).
    *   Define **Address Space** (e.g., `10.1.0.0/16`).

---

## 2. Subnetting

### What is a Subnet?
A **Subnet** is a range of IP addresses within your VNet, used to partition the network into smaller segments.
*   **Why use it?**
    *   **Security:** Isolate critical resources (e.g., Database servers) from public-facing resources (Web servers).
    *   **Organization:** Group resources by function (e.g., Web tier, App tier, DB tier).
    *   **Management:** Control traffic flow via NSGs applied to subnets.

### Subnet Types mentioned in Lecture
1.  **Public Subnet:** Resources here (like a Web Server VM) will have direct internet access (Public IP).
2.  **Private Subnet:** Resources here (like Database) are hidden from the internet for security. No Public IP assigned here usually.

---

## 3. Network Security Group (NSG)

### What is an NSG?
An **NSG** contains a list of security rules that allow or deny network traffic to your Azure resources.
*   **AWS Equivalent:** **Security Group**.
*   **Scope:** NSG is associated with a Subnet or a Network Interface (NIC) of a VM.

### Rule Structure (5-Tuple)
Every rule in NSG has specific properties:
1.  **Name:** Identifier for the rule (e.g., `Allow-SSH`).
2.  **Priority:** Integer (100-4096). Lower number = Higher priority.
3.  **Protocol:** TCP, UDP, ICMP, or Any (*).
4.  **Source:** Where is traffic coming from? (e.g., `Any`, `10.0.0.0/16`, or specific IP).
5.  **Source Port Range:** Port on sender's machine (usually `*`).
6.  **Destination:** Target resource (e.g., `Any` or specific VM).
7.  **Destination Port Range:** Port on target machine (e.g., `22`, `80`, `443`).
8.  **Action:** **Allow** or **Deny**.

> **Key Concept:** Rules are processed in priority order. If a rule matches at priority 100, it stops there; it won't check rule 200.

### 🧠 Interview Question: NSG vs. NACL vs. Firewall
*   **Q: Difference between NSG and NACL?**
    *   **Answer:**
        *   **NSG (Security Group):** Works at the **Instance/Subnet level** (Layer 3/4). It is a **Bouncer** standing at the door. It acts as the first filter. It is **Stateful** (remembers connections).
        *   **NACL:** Works at the **Network/Account level**. It acts like a watchman inside the building. It is **Stateless**. Generally, we prioritize NSGs.
*   **Q: Difference between NSG and Azure Firewall?**
    *   **Answer:** NSG filters traffic based on Port/IP (L4). Azure Firewall (WAF) filters based on Application content/Threats (L7). Firewall is more advanced and costly.

---

## 4. VPN Gateway

### What is a VPN Gateway?
A **VPN Gateway** is a specific type of Virtual Network Gateway used to send encrypted traffic between an Azure Virtual Network and an on-premises location.
*   **Use Case:** **Hybrid Cloud**. Extending your data center to Azure.

### Types of Connectivity
1.  **VPN (Virtual Private Network):**
    *   **Protocol:** Uses IPsec/IKE.
    *   **Path:** Travels over the **Public Internet**.
    *   **Cost:** Cheaper, but latency depends on internet.
    *   **Use Case:** Connecting branch offices or small data centers securely.
2.  **ExpressRoute:**
    *   **Path:** Private, dedicated connection from Azure to your ISP/Provider. **Does not traverse the public internet.**
    *   **Benefit:** Higher security, lower latency, more reliable.
    *   **Cost:** More expensive than VPN.

### Configuration Steps
1.  Create a **Gateway Subnet** (must be dedicated, usually `/27` or `/28`).
2.  Create **Public IP** for the gateway.
3.  Configure **Local Network Gateway** (On-Prem) with Azure details (Public IP + Key).
4.  Establish **Connection**.

---

## 5. DNS (Domain Name System)

### What is DNS in Azure?
Azure provides **DNS hosting** to map user-friendly domain names (e.g., `www.mycompany.com`) to the raw IP addresses of your Azure resources (like Load Balancers or Public IPs).

### DNS Names in Azure
When you create a VM, Azure assigns a default DNS name automatically.
*   **Format:** `<vm-name>.<region>.cloudapp.azure.com`
*   **Example:** `mywebserver.eastus.cloudapp.azure.com`
*   **AWS Equivalent:** Route 53.

### Custom Domain Configuration
If you own a domain (e.g., from GoDaddy, Namecheap), you can configure it in **Azure DNS Zones**.
*   **Record Types:**
    *   **A Record:** Maps name to IPv4 (e.g., `www` -> `1.2.3.4`).
    *   **CNAME:** Maps name to another name (alias).

---

## 📝 Summary for Interview

**Q: How do you design a network for a 3-tier app (Web, App, DB) in Azure?**
*   **Answer:** I would create one **VNet** with a large CIDR (e.g., `10.0.0.0/16`). I would create three **Subnets**:
    1.  **Web Subnet:** Public facing, associated with **NSG** allowing ports 80/443.
    2.  **App Subnet:** Private, allowing traffic only from Web Subnet.
    3.  **DB Subnet:** Private, isolated, denying direct internet access.

**Q: What is the difference between VPN and ExpressRoute?**
*   **Answer:**
    *   **VPN:** Uses **Public Internet**. Cheaper, standard IPsec tunnels.
    *   **ExpressRoute:** Uses a **Private, dedicated connection** offered by a service provider. Faster, more secure, more reliable.

**Q: What is an NSG Priority?**
*   **Answer:** An integer (100-4096) that defines the order in which rules are processed. Lower numbers are processed first. If traffic matches a rule at priority 200, it won't check rules 300-4000.

---
