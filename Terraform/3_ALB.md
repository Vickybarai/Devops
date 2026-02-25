**Project:** Day 3 - Auto Scaling & Application Load Balancer (ALB)
**Goal:** Create a scalable infrastructure that routes traffic to different services (Home, Mobile, Laptop) based on the URL path.

---

## 📂 1. Project Architecture & File Structure

Before diving into code, visualize how these files connect:

1.  **Networking (`sg.tf`):** Creates the firewall rules and finds the default VPC.
2.  **Compute Blueprints (`lt.tf`):** Defines *how* to build servers (Home, Mobile, Laptop).
3.  **Traffic Controller (`alb.tf`):** The Load Balancer, Listeners, and Routing Rules.
4.  **Scalability (`asg.tf`):** Manages the fleet of servers and connects them to the Load Balancer.
5.  **Configuration (`provider.tf`, `variables.tf`, `output.tf`):** Settings and outputs.

---

## 📄 2. File-by-File Documentation

### A. `provider.tf`
**Purpose:** Configures the AWS provider and region. This is the entry point for Terraform to know where to create resources.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```
**Key Points:**
*   Defines `us-east-1` (N. Virginia) as the deployment region.
*   Locks the AWS provider version to `~> 5.0` to ensure compatibility.

---

### B. `variables.tf`
**Purpose:** Centralizes dynamic values. This allows you to change the AMI or Instance Type in one place without editing the main logic.

```hcl
variable "project" {
  default = "cdec"
}

variable "env" {
  default = "dev"
}

variable "ami_id" {
  default = "ami-0c7217cdde317cfec" # Amazon Linux 2
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "terraform-key" # Replace with your actual key pair
}
```
**Key Points:**
*   **Dynamic Naming:** `${var.project}` and `${var.env}` are used throughout other files to name resources (e.g., `cdec-dev-alb`).
*   **Reusability:** Changing `ami_id` here updates it for all Launch Templates.

---

### C. `sg.tf` (Security Groups)
**Purpose:** Defines the "Firewall" for your infrastructure. It fetches the Default VPC and creates a security group allowing HTTP and SSH traffic.

```hcl
# Data Source: Fetch the Default VPC
data "aws_vpc" "default" {
  default = true
}

# Data Source: Fetch Default Subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Resource: Security Group
resource "aws_security_group" "main_sg" {
  name        = "${var.project}-${var.env}-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${var.project}-${var.env}-sg"
  }
}

# Ingress Rule: Allow HTTP (Port 80)
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.main_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Ingress Rule: Allow SSH (Port 22)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.main_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Egress Rule: Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.main_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}
```
**Key Points:**
*   **Data Sources:** Instead of hardcoding VPC ID, we use `data "aws_vpc" "default"` to find it automatically.
*   **Decoupled Rules:** Ingress and Egress are defined as separate resources attached to the Security Group (Modern Terraform style).

---

### D. `lt.tf` (Launch Templates)
**Purpose:** Creates the "Blueprints" for the EC2 instances. We have three services (Home, Mobile, Laptop), so we need three templates.

```hcl
# 1. Home Launch Template
resource "aws_launch_template" "home_lt" {
  name_prefix   = "${var.project}-${var.env}-home-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              echo "<h1>Home Page</h1>" > /var/www/html/index.html
              EOF
  )
}

# 2. Mobile Launch Template
resource "aws_launch_template" "mobile_lt" {
  name_prefix   = "${var.project}-${var.env}-mobile-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              mkdir /var/www/html/mobile
              echo "<h1>Mobile Page</h1>" > /var/www/html/mobile/index.html
              EOF
  )
}

# 3. Laptop Launch Template
resource "aws_launch_template" "laptop_lt" {
  name_prefix   = "${var.project}-${var.env}-laptop-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              mkdir /var/www/html/laptop
              echo "<h1>Laptop Page</h1>" > /var/www/html/laptop/index.html
              EOF
  )
}
```
**Key Points:**
*   **User Data:** The bash script inside `base64encode` runs automatically when the instance boots. It installs Apache and creates specific HTML files to differentiate the services.
*   **Directories:** Notice `mkdir /var/www/html/mobile`. This matches the path we will route to in the Load Balancer.

---

### E. `alb.tf` (Load Balancer & Routing)
**Purpose:** This is the traffic cop. It creates the ALB, Target Groups, and **Listener Rules** to direct traffic.

```hcl
# --- TARGET GROUPS ---
resource "aws_lb_target_group" "home_tg" {
  name     = "${var.project}-${var.env}-home-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_target_group" "mobile_tg" {
  name     = "${var.project}-${var.env}-mobile-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_target_group" "laptop_tg" {
  name     = "${var.project}-${var.env}-laptop-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

# --- LOAD BALANCER ---
resource "aws_lb" "main_alb" {
  name               = "${var.project}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main_sg.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name = "${var.project}-${var.env}-alb"
  }
}

# --- LISTENER (Port 80) ---
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  # Default Action: If no specific path matches, go to Home
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.home_tg.arn
  }
}

# --- LISTENER RULES (Path Based Routing) ---
# Rule 1: Mobile
resource "aws_lb_listener_rule" "mobile_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mobile_tg.arn
  }

  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }
}

# Rule 2: Laptop
resource "aws_lb_listener_rule" "laptop_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.laptop_tg.arn
  }

  condition {
    path_pattern {
      values = ["/laptop*"]
    }
  }
}
```
**Key Points:**
*   **Target Groups:** Logical groupings of instances. The ASG will register instances here.
*   **Listener:** Listens on Port 80. The `default_action` ensures that if someone visits just the root (`/`), they see the Home page.
*   **Listener Rules:** This is the magic. If the URL path contains `/mobile*`, traffic is diverted to the Mobile Target Group.

---

### F. `asg.tf` (Auto Scaling Groups)
**Purpose:** Manages the scaling of instances. **Crucially**, this file links the Launch Templates to the Target Groups.

```hcl
# --- HOME ASG ---
resource "aws_autoscaling_group" "home_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.home_tg.arn] # LINK TO LB

  launch_template {
    id      = aws_launch_template.home_lt.id
    version = "$Latest"
  }
}

# --- MOBILE ASG ---
resource "aws_autoscaling_group" "mobile_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.mobile_tg.arn] # LINK TO LB

  launch_template {
    id      = aws_launch_template.mobile_lt.id
    version = "$Latest"
  }
}

# --- LAPTOP ASG ---
resource "aws_autoscaling_group" "laptop_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.laptop_tg.arn] # LINK TO LB

  launch_template {
    id      = aws_launch_template.laptop_lt.id
    version = "$Latest"
  }
}
```
**Key Points:**
*   **`target_group_arns`**: This argument inside `aws_autoscaling_group` is the "Glue". It tells the ASG: "Hey, when you launch a new server, register it with this Target Group so the Load Balancer can send it traffic."
*   **Capacity:** Set to `min=1, max=2` to stay within AWS Free Tier limits.

---

### G. `output.tf`
**Purpose:** Displays important information after the deployment finishes.

```hcl
output "alb_dns" {
  value = aws_lb.main_alb.dns_name
}
```
**Key Points:**
*   This prints the URL of the Load Balancer. You will copy this output to test your routing in the browser.

---

## 🚀 3. How to Run

1.  **Initialize:** Download providers.
    ```bash
    terraform init
    ```
2.  **Plan:** Verify changes.
    ```bash
    terraform plan
    ```
3.  **Apply:** Build infrastructure.
    ```bash
    terraform apply --auto-approve
    ```
4.  **Test:**
    *   Copy the `alb_dns` output.
    *   `http://<alb-dns>/` -> Shows **Home Page**
    *   `http://<alb-dns>/mobile` -> Shows **Mobile Page**
    *   `http://<alb-dns>/laptop` -> Shows **Laptop Page**