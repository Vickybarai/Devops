
# VPC Peering – Full Lab with Detailed Notes (Notebook Style)

---

## Header Notes (From Notebook)

- **Associate = Connect town**
- VPC Peering = Connecting **two private VPCs**
- Can connect:
  - Same network or different network
  - Same Region or Cross-Region
- Communication happens using **Private IP only**

---

## What is VPC Peering?

**Definition:**  
VPC Peering is a networking connection between two VPCs that allows resources in both VPCs to communicate with each other **privately using private IP addresses**, without traversing the public internet.

**Key Characteristics:**
- One-to-One connection (VPC ↔ VPC)
- No transitive peering
- Low latency & high bandwidth
- Traffic controlled using **Route Tables + Security Groups**

---

## Step 1: Create VPC3 (Public + Private)

### Create VPC3
- Name: `VPC3`
- IPv4 CIDR: `10.0.0.0/18`
- Create

---

### Create Subnet (Public) – VPC3

- VPC: VPC3
- Initial Name: `VPC3-Subnet1-public`
- Edit Settings:
  - Final Name: `VPC3-public-Subnet1`
  - CIDR: `10.0.0.0/20`
- Save

> ⚠️ Subnet will be associated with Route Table **after RT creation**

---

### Create Subnet (Private) – VPC3

- VPC: VPC3
- Edit Settings:
  - Name: `VPC3-private-Subnet2`
  - CIDR: `10.0.16.0/20`
- Save

---

### Create Internet Gateway (IGW)

- Create IGW
- Name: `IGW`
- Attach IGW → Select `VPC3`

---

### Create Route Table – VPC3

- Create Route Table
- Name: `VPC3-RT`
- VPC: VPC3
- Create

**Edit Routes**
- Destination: `0.0.0.0/0`
- Target: Internet Gateway → `IGW`
- Save

**Subnet Association**
- Associate with `VPC3-public-Subnet1`

---

## Step 2: Create VPC4 (Private Only)

### Create VPC4
- Name: `VPC4`
- IPv4 CIDR: `172.31.0.0/18`
- Create

---

### Create Private Subnet – VPC4

- VPC: VPC4
- Name: `VPC4-Subnet-private`
- CIDR: `172.31.0.0/20`
- Save

---

### Create Route Table – VPC4

- Create Route Table
- Name: `VPC4-RT`
- VPC: VPC4
- Create

**Subnet Association**
- Associate with `VPC4-Subnet-private`

> ❌ No IGW route here (Private VPC)

---

## Step 3: Launch EC2 Instances

### Instance in VPC3 (Public)

- Name: `VPC3-Instance`
- AMI: Ubuntu
- Instance Type: t2.micro
- Key Pair: Existing key
- Network Settings:
  - VPC: VPC3
  - Subnet: Public Subnet
  - Auto-assign Public IP: **Enable**
- Security Group:
  - All ICMP IPv4 → Anywhere
- Launch

---

### Instance in VPC4 (Private)

- Name: `VPC4-Instance`
- AMI: Ubuntu
- Instance Type: t2.micro
- Key Pair: Same key
- Network Settings:
  - VPC: VPC4
  - Subnet: Private Subnet
  - Auto-assign Public IP: **Disable**
- Security Group:
  - All ICMP IPv4 → Anywhere
- Launch

---

## Step 4: MobaXterm & Key Configuration

- Open MobaXterm
- Session → SSH
- Host: **Public IP of VPC3 instance**
- Username: `ubuntu`
- Key: `.pem`

```bash
chmod 400 key.pem
# OR
chmod 400 /home/ubuntu/key.pem


---

Step 5: Create VPC Peering Connection

Go to VPC Peering Connections

Create Peering

Name: VPC-Connection


Requester

VPC: VPC3

Account:

Same account → ✔ My account


Region:

Same region → ✔



Accepter

VPC: VPC4

Create



---

Accept Peering Request

Reload page

Select Peering Request

Actions → Accept Request



---

Step 6: Edit Route Tables (⚠️ MOST CRUCIAL STEP)

Edit VPC3 Route Table

Destination: 172.31.0.0/20 (VPC4 Private Subnet)

Target: VPC Peering Connection

Save



---

Edit VPC4 Route Table

Destination: 10.0.0.0/20 (VPC3 Public Subnet private IP range)

Target: VPC Peering Connection

Save



---

Step 7: Verification (MobaXterm)

From VPC3 Instance:

ssh -i key.pem ubuntu@<PRIVATE-IP-OF-VPC4>
# OR
ssh -i /home/ubuntu/key.pem ubuntu@<PRIVATE-IP-OF-VPC4>

Test:

ping <private-ip>


---

Step 8: Peering Formulas & Extra Notes

Peering Connection Formula

n(n-1)/2
Example:
4(4-1)/2 = 12/2 = 6


---

Transit Gateway Note

Used when multiple VPCs need communication

Solves non-transitive peering limitation

Future task:

Transit Gateway

VPC Endpoint




---

Important Security Notes (Bottom Margin)

Security Group + NACL = MOST IMPORTANT

NIC (Network Interface Card) controls traffic

Route Table decides where traffic goes

SG decides who can talk



---

Deletion Order (Complete Cleanup)

1. EC2 Instances


2. VPC Peering Connection


3. Delete VPC

Subnets

Route Tables

IGW
(Automatically removed)





---

Final Interview Truth Bomb 💣

> VPC Peering works only if BOTH route tables are updated.
Even one missing route = ❌ no communication.




