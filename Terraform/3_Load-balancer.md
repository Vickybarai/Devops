

# 🏗️ Project: High-Availability Path-Based Routing Infrastructure

### 🎯 Objective
Deploy an Application Load Balancer (ALB) that routes traffic to three separate Auto Scaling Groups (ASG) based on the URL path:
*   `/` or `/home*`  $\rightarrow$ **Home ASG** (Default)
*   `/mobile*` $\rightarrow$ **Mobile ASG**
*   `/laptop*` $\rightarrow$ **Laptop ASG**

---

### 📂 Project Structure
We will split the code into modular files for better management, just like the instructor did.

```text
/day3-terraform
├── provider.tf           # AWS Provider & Region
├── variables.tf          # Input Variables (AMI, Instance Type, etc.)
├── sg.tf                 # Security Groups & VPC Data Source
├── launch_template.tf    # EC2 Blueprints (Home, Mobile, Laptop)
├── alb.tf                # Load Balancer, Target Groups, Listeners & Rules
├── autoscaling.tf        # ASG Configuration & Scaling Policies
└── outputs.tf            # ALB DNS Name output
```

---

### 🚀 Step-by-Step Implementation

#### Step 1: Define Variables (`variables.tf`)
Define the reusable parameters. This ensures we don't hardcode values, making the script dynamic for different environments.

```hcl
variable "project" {
  description = "Project name for tagging"
  default     = "cdec"
}

variable "env" {
  description = "Environment name"
  default     = "dev"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (us-east-1)"
  default     = "ami-0c7217cdde317cfec" # Example Amazon Linux 2 AMI
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t3.micro"
}
```

#### Step 2: Provider & Data Sources (`provider.tf`)
Set up the AWS provider. Note: We use the **Default VPC** for simplicity, matching the transcript.

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

# Data source to fetch the Default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to fetch Default Subnets (Required for ALB)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
```

#### Step 3: Security Groups (`sg.tf`)
Create a common security group to allow HTTP (80) and SSH (22) traffic. This will be attached to both the ALB and the EC2 instances.

```hcl
resource "aws_security_group" "main_sg" {
  name        = "${var.project}-${var.env}-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${var.project}-${var.env}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.main_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.main_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.main_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
```

#### Step 4: Launch Templates (`launch_template.tf`)
Define the blueprint for the instances. We create three templates, each with unique `user_data` to serve different content.

```hcl
# 1. Home Launch Template
resource "aws_launch_template" "home_lt" {
  name_prefix   = "${var.project}-${var.env}-home-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = "your-key-pair-name" # Replace with your actual key pair

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              echo "<h1>This is the HOME Page</h1>" > /var/www/html/index.html
              EOF
  )
}

# 2. Mobile Launch Template
resource "aws_launch_template" "mobile_lt" {
  name_prefix   = "${var.project}-${var.env}-mobile-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = "your-key-pair-name"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              mkdir /var/www/html/mobile
              echo "<h1>This is the MOBILE App Page</h1>" > /var/www/html/mobile/index.html
              EOF
  )
}

# 3. Laptop Launch Template
resource "aws_launch_template" "laptop_lt" {
  name_prefix   = "${var.project}-${var.env}-laptop-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = "your-key-pair-name"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              mkdir /var/www/html/laptop
              echo "<h1>This is the LAPTOP Page</h1>" > /var/www/html/laptop/index.html
              EOF
  )
}
```

#### Step 5: Load Balancer & Target Groups (`alb.tf`)
**CRITICAL STEP:** This is where the transcript got stuck. We must define the Target Groups, the ALB, the Listener (Port 80), and the **Listener Rules** for path-based routing.

```hcl
# 1. Create Target Groups
resource "aws_lb_target_group" "home_tg" {
  name     = "${var.project}-${var-env}-home-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  
  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "mobile_tg" {
  name     = "${var.project}-${var.env}-mobile-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path = "/mobile/" # Important: Health check matches the content path
  }
}

resource "aws_lb_target_group" "laptop_tg" {
  name     = "${var.project}-${var.env}-laptop-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path = "/laptop/"
  }
}

# 2. Create the Application Load Balancer
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

# 3. Create the Listener (Port 80)
# The "Host" at the door.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  # Default action: If no path matches, go to Home
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.home_tg.arn
  }
}

# 4. Create Listener Rules (Path-Based Routing)
# Rule for Mobile
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

# Rule for Laptop
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

#### Step 6: Auto Scaling Groups (`autoscaling.tf`)
**CRITICAL STEP:** We must attach the Target Groups to the ASG using the `target_group_arns` argument. Without this, the ALB has no servers to send traffic to.

```hcl
# 1. Home ASG
resource "aws_autoscaling_group" "home_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.home_tg.arn] # The Link!

  launch_template {
    id      = aws_launch_template.home_lt.id
    version = "$Latest"
  }
}

# 2. Mobile ASG
resource "aws_autoscaling_group" "mobile_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.mobile_tg.arn] # The Link!

  launch_template {
    id      = aws_launch_template.mobile_lt.id
    version = "$Latest"
  }
}

# 3. Laptop ASG
resource "aws_autoscaling_group" "laptop_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.laptop_tg.arn] # The Link!

  launch_template {
    id      = aws_launch_template.laptop_lt.id
    version = "$Latest"
  }
}

# Optional: Scaling Policy (Scale up if CPU > 60%)
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  autoscaling_group_name = aws_autoscaling_group.home_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value       = 60.0
  }
}
```

#### Step 7: Outputs (`outputs.tf`)
To get the URL easily after deployment.

```hcl
output "alb_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.main_alb.dns_name
}
```

---

### 🏃 Execution Steps

1.  **Initialize:**
    ```bash
    terraform init
    ```
2.  **Plan:**
    Review the resources to be created.
    ```bash
    terraform plan
    ```
3.  **Apply:**
    Deploy the infrastructure.
    ```bash
    terraform apply --auto-approve
    ```
4.  **Verify:**
    Once complete, copy the `alb_dns_name` from the output.
    *   Open in browser: `http://<alb-dns-name>/` $\rightarrow$ Shows "Home Page"
    *   Open in browser: `http://<alb-dns-name>/mobile` $\rightarrow$ Shows "Mobile App Page"
    *   Open in browser: `http://<alb-dns-name>/laptop` $\rightarrow$ Shows "Laptop Page"

### 💡 Key Architectural Takeaways
1.  **The "Missing Link":** In Terraform, the connection between the ASG and the ALB is the **Target Group ARN**. You must define `target_group_arns` inside the `aws_autoscaling_group` resource.
2.  **Routing Logic:** The ALB doesn't magically know how to route. You need a **Listener** (Port 80) with a **Default Action**, plus **Rules** that define conditions (like `/mobile*`) to override the default.
3.  **User Data:** This is used to bootstrap the instances. Since we aren't using Ansible or Puppet here, the bash script in `user_data` installs Apache and writes the specific HTML files immediately upon startup.