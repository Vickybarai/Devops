Amazon EBS (Elastic Block Store)

Amazon EBS is the primary **persistent block storage** service used with EC2 instances.

---

## 1. Definition & Core Concepts

### What is EBS?
- **EBS (Elastic Block Store)** is a block-level storage service designed for EC2.
- It behaves like a **virtual hard disk** attached to a server.

### Key Characteristics
- **Persistent Storage**
  - Data survives instance **stop/start**
  - Data survives **termination** unless *Delete on Termination* is enabled
- **AZ-Bound**
  - An EBS volume can only be attached to EC2 instances in the **same Availability Zone**
- **Detach & Reattach**
  - Volumes can be detached from one instance and attached to another

### Interview Analogy
> EC2 = Server, EBS = Hard Disk

---

## 2. Types of EBS Volumes

### A. SSD-Based Volumes (Performance-Focused)

#### 1️⃣ General Purpose SSD (gp2 / gp3)
- **Bootable**: Yes
- **Use Case**: OS disks, general workloads
- **gp3 Advantages**:
  - Lower cost than gp2
  - Separate control of IOPS and throughput
- **Best Practice**:
  > Always mention **gp3** in interviews (modern & cost-optimized)

---

#### 2️⃣ Provisioned IOPS SSD (io1 / io2)
- **Bootable**: Yes
- **Use Case**:
  - High-performance databases
  - Mission-critical workloads
- **io2 Advantages**:
  - Higher durability
  - Stable high IOPS
- **Interview Tip**:
  > io2 is preferred for enterprise-grade databases

---

### B. HDD-Based Volumes (Throughput-Focused)

#### 3️⃣ Throughput Optimized HDD (st1)
- **Bootable**: ❌ No
- **Use Case**:
  - Big data
  - Log processing
  - Streaming workloads

---

#### 4️⃣ Cold HDD (sc1)
- **Bootable**: ❌ No
- **Use Case**:
  - Rarely accessed data
  - Cost-sensitive storage

---

### C. Legacy Volume Type

#### Magnetic
- Old generation
- Low durability
- **Not recommended**

---

## 3. Key Features of EBS

- **Durable & Persistent**
- **Scalable** (GBs → TBs)
- **Snapshots**
  - Point-in-time backups
  - Stored in S3
- **AZ Limitation**
  - Cross-AZ or cross-region movement requires:
    - Snapshot
    - AMI

---

# Part 13: Lab – Attach & Detach EBS Volume

## Scenario
Move an EBS volume from **Instance-1** to **Instance-2**.

---

## Step 1: Launch EC2 Instance-1
- Launch an EC2 instance in a chosen AZ.

---

## Step 2: Create & Attach Volume

```bash
# Console steps
EC2 → Volumes → Create Volume
```
Size: 2 GB

Availability Zone must match Instance-1

Attach volume to Instance-1

Device name: /dev/xvdbb



---

Step 3: Format & Mount (Instance-1)
```bash
lsblk
sudo mkfs -t ext4 /dev/xvdbb
sudo mkdir /mnt/data
sudo mount /dev/xvdbb /mnt/data
cd /mnt/data
touch file{1..10}
```
⚠️ Important
Formatting (mkfs) is done only once, on first use.


---

Step 4: Unmount & Detach
```bash
cd ..
sudo umount /dev/xvdbb
```
Console → Detach Volume

⚠️ Avoid Force Detach (data corruption risk)



---

Step 5: Attach to Instance-2

Launch Instance-2 in the same AZ

Attach volume as /dev/xvdbc
```bash

lsblk
sudo mount /dev/xvdbc /mnt
ls /mnt
```
✔️ Data should be visible.


---

Part 14: Disk Partitioning (fdisk)

1. Partitioning Concept

Partitioning divides a raw disk into logical sections for better organization.


---

2. MBR Partition Hierarchy

Primary Partitions

Maximum: 4

OR 3 Primary + 1 Extended


Extended Partition

Acts as a container

Only 1 allowed

Holds logical partitions


Logical Partitions

Created inside Extended

Can scale up to 128



---

3. Linux Device Naming

Primary / Extended (1–4)

/dev/sda1 → OS
/dev/sda2 → Database
/dev/sda3 → Backup
/dev/sda4 → Extended Partition

Logical (Starts from 5)

/dev/sda5 → Logs
/dev/sda6 → Temp
/dev/sda7 → Project


---

Part 15: Lab – Creating Disk Partitions

Scenario

Create a 5GB partition on /dev/xvdb.


---

Step 1: Preparation
```bash
lsblk
```
Root disk: xvda

New disk: xvdb



---

Step 2: Start fdisk
```bash
sudo fdisk /dev/xvdb
```

---

Step 3: fdisk Commands

Command	Action

m	Help
n	New partition
p	Primary
e	Extended
w	Write changes



---

Step 4: Partition Creation Flow

Partition number: 1

Start sector: Enter

End sector: +5G


✔️ Partition created successfully.


---

Interview One-Liners

EBS is AZ-bound storage

Snapshots enable cross-AZ and cross-region recovery

Never re-run mkfs on existing data

Partitioning improves storage organization
