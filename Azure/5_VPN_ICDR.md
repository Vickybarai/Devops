
#Lecture 5: VPN Gateway & Hybrid Connectivity

## 📌 Todays Topics Covered
1.  **Hybrid Cloud:** Connecting On-Premise Data Center with Azure.
2.  **VPN Gateway:** Creating the gateway in Azure.
3.  **Local Network Gateway:** Configuring the on-premises device.
4.  **Address Space:** Defining IP ranges (CIDR) for the connection.
5.  **Connection Type:** Site-to-Site (S2S) VPN.

---

## 1. The Concept of Hybrid Cloud

### What is Hybrid Cloud?
A **Hybrid Cloud** is a setup where you extend your on-premises data center (your office/legacy servers) into the Azure Cloud. It allows resources on both sides to communicate as if they are on the same network.

### Why do we need it?
*   **Migration:** Moving legacy apps to the cloud gradually.
*   **Compliance:** Keeping sensitive data on-prem while using cloud for compute.
*   **Disaster Recovery:** Using Azure as a backup for your local servers.

---

## 2. Azure VPN Gateway

### What is a VPN Gateway?
The **VPN Gateway** is a specific type of virtual network gateway that sends encrypted traffic between your Azure Virtual Network (VNet) and an on-premises location.

### Types of VPN Gateways
1.  **Route-based VPN:**
    *   Supports IKEv1 VPN protocol.
    *   Path: Travels over the **Public Internet**.
    *   **Cost:** Cheaper, but depends on internet stability.
    *   **Use Case:** Connecting small branch offices or home offices.
2.  **ExpressRoute:**
    *   Path: Private, dedicated connection from Azure to your ISP/Provider.
    *   **Benefit:** Higher security, lower latency, more reliable (does not traverse public internet).
    *   **Cost:** More expensive than Route-based VPN.

---

## 3. Configuration Steps

To establish the Hybrid connection, you need to configure two main components:

### Step 1: Create Azure VPN Gateway
1.  **Prerequisite:** You must have a **Virtual Network (VNet)** created first.
2.  **Gateway Subnet:** Create a dedicated subnet within the VNet specifically for the Gateway (usually named `GatewaySubnet`).
3.  **Public IP:** The gateway requires a **Public IP address** to communicate with the outside world.
4.  **Creation:**
    *   Go to **Virtual Network Gateway** in the Azure Portal.
    *   Click **Create**.
    *   Select **VPN** (Type) and **Route-based** or **ExpressRoute** (SKU).
    *   Select the **VNet** and **Gateway Subnet**.
    *   Assign a **Public IP**.

### Step 2: Configure Local Network Gateway (On-Premises)
This is the router/firewall device located at your physical office or data center.

1.  **Device IP:** The **Public IP address** provided by your ISP.
2.  **Internal Address Space:** The private IP range used inside your office (e.g., `192.168.0.0/16` or `10.0.0.0/8`).
3.  **Address Space:** You must define the address range that represents your on-prem network to Azure so they know which IPs to route.
    *   *Note:* Ensure this does not overlap with your Azure VNet address space.

---

## 4. Address Space & CIDR (Important Concept)

When configuring the connection, Azure asks for the **Local Network Address Space**.

*   **Format:** defined in **CIDR** (Classless Inter-Domain Routing) notation.
*   **Examples:**
    *   `10.0.0.0/16`
    *   `192.168.0.0/24`
    *   `172.16.0.0/16`
*   **Rule:** The on-premises address space and the Azure VNet address space **must not overlap**. They must be unique.

> **Instructor Note:** "10.0.10.10" or "192.168..." (from the audio context) refers to specific IPs being entered or verified within these ranges.

---

## 5. Establishing the Connection

Once both gateways are configured:

1.  **Azure Side:** The VPN Gateway is now waiting for a connection.
2.  **Local Side:** You configure your on-premises router with the Azure **Public IP** and the pre-shared **Key** (if applicable).
3.  **Connection Type:** **Site-to-Site (S2S)**.
    *   This creates a permanent, always-on connection.
4.  **Status:** It usually takes a few minutes to show as "Connected".

---

## 6. Use Cases & Interview Questions

**Q: What is the difference between Route-based VPN and ExpressRoute?**
*   **Answer:**
    *   **Route-based:** Goes over public internet. Cheaper, variable latency.
    *   **ExpressRoute:** Is a private, dedicated line from a service provider. More expensive, consistent low latency, higher security.

**Q: What component do I need on my on-premises side?**
*   **Answer:** A **Local Network Gateway** (router/firewall device) that supports IKEv1 for VPN. It must have a static Public IP.

**Q: What happens if the Address Spaces overlap?**
*   **Answer:** The connection will fail. You must ensure your on-premises IP range (e.g., `10.0.0.0/8`) and your Azure VNet IP range (e.g., `10.1.0.0/16`) are different.

---
