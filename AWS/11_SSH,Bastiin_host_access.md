
# VPC Peering & SSH Jump / Bastion Host Access

---
1. VPC Peering

Definition:
VPC Peering is a networking connection between two Virtual Private Clouds (VPCs) that allows them to communicate privately using private IP addresses.

Enables routing traffic between VPCs without traversing the public internet

Ensures security, low latency, and high bandwidth

Can be within the same region or across regions


Use Cases:

Private communication between resources in different VPCs

Sharing databases or services without exposing them to the Internet

Avoids complex VPN setups (AWS-managed solution)


Key Points:

Connectivity: One-to-One (VPC to VPC)

Security: Controlled via Security Groups + Route Tables

Supports: Same region or cross-region peering


Diagram / Route Table Notes:

VPC 3 (Route Table) → VPC 4 → Private Subnet → Private IP
VPC 4 (Route Table) → VPC 3 → Public Subnet → Private IP

Requester: Test-VPC3 (10.0.0.0/18)
Accepter: Test-VPC4 (172.31.0.0/18)


---

2. SSH Jump / Bastion Host Access

Definition:
A Bastion Host (or Jump Host) is an intermediary EC2 instance used to securely access private instances in a private subnet via SSH.

Workflow Steps

Step 1: Create VPC

VPC only → Name → IPv4 CIDR block: 10.0.0.0/16

Other settings (IPv6, Tenancy, Tags) → Defaults → Create


Step 2: Create Internet Gateway (IGW)

Name → Create → Attach to the created VPC


Step 3: Create Subnets

Public Subnet: CIDR 10.0.0.0/24 → Create

Private Subnet: CIDR 10.0.2.0/24 → Create

AZ: No preference


Step 4: Configure Route Tables

Public Route Table

Add Route: 0.0.0.0/0 → IGW

Subnet Association: Public Subnet → Save


Private Route Table

No Internet access route

Subnet Association: Private Subnet → Save



Step 5: Launch Public EC2

Name: test-public

Ubuntu, t2.micro, Storage default

Key Pair: Old / Create new

Network Settings:

VPC: Created

Subnet: Public

Auto-assign Public IP: Enable

Security Group: Create SSH (22) inbound


Launch instance


Step 6: SSH into Public Instance (Bastion)

MobaxTerm / SSH session

Use public IP of EC2 and key pair


Step 7: Launch Private EC2

Name: test-private

Network Settings:

VPC: Same as above

Subnet: Private

Auto-assign Public IP: Disable


Launch instance


Step 8: Access Private EC2 via Bastion

ssh -i classkey.pem -J ubuntu@<public-EC2-IP> ubuntu@<private-EC2-IP>
# -J flag: Jump through public EC2 (Bastion) to reach private EC2


**Step 8: Create NAT Gateway**
1. Name: `My-Nat-Gateway`
2. Subnet: **Public Subnet**
3. Connectivity Type: Public
4. Elastic IP Allocation:
   - Allocate a new Elastic IP → Assign to NAT Gateway
5. Update Private Route Table:
   - EC2 Console → Route Tables → Select Private RT → Actions → Edit Routes
   - Add Route:  
     ```
     Destination: 0.0.0.0/0
     Target: NAT Gateway → My-Nat-Gateway
     ```
   - Save
6. Subnet Association:
   - Edit Subnet Association → Select Private Subnet → Save

**Step 9: Test Connectivity from Private EC2**
```bash
# Update permissions for key
chmod 400 classkey.pem
# Connect to private EC2 via NAT Gateway / SSH
ssh -i classkey.pem ubuntu@10.0.2.78
# Test Internet access
ping www.google.com

Step 10: Deletion / Cleanup

Terminate EC2 instances

Delete NAT Gateway

Detach & Delete Internet Gateway (IGW)

Delete Subnets

Delete VPC

Delete Route Tables

Release Elastic IP



---

## 3. NAT Gateway (Continued)

**Definition:**  
A NAT Gateway allows EC2 instances in **Private Subnets** to access the Internet for outbound traffic while preventing inbound connections from the Internet.

### Workflow Steps



NAT Gateway Placement: Must reside in Public Subnet

VPC Peering Security: Configure both Route Tables + Security Groups

Bastion Host Security: Limit SSH access to your IP only; avoid exposing private instances directly

Cleanup: Always follow proper deletion order to prevent dependency errors:

1. EC2 → NAT Gateway → IGW → Subnets → Route Tables → VPC → Elastic IP

