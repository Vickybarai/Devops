
## 📖 1. The Architectural
In previous days, all code lived in `main.tf`. This works for learning, but fails in the real world.
**The Modular Approach:**
We encapsulate specific functionalities into self-contained folders.
*   **The Root (`main.tf`):** The "Orchestrator." It doesn't build resources; it *calls* the builders.
*   **The Modules:** The "Builders." They contain the logic to create specific parts of the infrastructure (Network, Servers, Databases).

### Why? (The "Intellectual Insights")
1.  **Reusability (DRY Principle):** If you need to create a VPC for a "CPZ Project" and a "DYL Project," you don't rewrite the code. You just call the VPC module twice with different names.
2.  **Abstraction:** Developers using the module don't need to know *how* the VPC is created, they only need to provide the *CIDR block*.
3.  **Implicit Dependencies:** Terraform is smart enough to know that if the EC2 module needs a Subnet ID from the VPC module, it must finish the VPC module first.

---

## 🏗️ 2. The Infrastructure Blueprint

### High-Level Structure
```text
/day4-project-eagle
├── main.tf                 # The "Boss" (Calls modules)
├── variables.tf            # Global Inputs (AMI IDs, Names)
├── modules/                # The "Toolbox"
│   ├── vpc/
│   │   ├── main.tf         # VPC, IGW, Route Tables, Subnets
│   │   ├── variables.tf    # Module-specific inputs (CIDR)
│   │   └── outputs.tf      # Returns IDs to the Root
│   └── ec2/
│       ├── main.tf         # Security Groups, Instances, ALB, ASG
│       ├── variables.tf    # Needs Subnet IDs from VPC
│       └── outputs.tf      # Returns URLs/IPs
```

---

## 💻 3. Step-by-Step Implementation

### Step 1: The VPC Module (`modules/vpc`)

This module creates the network foundation. It must be generic so it can be reused for any project.

**`modules/vpc/variables.tf`**
*Defines what the outside world needs to tell us.*
```hcl
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}
```

**`modules/vpc/main.tf`**
*The actual logic.*
```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true # CRITICAL: Makes it public
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# Route Table (Route traffic to IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Data source for AZs
data "aws_availability_zones" "available" {}
```

**`modules/vpc/outputs.tf`**
*The "Return Ticket." We give these IDs back to the Root so it can pass them to other modules.*
```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}
```

---

### Step 2: The Root Orchestrator (`main.tf`)

This is where the magic happens. We call the VPC module and pass variables.

```hcl
# 1. Call the VPC Module
module "vpc_network" {
  source = "./modules/vpc"

  project_name        = "eagle-project"
  vpc_cidr            = "10.10.0.0/16"
  public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
}
```

---

### Step 3: The Compute/EC2 Module (`modules/ec2`)

This module creates the Application Load Balancer (ALB), Auto Scaling Groups (ASG), and Security Groups.

**`modules/ec2/variables.tf`**
*Notice we ask for `subnet_ids` and `vpc_id`—we don't know them yet, we just expect them.*
```hcl
variable "project_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "instance_type" {
  default = "t3.micro"
}
```

**`modules/ec2/main.tf`** (Condensed Logic)
*This looks similar to Day 3, but uses variables for networking.*

```hcl
# Security Group
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = var.vpc_id # Using passed variable

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer
resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = var.public_subnet_ids # Using passed variable list

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Target Groups (Example: Home, Mobile, Laptop)
resource "aws_lb_target_group" "home_tg" {
  name     = "${var.project_name}-home-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Launch Template (Home)
resource "aws_launch_template" "home_lt" {
  name_prefix   = "${var.project_name}-home-"
  image_id      = "ami-0c7217cdde317cfec" # Use variable in prod
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              echo "<h1>Home App</h1>" > /var/www/html/index.html
              EOF
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "home_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [aws_lb_target_group.home_tg.arn]

  launch_template {
    id      = aws_launch_template.home_lt.id
    version = "$Latest"
  }
}

# Listener & Rules would go here...
```

---

### Step 4: Connecting the Dots (The Root `main.tf` Update)

Now we call the EC2 module and pass the *outputs* of the VPC module as the *inputs* of the EC2 module.

**Root `main.tf`:**
```hcl
# ... VPC Module call from Step 2 ...

# 2. Call the EC2 Module
module "app_layer" {
  source = "./modules/ec2"

  project_name      = "eagle-project"
  vpc_id            = module.vpc_network.vpc_id              # <--- THE LINK
  public_subnet_ids = module.vpc_network.public_subnet_ids  # <--- THE LINK
  instance_type     = "t3.micro"
}
```

### 🧠 The "Implicit Dependency" Magic
In the code above:
1.  Terraform sees `module.vpc_network.vpc_id` inside the `module "app_layer"` block.
2.  It realizes: *"I cannot create the App Layer until I know the VPC ID."*
3.  It automatically builds the VPC Module first, gets the ID, and *then* builds the EC2 Module.
4.  **No `depends_on` required.**

---

## 🚀 5. Execution & Best Practices

### Running the Project
Since the code is now modular, you run commands from the **Root** directory. Terraform automatically looks into the module folders.

```bash
terraform init
# Output: Initializing modules...
# - app_layer in modules/ec2
# - vpc_network in modules/vpc

terraform plan
terraform apply
```

### Critical Best Practices (From the Lectures)

1.  **Sensitive Outputs:** If your module outputs a Database Password or Secret Key, mark it as sensitive to prevent it from showing up in plain text in your terminal logs.
    ```hcl
    output "db_password" {
      sensitive = true
      value     = aws_db_instance.main.password
    }
    ```

2.  **Generic Naming:** Do not hardcode "Project Eagle" inside the module logic. Always use `var.project_name`. This allows you to use `./modules/vpc` for "Project Eagle" *and* "Project Tiger" without changing a line of code inside the module folder.

3.  **Versioning:** In a real enterprise scenario, you would source modules from a Git repository or Terraform Registry (e.g., `source = "git::https://github.com/..."`) rather than a local folder, ensuring everyone uses the exact same version of the infrastructure code.