# EC2 Deep-Dive Notes (Notebook Format)
Covering:
- Instance Types
- Instance Tenancy
- Placement Groups
- Network Interfaces (NIC / ENI)
- Elastic IP
- Security Groups vs NACLs

---

## Topic: EC2 Instance Types

### Definition
**EC2 Instance Types** define the hardware configuration of an EC2 instance, including CPU, memory, storage, and networking capacity. They are grouped based on workload use cases.

---

### Instance Type Families (IQ – Type, Series)

> Format Example: `t3.micro`
- **Family**: t (General purpose)
- **Generation**: 3
- **Size**: micro

---

### Categories of EC2 Instance Types

- **General Purpose**
  - Balanced CPU, memory, and networking
  - Examples: `t2`, `t3`, `t4g`, `m5`
  - Use case: Web servers, dev/test, small databases

- **Compute Optimized**
  - High CPU performance
  - Examples: `c5`, `c6`
  - Use case: Scientific modeling, batch processing, high-performance servers

- **Memory Optimized**
  - High memory capacity
  - Examples: `r5`, `x1`
  - Use case: In-memory databases, real-time big data analytics

- **Accelerated Computing**
  - Uses GPUs / FPGAs
  - Examples: `p`, `g`, `inf`
  - Use case: Machine learning, AI, video rendering

- **Storage Optimized**
  - High IOPS and throughput using local storage
  - Examples: `i3`, `d2`
  - Use case: Data warehousing, log processing

---

## Topic: Instance Tenancy

### Definition
**Instance Tenancy** defines how your EC2 instance is placed on the underlying physical hardware.

---

### Instance Tenancy Types (3 Types)

- **Shared (Default)**
  - Instances may share hardware with other AWS customers
  - Lowest cost
  - Most commonly used

- **Dedicated Instance**
  - Hardware dedicated to **a single AWS customer**
  - May run multiple instances from the same customer
  - No control over the physical host

- **Dedicated Host**
  - A **physical server fully dedicated** to your use
  - Full visibility and control over sockets, cores
  - Required for compliance & licensing (e.g., Oracle, Windows BYOL)

---

### Diagram Notes (From Notebook)

- Rack → Placement Group
- Cluster: EC2 EC2 EC2 close together
- Spread: EC2s on separate hardware
- Partition: Hardware isolation in sections

---

## Topic: Placement Groups

### Definition
A **Placement Group** is a logical grouping of EC2 instances within a single Availability Zone to influence how instances are placed on underlying hardware for performance or availability.

---

### Placement Group Strategies (3 Types)

#### 1. Cluster Placement Group
- Instances placed close together
- Lowest latency & highest throughput
- Best for HPC workloads
- All instances in **single logical cluster**

#### 2. Spread Placement Group
- Instances placed on **distinct hardware**
- Minimizes risk of simultaneous failure
- Best for **high availability**
- Max 7 instances per AZ (important exam point)

#### 3. Partition Placement Group
- Instances spread across **logical partitions**
- Each partition has its own rack
- Used for **large distributed systems** (Hadoop, Kafka)

---

### Steps: Create Placement Group & Launch Instance

#### Step 1: Create Placement Group
- EC2 → Placement Groups
- Click **Create Placement Group**
- Name
- Choose strategy: Cluster / Spread / Partition
- Create

#### Step 2: Launch Instance
- EC2 Dashboard → Launch Instance
- Choose AMI & Instance Type
- Advanced Details → Placement Group
- Select created placement group
- Launch instance

---

## Topic: Network Interfaces & IP Addresses

### Network Interface (ENI)

**Elastic Network Interface (ENI)**  
A virtual network card attached to an EC2 instance.  
ENIs can be **detached and attached** to other instances, enabling high availability architectures.

---

### ENI Attributes

- Primary private IPv4 address
- Secondary private IPv4 addresses (optional)
- Elastic IP (optional)
- MAC address
- Security Groups
- Source/Destination Check flag

---

### Elastic IP Address (EIP)

- Static **public IPv4 address**
- Does NOT change on stop/start
- Associated with:
  - Instance OR
  - Network Interface (recommended)

**Purpose:**
- Stable public endpoint
- Required when auto-assigned public IP is lost

---

### Placement Group Reminder (Notebook Note)

- Cluster → Low latency, high throughput
- Spread → High availability

---

### Steps: Network Interface (NIC) & Elastic IP

#### Step 1: Launch EC2 Instance

---

#### Step 2: Create Network Interface
- EC2 → Network Interfaces → Create Network Interface
- Name
- Select Subnet
- Choose Security Group
- Create

---

#### Step 3: Attach NIC to Instance
- Select NIC → Actions → Attach
- Select EC2 instance
- Attach

---

#### Step 4: Allocate Elastic IP
- EC2 → Elastic IPs
- Allocate Elastic IP Address

---

#### Step 5: Associate Elastic IP with NIC
- Select Elastic IP → Actions → Associate
- Resource Type: Network Interface
- Select NIC → Associate

---

## Topic: Security Groups vs NACLs

### Why This Topic Is Important
One of the **most frequently asked AWS interview topics**.

---

### Security Groups (SG)

- Instance-level firewall
- **Stateful**
- Only **Allow** rules
- Automatically allows return traffic
- Default: deny all inbound

---

### Network ACLs (NACL)

- Subnet-level firewall
- **Stateless**
- Supports **Allow and Deny**
- Must explicitly allow both inbound & outbound
- Rules processed in **number order (low → high)**

---

### Key Differences (Quick View)

| Feature | Security Group | NACL |
|------|------|------|
| Level | Instance | Subnet |
| Stateful | Yes | No |
| Allow / Deny | Allow only | Allow + Deny |
| Rule Order | Not applicable | Rule number |
| Default Behavior | Deny inbound | Allow all |

---

### Steps: Find Subnet & NACL

1. VPC → Subnets
2. Select Subnet → Manage
3. Under Details tab → Find **Associated NACL ID**

---

### Add Inbound Rule (NACL)

- Click NACL ID
- Inbound Rules tab → Edit Inbound Rules
- Add Rule:
  - Rule number
  - Traffic type (HTTP / HTTPS / All)
  - Source: `0.0.0.0/0`
  - Action: Allow / Deny
- Save

---

### Add Outbound Rule (Mandatory)

- Go to Outbound Rules tab
- Add rule using same process
- Save

---

### Important Note (From Notebook)

- NACL is **stateless**
- Both inbound & outbound rules **must exist**
- Missing one direction = traffic fails

---

## Final Interview Truth 💡

> If traffic is not flowing:
> - Check Route Table
> - Check Security Group
> - Check NACL (Inbound + Outbound)
> - Check Source/Destination Check on ENI

---


