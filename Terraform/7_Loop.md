# 🔄 Day 7: Terraform Loops 

**The Problem:** Imagine you need to create **5 identical EC2 instances**. Without loops, you have to copy-paste the `resource "aws_instance"` block 5 times. That is messy and hard to manage.

**The Solution:** Use Loops. "Don't Repeat Yourself" (DRY).

---

### 1️⃣ The `count` Loop (The "Clone Machine")
**Concept:** Use this when you want to create multiple resources that are **identical** (same size, same AMI, same settings). You just want "X amount of them."

**How it works:**
*   You add `count = 3` inside the resource block.
*   Terraform clones the block 3 times.
*   You can use `count.index` (0, 1, 2) to give them unique names or numbers.

**Code Example:**
```hcl
resource "aws_instance" "server" {
  count         = 3  # Create 3 copies
  ami           = "ami-abc123"
  instance_type = "t2.micro"

  # Using count.index to make names unique:
  # server-0, server-1, server-2
  tags = {
    Name = "server-${count.index}"
  }
}
```
*   **Lecture Note:** The instructor called this creating "multiple resources with the same configuration."

---

### 2️⃣ The `for_each` Loop (The "Customizer")
**Concept:** Use this when you want to create multiple resources that are **different** from each other (e.g., different names, different sizes).

**How it works:**
*   You give Terraform a list or a map (e.g., `["web", "db", "app"]`).
*   Terraform loops through the list and creates one resource for each item.
*   You use `each.value` to access the current item (like "web" or "db").

**Code Example:**
```hcl
# A list of names we want
variable "instance_names" {
  type    = list(string)
  default = ["web-server", "db-server", "app-server"]
}

resource "aws_instance" "server" {
  # Loop through the list
  for_each = toset(var.instance_names) 
  
  ami           = "ami-abc123"
  instance_type = "t2.micro"

  # Use each.value to set the name dynamically
  tags = {
    Name = each.value 
  }
}
```
*   **Lecture Note:** The instructor explained this as "creating resources for different configurations." Even though the AMI is the same here, the *Name* is different, which makes `for_each` the correct choice over `count`.

---

### 3️⃣ The `for` Loop (The "Printer")
**Concept:** This is **not** used to create resources. It is used inside **Outputs** or **Variables** to transform or filter data.

**How it works:**
*   It takes a list, changes it, and spits out a new list.
*   **Common Use Case:** You have 5 servers, and you want to print a list of just their **Public IP addresses**.

**Code Example:**
```hcl
output "all_private_ips" {
  # Loop through instances, but only grab the private_ip
  value = [for s in aws_instance.server : s.private_ip]
}

# You can also add conditions:
# "Give me IPs of ONLY t2.micro instances"
output "micro_ips" {
  value = [for s in aws_instance.server : s.private_ip if s.instance_type == "t2.micro"]
}
```
*   **Lecture Note:** The instructor specifically mentioned this is used "mainly in the output block to print multiple attributes together."

---

### 📝 Summary Table

| Loop Type | Used For | Key Variable | Example Use Case |
| :--- | :--- | :--- | :--- |
| **count** | Creating **identical** resources. | `count.index` | Creating 3 exactly same web servers. |
| **for_each** | Creating **distinct** resources. | `each.key`, `each.value` | Creating servers named "Web", "DB", "App". |
| **for** | **Transforming/Filtering** data. | `item` | Listing all IP addresses of created servers. |

---

### 🧹 Recap: Managing Resources (From Lecture Notes)

The lecture also briefly reviewed how to handle resources when loops create too many or the wrong ones:

1.  **Deleting Specific Resources:**
    *   **Sniper Shot:** `terraform destroy -target <resource_name>` (Use for quick fixes).
    *   **Clean Up:** Delete the code block and run `terraform apply` (The proper way).

2.  **State Recovery (The "Time Machine"):**
    *   If your state file gets corrupted, you can use **S3 Versioning** (enabled in Day 4) to "rollback" to a previous version of the state file. It acts like an Undo button.