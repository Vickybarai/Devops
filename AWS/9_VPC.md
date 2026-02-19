 Amazon VPC (Virtual Private Cloud)

Amazon **VPC** allows you to provision a **logically isolated virtual network** within AWS Cloud where you can launch AWS resources in a controlled network environment.  
It provides **full control over networking**, including IP ranges, subnets, routing, and gateways.

---

## 1. Definition & Core Concepts

- **VPC (Virtual Private Cloud)**: A virtual network dedicated to your AWS account.
- **Key Features**:
  - **Logical Isolation**: Resources inside your VPC are isolated from other AWS accounts.
  - **Custom IP Addressing**: Define IPv4 CIDR ranges (e.g., 10.0.0.0/16) and optional IPv6.
  - **Subnet Segmentation**:
    - **Public Subnet**: Can connect to the internet via IGW.
    - **Private Subnet**: No direct internet access; access through NAT or VPN.
  - **Routing Control**: Full control of **Route Tables**, **Internet Gateways (IGW)**, and **NAT Gateways**.
  - **Security**: Associate **Security Groups** and **Network ACLs** for fine-grained access control.
  - **Scalability**: Can launch multiple subnets, instances, and gateways in the same VPC.

### Components of a VPC:

| Component | Purpose |
|-----------|---------|
| Subnet | Segment VPC into public/private zones |
| Route Table | Define routing rules for traffic |
| Internet Gateway (IGW) | Enables internet connectivity for public subnets |
| NAT Gateway / NAT Instance | Allows private subnet to access internet without exposing it |
| Security Group | Acts as a virtual firewall for EC2 instances |
| Network ACL | Optional stateless firewall for subnet level |

---

## 2. Limits (Per Region)

| Resource | Limit |
|----------|-------|
| VPC | 5 per region |
| Subnets | 200 per region |
| Elastic IP | 5 per region |
| Security Groups | 5 default per VPC |
| SG Rules | 60 inbound + 60 outbound per SG |
| Route Tables | 200 per VPC |

---

## 3. Lab Workflow – Manual VPC Setup

### Step 1: Create VPC

- AWS Console → Search "VPC" → Create VPC
- Settings:
  - **Resources**: VPC Only (Manual)
  - **Name**: My-VPC
  - **IPv4 CIDR**: 10.0.0.0/16
  - **Tenancy**: Default
- **Result**: Default Route Table, Security Group, NACL, DHCP created automatically

---

### Step 2: Create Subnets

#### A. Public Subnet


VPC ID: Select My-VPC
Name: Subnet-1
AZ: Select preference
CIDR: 10.0.0.0/24

B. Private Subnet

VPC ID: Select My-VPC
Name: Subnet-2
AZ: Same or different
CIDR: 10.0.2.0/24


---

Step 3: Create Internet Gateway (IGW)

Go to Internet Gateway → Create IGW

Name: IGW-MyVPC

Attach to VPC:

Actions → Attach to VPC → My-VPC




---

Step 4: Configure Route Tables

Public Route Table

Name: public-RT
VPC: My-VPC
Route: 0.0.0.0/0 → Target: IGW-MyVPC
Subnet Association: Public Subnet-1

Private Route Table

Name: private-RT
VPC: My-VPC
Route: No IGW route
Subnet Association: Private Subnet-2

Note: Each route table automatically contains a local route for intra-VPC communication.


---

Step 5: Create Security Group (Optional)

Name: SG-Public

VPC: My-VPC

Inbound Rules:

HTTP (80) → 0.0.0.0/0

SSH (22) → Your IP only




---

Step 6: Launch EC2 Instances

A. Public Subnet Instance

Network: My-VPC
Subnet: Public Subnet-1
Auto-assign Public IP: ENABLED (Crucial)

B. Private Subnet Instance

Network: My-VPC
Subnet: Private Subnet-2
Auto-assign Public IP: DISABLED


---

Step 7: Connectivity Verification

Public Instance: Accessible via SSH / HTTP

Private Instance: Not accessible directly; requires NAT or VPN



---

Step 8: Deletion Process (Order Matters)

1. Terminate EC2 instances


2. Delete subnets


3. Delete custom route tables


4. Detach & delete IGW


5. Delete VPC




---

4. Key Exam / Interview Notes

Implicit Local Route Trap

Every Route Table has a default Local Route for intra-VPC communication.

Private subnet can reach public subnet internally without adding any extra routes.


Auto-Assign Public IP Nuance

In Default VPC, auto-assign is ON by default.

In Custom VPC, auto-assign is OFF.

Forgetting this will block direct public access; solution: manually assign Elastic IP.


