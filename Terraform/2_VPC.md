# 📘 Practical Guide: Mastering the 5 Core Terraform Blocks

**Objective:** Deploy a secure EC2 Web Server using the 5 core blocks.
**Concept:** Understand how to define parameters (`variable`), read existing cloud info (`data`), create new resources (`resource`), and retrieve results (`output`).

---

## 🏗️ The Architecture
We will build:
1.  **Data Source:** Finds your Default VPC ID automatically.
2.  **Resource (Security Group):** Creates a firewall using that VPC ID.
3.  **Resource (EC2):** Creates a server attached to that Security Group.
4.  **Output:** Displays the Server's Public IP after creation.

---

## 📂 Step 1: Setup Project Structure
>Create a folder named `terraform-practice` and create these empty files inside:
> *   `main.tf` (Provider, Data, Resources)
> *   `variables.tf` (Input definitions)
> *   `outputs.tf` (Result definitions)

---

## 🛠️ Step 2: The Code Implementation

### 1. Open `main.tf`
Copy this code. Notice how we use `data` to get the ID we don't know yet, and pass it to the `resource`.

```hcl
# ---------------------------------------------------------
# BLOCK 1: PROVIDER
# Tells Terraform which cloud to use (AWS) and the region.
# ---------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

# ---------------------------------------------------------
# BLOCK 2: DATA SOURCE
# READ-ONLY. Fetches the ID of the existing Default VPC.
# We don't hardcode the ID because it changes per account.
# ---------------------------------------------------------
data "aws_vpc" "default_vpc" {
  default = true
}

# ---------------------------------------------------------
# BLOCK 3: RESOURCE (Security Group)
# Creates a Firewall.
# KEY CONCEPT: It depends on the Data Block (vpc_id).
# ---------------------------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP and restricted SSH"
  
  # ⚠️ SOLUTION TO "I DON'T HAVE THE ID":
  # We reference the Data Block attribute here.
  vpc_id      = data.aws_vpc.default_vpc.id 

  # Inbound Rule: HTTP (Port 80) - Open to world
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound Rule: SSH (Port 22) - Restricted to specific IP
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # We use a VARIABLE here so we can change it easily without editing code.
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Outbound Rule: Allow all traffic out
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------------------------------------
# BLOCK 3 (CONTINUED): RESOURCE (EC2 Instance)
# Creates the Virtual Machine.
# ---------------------------------------------------------
resource "aws_instance" "web_server" {
  # Using Variables for AMI and Type
  ami           = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_pair

  # Attaching the Security Group we created above
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Web-Server-DevOps"
  }

  # USER DATA: Heredoc syntax (<<-EOF) to run a script on startup
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Deployed via Terraform using 5 Blocks</h1>" > /var/www/html/index.html
              EOF
}
```

---

### 2. Open `variables.tf`
This defines the inputs. We use `default` values so the code runs immediately, but you can override them.

```hcl
# ---------------------------------------------------------
# BLOCK 4: VARIABLES
# Input parameters for your infrastructure.
# ---------------------------------------------------------

variable "image_id" {
  description = "The AMI ID for AWS us-east-1 (Amazon Linux 2023)"
  type        = string
  # Note: AMI IDs are region specific. This one is for us-east-1.
  default     = "ami-0c7217cdde317cfec" 
}

variable "instance_type" {
  description = "Instance size"
  type        = string
  default     = "t3.micro"
}

variable "key_pair" {
  description = "Name of your existing AWS Key Pair for SSH access"
  type        = string
  # ⚠️ CRITICAL: You must change this to a key pair that EXISTS in your AWS account!
  default     = "my-aws-key" 
}

variable "allowed_ssh_cidr" {
  description = "IP address allowed to SSH into the server"
  type        = string
  # ⚠️ SECURITY: Change this to your own IP (e.g., "1.2.3.4/32") for safety.
  # "0.0.0.0/0" allows the whole world (risky, used here for demo).
  default     = "0.0.0.0/0" 
}
```

---

### 3. Open `outputs.tf`
This defines what we want to see *after* Terraform finishes.

```hcl
# ---------------------------------------------------------
# BLOCK 5: OUTPUTS
# Retrieves attributes from the resources after creation.
# ---------------------------------------------------------

output "public_ip_address" {
  description = "The Public IP of the web server"
  # Reference: resource_type.resource_name.attribute_name
  value       = aws_instance.web_server.public_ip
}

output "security_group_id" {
  description = "The ID of the created Security Group"
  value       = aws_security_group.web_sg.id
}
```

---

## 🚀 Step 3: Running the Practical (Commands)

Open your terminal in the folder where you created the files.

### 1. Initialize
Downloads the AWS plugin.
```bash
terraform init
```

### 2. Plan (The "Check" Phase)
This is where Terraform solves the "I don't have the ID" problem.
*   It reads the `data` block -> calls AWS -> gets the VPC ID.
*   It reads the `resource` block -> substitutes the VPC ID.
*   It calculates what will be created.

```bash
terraform plan
```
*Look for the line: `Plan: 2 to add, 0 to change, 0 to destroy.`*

### 3. Apply (The "Create" Phase)
Provisions the actual resources.
```bash
terraform apply
```
*Type `yes` when prompted.*

### 4. View the Result
Once finished, Terraform will print the **Outputs** at the very bottom:

```text
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public_ip_address = "54.210.123.45"
security_group_id = "sg-0987654321"
```

### 5. Verify
Copy the `public_ip_address` and paste it into your browser. You should see:
**"Deployed via Terraform using 5 Blocks"**

---

## 🧠 Cheat Sheet: How Blocks Interact

| Block | Role | Example | Dependency |
| :--- | :--- | :--- | :--- |
| **Provider** | **The Connector** | Connects to AWS | None |
| **Data** | **The Reader** | Finds Default VPC ID | Reads from Cloud |
| **Variable** | **The Input** | AMI ID = `ami-xxx` | Defined by You |
| **Resource** | **The Creator** | Creates EC2 & SG | Uses Data & Variables |
| **Output** | **The Result** | Shows Public IP | Reads from Resource |

## 🛑 Cleanup (Important!)
To stop paying AWS, destroy the resources:
```bash
terraform destroy
```