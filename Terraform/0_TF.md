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
---
>DAY2
---

# 📚 Appendix: Detailed Concepts (Missing from Core Notes)

This section covers the **Arguments** and **Usage** of key concepts that are critical for practical implementation but were summarized briefly in the main notes.

---

# 1️⃣ Variables (Deep Dive)

## The Problem with Hardcoding
If you hardcode values (like `instance_type = "t2.micro"`) in your resources:
1.  You cannot reuse the code for different environments (Dev vs. Prod).
2.  You have to edit the code to change values, increasing the risk of accidental syntax errors.

## The Solution: `variable` Block
Variables act as placeholders. Terraform replaces them with actual values during execution.

### Syntax Definition

```hcl
variable "<variable_name>" {
  description = "Explain what this variable does"
  type        = string  # Optional: string, number, bool, list, map
  default     = "value" # Optional: If not provided, Terraform will ask during runtime
}
```

### How to Use Variables in Resources (Reference)
To use a variable inside a resource block, use the syntax `var.<variable_name>`.

**Example:**

**1. Define the Variable:**
```hcl
variable "instance_size" {
  description = "Size of the EC2 instance"
  default     = "t3.micro"
}
```

**2. Use the Variable in a Resource:**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345"
  instance_type = var.instance_size  # <--- Reference here
}
```

### How to Override Variables (Priority Order)
You don't have to change the code to change the value. You can override `default` in three ways (Highest priority first):

1.  **Command Line (CLI):**
    ```bash
    terraform apply -var="instance_size=t3.large"
    ```
2.  **`.tfvars` File:**
    Create a file named `terraform.tfvars`:
    ```hcl
    instance_size = "t3.large"
    ```
3.  **Environment Variables:**
    ```bash
    export TF_VAR_instance_size="t3.large"
    ```

### Interview Question
**Q: What happens if I define a variable without a `default` value and I don't pass one via CLI?**
**A:** Terraform will stop and prompt you to enter the value interactively in the terminal during the `plan` or `apply` phase.

---

# 2️⃣ Outputs (Deep Dive)

## The Problem
After Terraform creates resources (like an EC2 instance), you need to know critical details to use them (e.g., the **Public IP** address to SSH into the server). You don't want to log into the AWS Console every time to find it.

## The Solution: `output` Block
The output block prints specific attributes of resources to the terminal after `terraform apply` finishes.

### Syntax Definition

```hcl
output "<output_name>" {
  description = "What this value represents"
  value       = <resource_reference>.<attribute>
}
```

### Example Usage

**Resource:**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345"
  instance_type = "t2.micro"
}
```

**Output Block:**
```hcl
output "server_ip" {
  description = "The public IP of the web server"
  value       = aws_instance.web.public_ip
}
```

**Result in Terminal:**
```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:
server_ip = "54.210.123.45"
```

### Why Outputs are Critical (DevOps View)
1.  **Integration:** CI/CD pipelines capture these outputs to automatically configure the next step (e.g., passing the IP to Ansible).
2.  **Visibility:** Quick verification without opening the console.

---

# 3️⃣ Ingress & Egress (Security Groups)

**Important Note:** `ingress` and `egress` are **NOT** top-level blocks like `provider` or `resource`. They are **nested blocks** (arguments) *inside* an `aws_security_group` resource.

## Definitions
*   **Ingress:** Inbound Traffic (Traffic coming **INTO** the instance/server).
*   **Egress:** Outbound Traffic (Traffic going **OUT** from the instance/server).

## Syntax Structure

```hcl
resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"

  # --- INGRESS BLOCK START ---
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80    # Start of port range
    to_port     = 80    # End of port range
    protocol    = "tcp" # tcp, udp, icmp, or -1 (all)
    cidr_blocks = ["0.0.0.0/0"] # Who is allowed? (0.0.0.0/0 = Everyone)
  }
  # --- INGRESS BLOCK END ---

  # --- EGRESS BLOCK START ---
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means ALL protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
  # --- EGRESS BLOCK END ---
}
```

## Arguments Explained

| Argument | Description | Example Values |
| :--- | :--- | :--- |
| `description` | A comment explaining why this rule exists. | `"Allow SSH access"` |
| `from_port` | The start of the port range. | `22` (for SSH) |
| `to_port` | The end of the port range. | `22` (for single port)<br>`8080` (if range 80-8080) |
| `protocol` | The network protocol. | `"tcp"`, `"udp"`, `"icmp"`, `"-1"` (all) |
| `cidr_blocks` | List of IPv4 CIDR blocks allowed to connect. | `["0.0.0.0/0"]` (Public)<br>`["192.168.1.0/24"]` (Private VPN) |

## Common Protocols & Ports (Cheat Sheet)

| Service | Protocol | Port |
| :--- | :--- | :--- |
| SSH | TCP | 22 |
| HTTP | TCP | 80 |
| HTTPS | TCP | 443 |
| MySQL | TCP | 3306 |
| All Traffic | -1 | All |

### Security Best Practice (Interview Tip)
Never allow Ingress on Port 22 (SSH) from `0.0.0.0/0` in a production environment. Always restrict it to your specific office IP address or VPN range.

**Bad Practice:**
```hcl
cidr_blocks = ["0.0.0.0/0"] # Anyone can hack you
```

**Good Practice:**
```hcl
cidr_blocks = ["1.2.3.4/32"] # Only your specific IP can access
```

---

# 🚀 Advanced Concepts & Enterprise Patterns

This section moves beyond basic resource creation to cover State Management, High Availability, and Logic required for professional DevOps roles.

## 1️⃣ Advanced State Management (Remote Backend & Locking)

In the basics, we saw that `terraform.tfstate` is created locally. In a team environment, local state is a disaster waiting to happen.

### The Problem with Local State
*   **Collisions:** Two engineers running `apply` simultaneously.
*   **Secrets:** The state file contains passwords in plain text. Storing it on a laptop is insecure.
*   **Consistency:** Teammates don't know what infrastructure exists.

### The Solution: S3 Backend + DynamoDB Locking
We move the state file to AWS S3 and use DynamoDB to prevent concurrent writes (State Locking).

#### Backend Configuration (`backend.tf`)
```hcl
terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-state" # Your S3 bucket name
    key            = "global/terraform.tfstate"   # Path to state file
    region         = "us-east-1"
    encrypt        = true                         # Encrypt state file at rest
    dynamodb_table = "terraform-locks"           # Table for locking
  }
}
```

#### The Migration Workflow (Chicken & Egg Problem)
You cannot use the S3 backend to create the S3 bucket itself.
1.  Write code for S3 Bucket & DynamoDB Table **without** the backend block.
2.  Run `terraform apply` (Creates resources locally).
3.  Add the `backend` block to your code.
4.  Run `terraform init`.
5.  Terraform asks: *`Do you want to copy existing state to the new backend?`* -> Type **`yes`**.

---

## 2️⃣ Workspaces: Complete Guide

### The Concept
**Terraform Workspaces** allow you to manage multiple distinct states (e.g., Dev, Stage, Prod) within a single configuration directory.

**The Analogy:** Think of Workspaces like **"Save Slots"** in a video game.
*   **Slot 1 (Dev):** You are testing the game. You have a small castle.
*   **Slot 2 (Prod):** This is your main game. You have a huge castle.
*   Even though the *game code* is the same, the *save files* (State) are completely separate. If you delete your castle in Slot 1, Slot 2 is untouched.

---

### Workspace Commands (Cheat Sheet)

| Command | Action | Description |
| :--- | :--- | :--- |
| `terraform workspace list` | List | Shows all available workspaces. The current one is marked with `*`. |
| `terraform workspace show` | Show | Displays the name of the currently selected workspace. |
| `terraform workspace new <name>` | Create | Creates a new workspace and immediately switches to it. |
| `terraform workspace select <name>` | Switch | Switches to an existing workspace. |
| `terraform workspace delete <name>` | Delete | Deletes a workspace. (Only possible if no resources are managed in it). |

---

### How It Works Technically (Under the Hood)
When using a Remote Backend (S3), Workspaces change the **path** where the state file is stored.

```text
s3://my-bucket/
  └── env:/
       ├── default/terraform.tfstate
       ├── dev/terraform.tfstate       <-- Separate state for Dev
       └── prod/terraform.tfstate      <-- Separate state for Prod
```

### Using Workspaces in Code
You can use the built-in variable `terraform.workspace` to make your code dynamic.

**Dynamic Tagging:**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345"
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer-${terraform.workspace}"
    # If in 'dev' -> Name = "WebServer-dev"
    # If in 'prod' -> Name = "WebServer-prod"
  }
}
```

### The "Real World" Workflow (Workspaces + .tfvars)
Pair workspaces with Variable Files for different settings.

**Step 1: Create Variable Files**
*   **`dev.tfvars`**: `instance_type = "t2.micro"`
*   **`prod.tfvars`**: `instance_type = "t3.large"`

**Step 2: Deploy**
```bash
# Deploy to Dev
terraform workspace select dev
terraform apply -var-file="dev.tfvars"

# Deploy to Prod
terraform workspace select prod
terraform apply -var-file="prod.tfvars"
```

### ⚠️ The Production Risk Warning
While Workspaces are powerful, many engineers **avoid** them for critical Production environments due to human error (accidentally running `destroy` while in the prod workspace).
**Enterprise Alternative:** Use **Separate Folders** (`/env/dev` and `/env/prod`) with separate backend configurations for absolute safety.

---

## 3️⃣ High Availability Architecture (ALB & ASG)

Moving beyond single EC2 instances to scalable, resilient infrastructure.

### The Components
1.  **Launch Template:** The "DNA" or Blueprint (AMI, Key, User Data script).
2.  **Auto Scaling Group (ASG):** The Manager. Maintains desired count (e.g., Min 1, Max 5). Adds/removes instances based on load.
3.  **Target Group:** The logical grouping of instances (e.g., "Web Servers").
4.  **Application Load Balancer (ALB):** The Traffic Police. Distributes incoming traffic across the Target Groups.

### The Connection (The "Glue")
You must explicitly link the ASG to the Target Group in Terraform:
```hcl
resource "aws_autoscaling_group" "web_asg" {
  # ... other config ...
  target_group_arns = [aws_lb_target_group.web_tg.arn] # CRITICAL LINK
}
```

### Path-Based Routing (Listener Rules)
The ALB decides where traffic goes based on the URL path.
*   `/mobile*` -> Mobile Target Group
*   `/laptop*` -> Laptop Target Group
*   `/` -> Default (Home) Target Group

---

## 4️⃣ Loops (Meta-Arguments)

Don't repeat code. Use loops to create multiple resources dynamically.

### 1. `count` (The Clone Machine)
Use for **identical** resources.

```hcl
resource "aws_instance" "server" {
  count = 3 # Creates 3 copies
  ami   = "ami-123"
  tags  = { Name = "Server-${count.index}" } # Server-0, Server-1...
}
```

### 2. `for_each` (The Customizer)
Use for **different** resources (different names, sizes).

```hcl
variable "instances" {
  default = ["web", "db", "app"]
}

resource "aws_instance" "server" {
  for_each = toset(var.instances)
  ami      = "ami-123"
  tags     = { Name = each.value } # Name will be "web", "db", or "app"
}
```

### 3. `for` (The Transformer)
Used in **Outputs** to filter/format lists.

```hcl
output "all_ips" {
  # Loop through instances and grab only private IPs
  value = [for s in aws_instance.server : s.private_ip]
}
```

---

## 5️⃣ Managing & Deleting Resources

### Method 1: The "Sniper Shot" (`destroy -target`)
Delete one specific resource immediately without touching code.
*   *Command:* `terraform destroy -target aws_instance.web`
*   *Warning:* If you run `apply` again, Terraform will recreate it because it's still in the code.

### Method 2: The "Clean Up" (Delete Code)
1.  Delete/Comment out the resource block in `.tf` file.
2.  Run `terraform apply`.
3.  Terraform sees the code is gone and deletes the AWS resource. (Recommended method).

### State Recovery (The "Undo Button")
If your state file is corrupted, you can roll back using **S3 Versioning**.
1.  Go to S3 Bucket.
2.  Click `terraform.tfstate` -> **Versions** tab.
3.  Select a previous version -> **Restore**.

---

## 🏁 Final Cheatsheet

### Quick Workflow
1.  Write Code (`.tf`).
2.  `terraform init` (Setup).
3.  `terraform plan` (Preview).
4.  `terraform apply` (Build).
5.  (Optional) `terraform workspace select prod` (Switch env).
6.  (Optional) `terraform apply -var-file="prod.tfvars"` (Deploy specific config).

### Interview One-Liners
*   **Why Terraform?** "For infrastructure provisioning with state management and lifecycle control, distinguishing it from config tools like Ansible."
*   **What is State?** "The single source of truth mapping real resources to code."
*   **Imperative vs Declarative?** "Imperative is *how* to do it (Scripts); Declarative is *what* you want (Terraform)."
*   **Count vs For_each?** "Count is for identical clones; For_each is for distinct custom resources."
*   **Workspaces vs Directories?** "Workspaces use 'Save Slots' for different states in one folder; Directories physically separate code for better production safety."






---

### 1. How to Secure the Terraform State File in S3?

The State file is the most sensitive file in your project because it contains secrets (Database passwords, Access Keys) in plain text. If someone hacks your S3 bucket, they own your infrastructure.

To secure it, you must implement **4 Layers of Security**:

#### A. Enable Encryption at Rest (`encrypt = true`)
This ensures that even if someone gets physical access to the hard drive in AWS's data center, they cannot read your file without the decryption key.

```hcl
terraform {
  backend "s3" {
    bucket         = "my-secure-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true  # <--- THIS IS MANDATORY
    dynamodb_table = "terraform-locks"
  }
}
```

#### B. Enable Versioning
This protects you against accidental deletion or corruption.
*   **How:** Go to the S3 Bucket in the AWS Console -> Properties -> Bucket Versioning -> **Enable**.
*   **Why:** If you accidentally run `terraform destroy` or the file gets corrupted, you can click "Previous Versions" in S3 and restore yesterday's file.

#### C. Block All Public Access
Ensure the bucket is not visible to the internet.
*   **How:** Go to S3 Bucket -> Permissions -> **Block public access (bucket settings)** -> Turn **ON** all 4 settings (Block public access to buckets and objects granted through new ACLs, etc.).

#### D. Restrict Access with IAM Policies (Least Privilege)
Only specific IAM users or roles (like your CI/CD pipeline) should be able to Read/Write to this bucket. Do not use your root AWS account.

---

### 2. How to create without storing state locally? What does this mean?

**"Without storing state locally"** means ensuring that the `terraform.tfstate` file is **never saved permanently on your laptop**. Instead, it is saved directly in the cloud (S3).

#### How it works technically:
1.  You configure the **S3 Backend** in your code (as shown above).
2.  When you run `terraform apply`, Terraform downloads a *temporary copy* of the state into your computer's RAM (Memory) to process the changes.
3.  Once the `apply` is successful, Terraform uploads the new state to S3 and **deletes** the temporary copy from your computer.

#### Why do we do this?
*   **Security:** If your laptop is lost or stolen, your infrastructure secrets are not on the hard drive.
*   **Collaboration:** If the state were local, your teammates wouldn't know what infrastructure exists. By forcing it to S3, everyone sees the same "Source of Truth."

#### How to verify it's working:
1.  Open your project folder.
2.  Run `ls -la` (or `dir` on Windows).
3.  You should **NOT** see a file named `terraform.tfstate`.
4.  If you see it, your backend is not configured correctly, or you haven't run `terraform init` yet.

---

### 3. How to delete a single resource?

There are two ways to do this. One is a "Quick Fix" and the other is the "Proper Way."

#### Method A: The "Sniper Shot" (Quick Fix)
Use this if you made a mistake and need to delete a resource **immediately** without editing your code files.

**Command:**
```bash
terraform destroy -target aws_instance.my_server
```

*   **What happens:** Terraform finds `aws_instance.my_server` in the state file and destroys it in AWS.
*   **⚠️ THE CATCH:** This command does **NOT** delete the code from your `.tf` file. If you run `terraform apply` again later, Terraform will see the code still exists and **re-create** the server you just deleted.
*   **Fix:** You must manually delete the code block after running this command.

#### Method B: The "Clean Up" (Proper Way)
Use this for permanent changes. This ensures your Code matches your Reality.

**Steps:**
1.  Open your `.tf` file (e.g., `main.tf`).
2.  **Delete** (or comment out `#`) the resource block you want to remove.
3.  Run `terraform apply`.
4.  Terraform will detect: *"Hey, the code is gone, but the server is running. I will delete the server to match the code."*

**Example:**
```hcl
# 1. Comment out the code in main.tf
# resource "aws_instance" "my_server" {
#   ami = "ami-12345"
#   ...
# }
```

```bash
# 2. Run apply
$ terraform apply

# Terraform Plan Output:
# Plan: 0 to add, 0 to change, 1 to destroy.

# 3. Type yes
# aws_instance.my_server: Destroying... [id=i-12345]
# aws_instance.my_server: Destruction complete
```

===

### 4. How to recover from a corrupted state file?    
If your `terraform.tfstate` file is corrupted (e.g., due to a failed apply, manual edit, or disk error), you can recover it using **S3 Versioning**.