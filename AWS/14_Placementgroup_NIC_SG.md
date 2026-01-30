## Topic: Placement Groups

### Definition
A **Placement Group** is a **logical grouping of EC2 instances within a single Availability Zone**.  
It is a **networking strategy** that influences how instances are placed on underlying hardware, impacting:
- Network latency
- Throughput
- Fault tolerance

---

### Placement Group Strategies

#### 1. Cluster
- Instances placed close together
- Same physical hardware
- Use cases:
  - Low latency
  - High network throughput
  - HPC workloads

#### 2. Spread
- Instances placed on distinct hardware
- Reduces risk of simultaneous failures
- Use cases:
  - High availability
  - Critical applications

#### 3. Partition
- Instances distributed across partitions
- Each partition has separate racks
- Use cases:
  - Large distributed systems
  - Hadoop, Kafka

---

### Steps: Create Placement Group & Launch Instance

#### Step 1: Create Placement Group
- EC2 → Placement Groups
- Click **Create Placement Group**
- Name:
- Choose Strategy:
  - Cluster / Spread / Partition
- Create

#### Step 2: Launch EC2 Instance
- EC2 Dashboard → Launch Instance
- Set:
  - Name
  - AMI
  - Instance Type
- Advanced Details → Placement Group
- Select Created Placement Group
- Launch Instance

---

## Topic: Network Interfaces & IP Addresses

### Elastic Network Interface (ENI)

**Definition:**  
An **Elastic Network Interface (ENI)** is a **virtual network card** for an EC2 instance.  
It can be **attached, detached, and moved** between instances.

**Use Case:**  
High Availability architectures (failover, migration)

---

### ENI Attributes
- Primary Private IPv4 address
- Can have Elastic IP attached
- Associated with:
  - Subnet
  - Security Group

---

### Elastic IP Address (EIP)

**Definition:**  
A **static public IPv4 address** that remains the same even if:
- Instance is stopped
- Instance is restarted

**Purpose:**  
- Persistent public access
- Avoid IP change during restarts

---

### Placement Group Reminder (Notebook)

- **Cluster:** Low latency & high throughput
- **Spread:** Hardware isolation for availability

---

### Steps: NIC & Elastic IP

#### Step 1: Launch EC2 Instance

#### Step 2: Create Network Interface
- EC2 → Network Interfaces → Create Network Interface
- Name:
- Select Subnet
- Choose Security Group
- Create

#### Step 3: Attach NIC to Instance
- Select NIC → Actions → Attach
- Select EC2 Instance

#### Step 4: Allocate Elastic IP
- EC2 → Elastic IPs
- Allocate Elastic IP Address

#### Step 5: Associate Elastic IP
- Select Elastic IP → Actions → Associate
- Resource Type: Network Interface
- Select NIC → Associate

---

## Topic: Security Groups vs NACLs

### Interview Importance
> One of the **most frequently asked AWS interview topics**

---

### Security Groups (SG)

- Firewall at **Instance Level**
- **Stateful**
  - If inbound is allowed, outbound response is automatically allowed
- Rules:
  - Allow rules only
  - No explicit deny

---

### Network Access Control Lists (NACLs)

- Firewall at **Subnet Level**
- **Stateless**
  - Must explicitly allow both inbound & outbound traffic
- Rules:
  - Allow
  - Deny
- Rules processed in **numerical order**

---

### Steps: Find NACL for a Subnet

#### Step 1: Locate Subnet
- VPC → Subnets
- Select Subnet → Manage
- Details Tab → Find **Associated NACL ID**

---

### Step 2: Add Inbound Rule (NACL)

- Click NACL ID
- Inbound Rules Tab
- Edit Inbound Rules → Add Rule
- Fields:
  - Rule Number (lower number = higher priority)
  - Traffic Type (HTTP / HTTPS / All Traffic)
  - Source: `0.0.0.0/0`
  - Action: Allow or Deny
- Save

---

### Step 3: Add Outbound Rule (Mandatory)

- Outbound Rules Tab
- Add Rule
- Same configuration logic
- Save

---

### Important Note (Notebook Highlight)

- NACL is **Stateless**
- **Both inbound & outbound rules are mandatory**
- Missing one direction = ❌ No traffic

---

## Final Interview One-Liner 🧠

> **Security Group remembers traffic. NACL does not.**

---