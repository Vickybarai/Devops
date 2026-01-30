  VPC Peering (Connecting to Private VPC)
___
## 1. Overview

**Definition:**  
VPC Peering is a networking connection between two VPCs that enables private communication using **private IP addresses** without traversing the internet.  

**Use Cases:**  
- Access private resources across VPCs (e.g., databases, services)  
- Maintain low-latency, secure connectivity  
- Avoid VPN complexity  

**Key Points:**  
- One-to-one connectivity (VPC to VPC)  
- Can be **within same region** or **cross-region**  
- Security Groups and Route Tables control traffic flow  

---

## 2. Step 1: Create VPC3 (Requester VPC)

1. AWS Console → VPC → Create VPC  
   - Name: `VPC3`  
   - IPv4 CIDR: `10.0.0.0/18`  
2. Create Subnets for VPC3:
   - **Public Subnet**  
     - Name: `VPC3-public-Subnet1`  
     - IPv4 CIDR: `10.0.0.0/20`  
   - **Private Subnet**  
     - Name: `VPC3-private-Subnet2`  
     - IPv4 CIDR: `10.0.16.0/20`  
3. Create and attach Internet Gateway (IGW):
   - Name: `IGW-VPC3`  
   - Attach to VPC3  

---

## 3. Step 2: Configure Route Table for VPC3

1. Create Route Table → Name: `VPC3-RT` → Select VPC3  
2. Edit Routes:
   - Destination: `0.0.0.0/0` → Target: IGW-VPC3  
3. Associate Subnet:
   - Public Subnet → Save  

> Private Subnet RT will have no IGW route (internal only).

---

## 4. Step 3: Create VPC4 (Accepter VPC)

1. AWS Console → VPC → Create VPC  
   - Name: `VPC4`  
   - IPv4 CIDR: `172.31.0.0/18`  
2. Create Subnet for VPC4:
   - **Private Subnet:**  
     - Name: `VPC4-Subnet-private`  
     - IPv4 CIDR: `172.31.0.0/20`  
3. Route Table for VPC4:
   - Name: `VPC4-RT`  
   - No IGW route required (private subnet)  

---

## 5. Step 4: Launch EC2 Instances

**VPC3 (Public Instance)**  
- Name: `VPC3-Public`  
- AMI: Ubuntu, t2.micro  
- Key Pair: Create/Use existing  
- Network Settings:
  - VPC: VPC3  
  - Subnet: Public Subnet  
  - Auto-assign Public IP: Enable  
- Security Group: Allow ICMP (All) → Anywhere  
- Launch Instance  

**VPC4 (Private Instance)**  
- Name: `VPC4-Private`  
- AMI: Ubuntu, t2.micro  
- Key Pair: Create/Use existing  
- Network Settings:
  - VPC: VPC4  
  - Subnet: Private Subnet  
  - Auto-assign Public IP: Disable  
- Security Group: Allow ICMP (All) → Anywhere  
- Launch Instance  

---

## 6. Step 5: Connect Public Instance via SSH

```bash
# MobaXterm / Terminal
ssh -i key.pem ubuntu@<Public-Instance-IP-of-VPC3>
# Ensure correct permissions
chmod 400 key.pem
# Or path version
chmod 400 /home/ubuntu/key.pem


---

7. Step 6: Create VPC Peering Connection

1. AWS Console → VPC → Peering Connections → Create Peering Connection

Name: VPC-Connection

Requester VPC: VPC3

Account: Same account ✔ (or Another account if needed)

Region: Same Region ✔ (or Another Region)

Accepter VPC: VPC4



2. Accept Peering Request:

Reload → Select request → Actions → Accept





---

8. Step 7: Update Route Tables for Peering

VPC3 RT:

Edit Route → Add route to VPC4 private subnet

Target → Select Peering Connection → Save


VPC4 RT:

Edit Route → Add route to VPC3 public subnet

Target → Select Peering Connection → Save



---

9. Step 8: Test Connectivity via SSH Jump

# From Public Instance (VPC3)
ssh -i key.pem ubuntu@<Private-Instance-IP-of-VPC4>
# Or full path
ssh -i /home/ubuntu/key.pem ubuntu@<Private-Instance-IP-of-VPC4>

# Test ping / connectivity
ping <Private-IP-of-VPC3-or-VPC4>
ping www.google.com

> Note: Private VPC instances cannot access Internet directly unless NAT is configured.




---

10. Step 9: Deletion / Cleanup

1. Terminate EC2 instances


2. Delete Peering Connection


3. Delete VPCs → automatically deletes subnets, route tables, IGW


4. Delete Security Groups & Network Interface Cards (NICs)


