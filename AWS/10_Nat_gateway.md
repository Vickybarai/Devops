 EFS Protocols & NAT Gateway

---

## 1. Amazon EFS Protocols

**Definition:**  
Amazon Elastic File System (EFS) is a fully managed, **scalable, elastic file storage system** for use with AWS Cloud services and on-premises resources.  

- **File System Protocol:** NFS (Network File System)
- **Supported Versions:** NFSv4.0 & NFSv4.1
- **Key Features:**
  - Fully managed, elastic, and scalable storage.
  - Mountable **concurrently by multiple EC2 instances**.
  - Enables **shared storage across multiple servers**.
  - High availability and durability.
  - Supports multiple availability zones within a region.

**Use Case Examples:**

| Use Case | Description |
|----------|------------|
| Shared Web Content | Multiple web servers share the same static content via EFS |
| Big Data Analytics | Centralized file system for multiple compute nodes |
| Home Directories | Persistent home directories for EC2 Linux instances |

---

## 2. NAT Gateway (Network Address Translation)

**Definition:**  
A **NAT Gateway** enables EC2 instances in **Private Subnets** to initiate outbound connections to the Internet, while **blocking inbound connections** from the Internet.

**Key Points:**
- Provides **Internet access for private instances**.
- Maintains **security** by not exposing private instances directly.
- Fully managed and highly available.

---

## 3. NAT Gateway Workflow

1. **Request:** Private instance sends a request to NAT Gateway.
2. **Translation:** NAT Gateway replaces the private IP with its own public IP.
3. **Forwarding:** Request is forwarded to the Internet.
4. **Response:** Response is routed back to the NAT Gateway and then back to the private instance.

**Illustration (Conceptual):**

```bash
Private EC2 → NAT Gateway (Public Subnet) → Internet
Internet → NAT Gateway → Private EC2
```

---

4. Use Cases for NAT Gateway

Scenario	Description

Software Updates	Private instances download apt/yum updates
API Access	Access public APIs from private subnet resources
Security	Keep private instances isolated from direct internet exposure



---

5. Exam / Interview Traps

Trap 1: Placement Trap

Question: "I created a NAT Gateway and attached it to my Private Subnet, but private instances still can't reach the internet. Why?"

Answer: NAT Gateway must be in a Public Subnet.

Reason: NAT Gateway needs to reach the Internet Gateway (IGW) to route traffic out.



Trap 2: Cost Trap

Scenario: "I left a NAT Gateway running for a month for one update, and my bill was huge. Why?"

Reality: NAT Gateways incur hourly charges (~$0.045/hr) + data processing fees.

DevOps Alternative: Use a NAT Instance (t2.micro) for dev/test environments to save cost, but it's less reliable than a managed NAT Gateway.



---

✅ Summary of Completed AWS Networking & Storage Notes

Cloud Service Models: IaaS, PaaS, SaaS

AWS Infrastructure: Regions, AZs, Edge Locations

EC2 Compute: Launch, SSH, Status Checks, Pricing, AMIs, Nitro

Storage:

EBS Volumes (SSD/HDD, Bootable/Non-Bootable)

Snapshots & DLM

Elastic File System (EFS)

Partitioning & fdisk workflows


Networking:

VPC & Subnets

Route Tables & Security Groups

Internet Gateway & NAT Gateway

Public vs Private Subnet Access



