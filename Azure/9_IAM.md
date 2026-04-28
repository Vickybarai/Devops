

# 🎓 Lecture Notes: Azure Infrastructure (IAM, VMs, and Load Balancer)

## 1. Azure IAM (Identity and Access Management)
### Introduction
*   **AWS Comparison:** You have seen AWS IAM.
*   **Azure Equivalent:** Azure IAM.
*   **Core Concept:** Identical. Used to manage **Access** (Who can do what) and **Identity** (Who is the user?).
*   **Similarity:** Concepts are same (Users, Groups, Roles, Policies). Only the implementation and name differ.

### Key Differences & Features in Azure IAM

#### A. Types of Identities
When assigning identities to resources (like VMs), you generally see two types:
1.  **User Assigned Managed Identity:**
    *   **Definition:** An identity created by the Azure platform.
    *   **Lifecycle:** Managed entirely by Azure. You don't have to worry about rotation or deletion. If you delete the resource (VM), the identity is deleted with it.
    *   **Usage:** Commonly used when you don't need a specific Active Directory integration.
2.  **Custom Managed Identity:**
    *   **Definition:** An identity you create and manage.
    *   **Lifecycle:** You control when to delete or rotate it.
    *   **Use Case:** When you need specific permissions or integration with your existing on-premises Active Directory (AD).

#### B. Role-Based Access Control (RBAC)
*   Just like AWS, Azure uses **RBAC** to restrict access.
*   **Example:** You can have a "Reader" role (can only view data) or a "Contributor" role (can make changes).

---

## 2. Azure Virtual Machines (Deep Dive)
This section covers specific behaviors and configurations of VMs that were discussed in detail.

### A. Important: Availability Set
*   **Recap:** This is a logical grouping of VMs to ensure high availability (SLA > 99.95%).
*   **Why create it first?**
    *   If you create a VM individually and *then* add it to a Load Balancer, you might miss out on high availability features.
    *   **Best Practice:** Create the **Availability Set** *before* creating the VMs, so they are automatically distributed across fault domains.
*   **Domains:**
    *   **Fault Domains:** Protects against hardware/rack failure (power loss, network switch failure).
    *   **Update Domains:** Protects against software updates (Windows updates, patches). Azure ensures VMs in different update domains aren't patched simultaneously.

### B. VM Lifecycle & Smart Defaults
Azure has some "Smart" defaults (Automatic behaviors) you should be aware of:
1.  **Auto-Start/Stop:**
    *   If you see a VM status as "Stopped," it might still cost you money or be reachable if you configure auto-start based on metrics.
    *   *Instructor Note:* Be careful. If you think it's stopped but it's auto-starting, you might get unexpected bills or access issues.
2.  **Deletion Behavior ("Deallocation"):**
    *   **Scenario:** If you delete a VM, the OS disks (VHDs) might be kept in storage for some time before final deletion.
    *   *Implication:* You might see storage costs even after the VM is "gone." You must manually delete the disks to stop paying.

### C. IP Addressing Confusion
The instructor discussed a scenario involving IP addresses, likely related to Load Balancer frontend IPs.
*   **Observation:** "Google 1" and "Google 2" IP addresses were visible/configured.
*   **Takeaway:** Just like assigning DNS names, Azure (or any provider) requires specific configurations for IP mappings.
*   **Load Balancer Context:** A standard Public Load Balancer usually gets **one Public IP** (Frontend). All backend VMs communicate via this single IP using different ports.

---

## 3. Azure Load Balancer (Advanced Concepts)
This moves beyond basic setup to how traffic is actually managed.

### A. The Backend Pool & Health Probes
*   **Backend Pool:** This is the collection of your Virtual Machines (e.g., `VM1`, `VM2`).
*   **Health Probes:**
    *   This is the "heartbeat" check.
    *   **Function:** The Load Balancer sends a request (e.g., HTTP `GET /`) to your VM.
    *   **Logic:**
        *   **200 OK:** VM is Healthy $\rightarrow$ Traffic allowed.
        *   **404/503:** VM is Unhealthy $\rightarrow$ Traffic stopped.
    *   **Importance:** Without this, if `VM1` crashes, the Load Balancer will keep sending users to the crashed server, causing errors for your application.

### B. Session Affinity (Source IP)
*   **Problem:** If a user has a multi-step login (Login $\rightarrow$ Dashboard), and request 1 goes to `VM1`, but request 2 goes to `VM2`, the user is logged out (Session lost).
*   **Solution:** Enable **Session Affinity**.
*   **Configuration:** Set to `Source IP`.
*   **Result:** User A always goes to `VM1` for the duration of their session.

### C. Layer 7 vs. Layer 4 (Application Gateway)
The instructor noted confusion about an option ("Application Gateway") not appearing where expected.
*   **Network Load Balancer (Standard/Basic):** Works at **Layer 4** (Transport Layer). It looks at TCP/UDP packets but doesn't inspect the content (URL).
*   **Application Gateway:** Works at **Layer 7** (Application Layer).
    *   **Capability:** Can route based on URL path (e.g., `/images` to one pool, `/api` to another).
    *   **Use Case:** SSL Termination (offloading HTTPS), URL-based routing, WAF (Web Application Firewall).

---

## 4. Monitoring Service (Recap)
A quick review of the previously discussed monitoring concepts.

### A. Azure Monitor
*   **Function:** Tracks metrics (CPU, Memory, Network, Disk).
*   **Alerts:** You define thresholds (e.g., CPU > 90%).
*   **Action Group:** Defines who gets notified (Email, SMS, ITSM tools).
*   **Auto-Scaling:**
    *   **Scale Out:** When CPU/Network is high, add new VMs automatically.
    *   **Scale In:** When load drops, remove extra VMs to save money.

### B. Comparison with AWS
*   **AWS:** Uses **CloudWatch**.
*   **Azure:** Uses **Azure Monitor**.
*   **Concept:** 100% identical. Both deal with Metrics, Logs, Dashboards. Only the UI and implementation differ.

### C. Recovery Services Vault
*   **Function:** Stores backups (Snapshots) of resources.
*   **Soft Delete:** Keeps deleted backup data for **14 days** as a safety net.
*   **Retention Policies:** Define how long to keep daily, weekly, or monthly backups.

---

## 5. 🎯 Interview Preparation: Key Questions

**Q1: What is the difference between "User Assigned" and "Custom Managed Identity" in Azure?**
*   **Answer:**
    *   **User Assigned:** Managed by Azure. Lifecycle is tied to the resource. Deleted when VM is deleted.
    *   **Custom Managed:** Managed by you (or your organization). You control lifecycle and rotation. Needed for Active Directory integration usually.

**Q2: Why is an "Availability Set" important in Azure?**
*   **Answer:** Because it spreads VMs across **Fault Domains** (hardware isolation) and **Update Domains** (software isolation). If you put two VMs on the same rack and that rack loses power, both VMs go down. An Availability Set guarantees this doesn't happen.

**Q3: What is a "Health Probe" in a Load Balancer?**
*   **Answer:** It is a mechanism the Load Balancer uses to check the health of backend VMs (e.g., via Port 80). If a VM stops responding, the LB marks it "Unhealthy" and stops sending traffic there to prevent 502 Bad Gateway errors for users.

**Q4: What is "Session Affinity" (Sticky Sessions)?**
*   **Answer:** A setting that ensures all requests from a specific user (IP address) are sent to the *same* backend VM for a set duration. This is required for stateful applications (like shopping carts) so users don't get logged out repeatedly.

**Q5: What is the difference between Azure Load Balancer (Layer 4) and Application Gateway (Layer 7)?**
*   **Answer:**
    *   **Azure Load Balancer:** Operates at Layer 4 (TCP/UDP). It distributes traffic but doesn't look at the HTTP path or content.
    *   **Application Gateway:** Operates at Layer 7 (HTTP/HTTPS). It can route based on URL paths, supports SSL offloading, and offers higher-level security features (WAF).

**Q6: In Azure, if you delete a Virtual Machine, is the data deleted immediately?**
*   **Answer:** Not necessarily. Azure often performs a "Soft Delete" operation where the OS disks are kept in storage for a few hours/days (Deallocation) before final deletion. You must manually delete the disks to stop storage costs.

**Q7: Can you create a Load Balancer without an Availability Set?**
*   **Answer:** Yes, you can attach individual VM NICs to a Backend Pool. However, for a production High Availability (HA) setup guaranteed by Azure SLA, it is mandatory to use an Availability Set to ensure VMs are distributed across physical hardware racks (Fault Domains).k