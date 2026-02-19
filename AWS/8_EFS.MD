**Amazon EBS (Elastic Block Storage)** and **Amazon EFS (Elastic File System)** across key features, use cases, and performance characteristics.

---

| Feature       | EBS (Elastic Block Storage) | EFS (Elastic File System) |
|---------------|----------------------------|---------------------------|
| **Definition** | Single EC2 → Block storage. Works like a personal hard disk. | Multiple EC2 → Shared file system. Team shared drive like Google Drive in Cloud. |
| **Attachment** | Can attach to **one EC2 at a time**. | Multiple EC2 instances can access simultaneously. |
| **Access** | Single instance only. | Many instances, across AZs. |
| **Use Case** | Database, OS, application needing **low-latency block storage**. | Shared file storage, web apps, content management. |
| **Scaling** | Fixed size chosen by user (e.g., 100GB, 200GB). | Automatically scales as files are added or removed. |
| **Pricing** | Pay for **allocated storage** (used or not). | Pay for **actual storage used**. |
| **Availability** | Tied to **one AZ**. | Regional → accessible from multiple AZs. |
| **Performance** | High IOPS → fast read/write like SSD. | Good for concurrent access, slightly lower IOPS. |
| **Backup** | Supports snapshots. | Automatically durable & replicated across AZs. |
| **Protocol** | Block-level → behaves like local disk. | NFS (Network File System) Protocol. |


---

🔹 
Amazon Elastic File System (EFS)

Amazon **EFS** is a **scalable, fully managed, shared file storage** service for use with AWS Cloud services and on-premises resources. It allows multiple EC2 instances to access the same file system **simultaneously**, making it ideal for shared workloads.

---

## 1. Definition & Core Features

- **EFS (Elastic File System)**: Centralized storage that can be mounted concurrently on multiple EC2 instances.
- **Scope**: **Region-specific service** (cannot span regions directly; for cross-region, replicate via backup or other services).
- **Protocol**: Uses **NFSv4 (Network File System)** protocol.
- **Port**: Operates on **TCP 2049**.
- **Management**:
  - Fully managed by AWS; no manual file system provisioning required.
  - Only a **mount point setup** is required on the EC2 instance.
  - Mounting via **`fstab`** allows automatic mounting on instance reboot.
- **Performance Modes**:
  - **General Purpose**: Default, low-latency, suitable for most workloads.
  - **Max I/O**: Higher throughput for parallelized workloads (big data).
- **Storage Classes**:
  - **Standard**: Always available.
  - **Infrequent Access (IA)**: Lower cost, automatic migration for infrequently accessed files.

### Use Cases:
- Shared content repository between multiple EC2 instances
- Web serving and content management
- Big data analytics
- DevOps pipelines with shared storage
- Media and entertainment workflows

---

## 2. Lab Workflow – Setting Up EFS

### Step 1: Networking Setup (Security Group)

- **Goal**: Allow NFS traffic and SSH access for configuration
- **Action**:
  1. AWS Console → EC2 → Security Groups → Create New
  2. Inbound Rules:
     - **Type**: NFS → **Port** 2049 → Source: IPv4 (Anywhere / My IP)
     - **Type**: SSH → Port 22 → Source: IPv4 (Anywhere / My IP)
- **Tip**: Restrict SSH to your IP in production for security.

---

### Step 2: Create EC2 Instance

- OS: Ubuntu
- Network: Attach **Security Group** created in Step 1
- Ensure **Security Group ID** matches the configured NFS/SSH rules

---

### Step 3: Create EFS File System

- Navigate: AWS → **EFS Dashboard → Create File System**
- Configuration:
  - **Name**: Optional
  - **Region**: Select region for the filesystem
  - **Lifecycle**:
    - IA: 30 days
    - Archive: 90 days
  - **Network**:
    - Click Manage → Select Security Group for all subnets
    - If missed, save and edit post-creation
- Post-Creation:
  - Click **Attach** → Copy **Mount via IP** command for instance

---

### Step 4: Connect & Configure Instance (Mounting)

1. Install NFS Client:
```bash
sudo -i
apt update
apt install nfs-common -y
```
2. Configure fstab for auto-mount:


```bash
vim /etc/fstab
```
Entry Syntax:

```bash
<efs-ip-address>:/  /mnt/  nfs  defaults  0  0
```
Field Breakdown:

Source Mount: EFS IP

Mount Point: /mnt/

File System: nfs

Mount Options: defaults (automatic mount on boot)

Dump: 0 (disable backup)

Pass: 0 (disable fsck check)



3. Apply Changes:


```bash
systemctl daemon-reload
mount -a
df -h
cd /mnt/
touch testfile.txt
```
Verify testfile.txt is created in /mnt/.



---

Step 5: Verify on 2nd Instance

Launch second EC2 instance in same VPC/subnet

Install nfs-common

Repeat Step 4

Check /mnt/ → File created in first instance should be visible



---

Step 6: Deletion / Cleanup

Delete EC2 instances

Delete EFS File System

Delete Security Group



---

3. Key Points & Interview Notes

EFS is multi-AZ within a region → Highly available & fault-tolerant

NFS Protocol → Concurrent access, shared file system

Port 2049 must be open for NFS traffic in security groups

Mount via fstab for persistent automatic mounting

Best for shared storage scenarios (web servers, analytics, devops pipelines)

Lifecycle policies → Cost optimization using IA and Archive classes

Always test cross-instance visibility before production deployment

