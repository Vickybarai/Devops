
# Terraform

## What is Terraform?

Terraform is an **Infrastructure as Code (IaC)** tool developed by **HashiCorp** that allows you to define, provision, and manage infrastructure using code instead of manual processes.

Instead of creating resources from a cloud console, you write configuration files that describe your infrastructure, and Terraform ensures the real environment matches that definition.

---

# 1️⃣ Why Terraform? (Problem Statement Before IaC)

## Before Infrastructure as Code

### A. Using Console (UI-Based Provisioning)

#### Issues

- No version control  
- Hard to replicate identical infrastructure  
- Manual dependency handling  
- Time consuming  
- High repetition  
- No proper documentation  
- High probability of human error  
- Not scalable  
- Not suitable for Disaster Recovery  

#### Core Problem

Manual infrastructure is not reproducible or auditable.

---

### B. Using CLI / Shell Script

Better than UI, but still limited.

#### Issues

- Script duplication  
- Hard to manage dependencies  
- Poor state tracking  
- Cannot easily import existing resources  
- No centralized state management  
- Difficult rollback  
- Complex for large environments  

#### Core Problem

No infrastructure state management.

---

# 2️⃣ Terraform Introduction & Benefits

- **Created by:** HashiCorp  
- **Concept:** Infrastructure as Code (IaC)  
- **Language:** HCL (HashiCorp Configuration Language)  
- **Approach:** Declarative (Define *what*, not *how*)  

---

## What Terraform Actually Solves

- Infrastructure provisioning automation  
- Version-controlled infrastructure  
- Identical infrastructure across environments  
- State management  
- Change tracking (`terraform plan` before `apply`)  
- Multi-cloud support  
- Disaster Recovery readiness  
- Reduced human error  

---

# Terraform vs Ansible vs Shell Script (Interview View)

| Feature | Terraform | Ansible | Shell Script |
|----------|------------|------------|----------------|
| Type | Provisioning Tool | Configuration Tool | Automation Script |
| Approach | Declarative | Mostly Imperative | Imperative |
| State Management | Yes | No (limited) | No |
| Infra Creation | Strong | Possible but not core | Manual |
| Idempotency | Yes | Yes | No |
| DR Friendly | Yes | Partial | No |

---

## Interview-Ready One-Line Answer

**If Ansible can create EC2, why Terraform?**

> Terraform is purpose-built for infrastructure provisioning with state management and lifecycle control, whereas Ansible is optimized for configuration management after infrastructure is provisioned.

If further clarification is required:

> Terraform manages infrastructure lifecycle; Ansible manages configuration inside the infrastructure.

---

# 3️⃣ Terraform Syntax & Execution Rules

## Language

- HCL (Preferred)
- JSON (Alternative)

## File Extensions

- `.tf`
- `.tf.json`

---

## Example

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-12345"
  instance_type = "t2.micro"
}
```

Terraform internally builds a dependency graph before execution.

---

4️⃣ The 7 Terraform Blocks (Must Memorize)

This is high-priority interview content.

Block	Purpose	
Provider	Connects Terraform to a cloud	
Resource	Creates infrastructure	
Data	Reads existing infrastructure	
Variable	Makes configuration dynamic	
Output	Displays resource values	
Module	Reusable infrastructure components	
Terraform	Configures Terraform settings	

---
Standard Block Syntax

```hcl
<block_type> "<resource_type>" "<block_name>" {
    key = value
}
```
___

1. Provider

Defines the cloud platform.

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

Without a provider, Terraform does not know where to create infrastructure.

---

2. Resource

Creates or manages infrastructure.

Examples: EC2, VPC, S3, IAM

```hcl
resource "aws_instance" "web" {
  instance_type = "t2.micro"
}
```

This is the core building block of Terraform.

---

3. Data

Fetches details of existing infrastructure. Used when the resource already exists.

Examples: Fetch existing AMI, Fetch existing VPC

```hcl
data "aws_ami" "latest" {
  most_recent = true
}
```

---

4. Variable

Makes code dynamic and reusable.

```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

Execution Rules

1. Terraform executes in the current working directory  
2. Verify directory using `pwd`  
3. All `.tf` files in the directory execute together  
4. Order of file names does not matter  
5. Order of blocks does not matter (Terraform builds dependency graph automatically)  

---



---

5. Output

Prints values after `terraform apply`.

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

Used for visibility and integration.

---

6. Module

Reusable Terraform code.

- Avoids repetition
- Improves standardization
- Promotes clean architecture

Examples: Reusable VPC module, Reusable EC2 module

---

7. Terraform Block

Configures Terraform itself.

Used for:
- Required Terraform version
- Backend state configuration
- Required providers

```hcl
terraform {
  required_version = ">= 1.0"
}
```

---

Terraform Installation, Resource Configuration & Lifecycle

---

1️⃣ Terraform Installation & Setup

Installation (Linux – Amazon Linux / Ubuntu)

Step 1: Download from Official Website
- Go to the official Terraform website (HashiCorp).
- Download the Linux binary.
- Unzip and move it to `/usr/local/bin`.

Example (Linux)

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```

For Ubuntu:

```bash
sudo apt update
sudo apt install terraform
```

Step 2: Verify Installation

```bash
terraform -version
```

If installed correctly, it shows the Terraform version.

---

2️⃣ Provider and Resource Blocks

Terraform uses the Terraform Registry documentation to define provider and resource blocks.

---

Provider Block

Defines which cloud platform Terraform will interact with.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Without provider configuration, Terraform does not know:
- Which cloud to use
- Which region to deploy resources in

---

Resource Block (EC2 Example)

This block defines actual infrastructure.

```hcl
resource "aws_instance" "my-instance" {
  ami                    = "ami-xxxxxxxx"
  instance_type          = "t3.micro"
  key_name               = "new-key"
  vpc_security_group_ids = []

  tags = {
    Name = "my-instance"
    env  = "dev"
  }
}
```

Key Points

Attribute	Description	
`ami`	OS image ID	
`instance_type`	Server size	
`key_name`	SSH key	
`vpc_security_group_ids`	Firewall rules	
`tags`	Metadata for identification	

Terraform supports:
- String values
- Boolean values
- List
- Map

Example:

```hcl
instance_type = var.instance_type
```

---

3️⃣ Connecting VS Code to AWS

Terraform requires AWS credentials to create resources.

Step 1: Create Access Keys in AWS IAM
- Go to IAM
- Create user
- Attach required permissions (Example: AdministratorAccess for learning)
- Generate Access Key & Secret Key

Step 2: Configure Credentials Locally

```bash
aws configure
```

Provide:
- AWS Access Key
- AWS Secret Key
- Region
- Output format (json)

Terraform automatically uses these credentials.

---

4️⃣ Terraform Lifecycle Commands (Interview Critical)

These commands define Terraform workflow.

---

1. terraform init

Initializes the project.

- Downloads provider plugins
- Creates `.terraform` directory
- Creates `.terraform.lock.hcl`

```bash
terraform init
```

---

2. terraform plan

Shows execution blueprint.

- Compares desired state vs current state
- Displays what will be created, modified, or destroyed
- No actual changes happen

```bash
terraform plan
```

Interview Keyword: "Execution plan preview"

---

3. terraform apply

Executes the plan and creates infrastructure.

```bash
terraform apply
```

Terraform asks for confirmation before execution.

---

4. terraform apply -auto-approve

Skips confirmation prompt.

```bash
terraform apply -auto-approve
```

Used in:
- CI/CD pipelines
- Automation

---

5. terraform destroy

Deletes infrastructure created by Terraform.

```bash
terraform destroy
```

⚠️ Not recommended directly in production.

---

5️⃣ Auto-Generated Files (State & Tracking)

After running init and apply, Terraform generates:

---

1. .terraform/

Hidden directory containing:
- Downloaded provider plugins
- Backend information

---

2. .terraform.lock.hcl

- Locks provider versions
- Ensures consistent provider usage across team members
- Prevents version mismatch issues

---

3. terraform.tfstate

Most critical file.

- Tracks current infrastructure state
- Maps real AWS resources to Terraform configuration
- Enables change detection
- Used during plan and apply

Interview Line:

> Terraform state file is the single source of truth for infrastructure lifecycle tracking.

---

Architecture Understanding (Interview Depth)

Terraform Workflow:

1. Write Code (`.tf`)
2. Run `terraform init`
3. Run `terraform plan`
4. Run `terraform apply`
5. State file updated
6. Future changes compared against state

---

Terraform Plan Symbols

In Terraform plan output, these symbols indicate the action Terraform will take:

Symbol	Action	Example	Meaning	
`+`	Create	`+ aws_instance.web`	A new EC2 instance will be created	
`-`	Destroy	`- aws_instance.web`	Existing EC2 instance will be removed	
`~`	Update In-Place	`~ instance_type: "t2.micro" => "t3.micro"`	Instance type will be changed	
`-/+`	Destroy and Recreate	`-/+ aws_instance.web`	Resource cannot be updated in-place, so it will be destroyed and created again	

---

One-line interview summary:

> `+` create, `-` destroy, `~` modify, `-/+` replace.
