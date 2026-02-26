
# 🛠️ Day 8 : Provisioners

This session covers advanced operations that happen **after** a resource is created, and how to bring existing manual infrastructure under Terraform control.

---

## Part 1: Terraform Provisioners
**The Concept:**
By default, Terraform's job is to *create* the resource (like an EC2 instance). However, often we need to do things *inside* or *because of* that resource immediately after it's created (e.g., installing software, copying files).

**Provisioners** are special blocks inside a `resource` that allow you to execute scripts or commands on **either** the local machine or the remote resource.

### The 3 Types of Provisioners

#### 1. `local-exec` (The Local Machine)
*   **Concept:** Runs commands on the machine where you are running Terraform (your laptop or CI runner).
*   **Use Case:** Creating a local inventory file, generating a key pair, or running a local script that interacts with the cloud API.
*   **Example:**
    ```hcl
    provisioner "local-exec" {
      command = "echo ${aws_instance.web.public_ip} >> ips.txt"
    }
    ```

#### 2. `remote-exec` (The Remote Server)
*   **Concept:** Connects to the remote resource (via SSH) and runs commands inside it.
*   **Use Case:** Installing software (Apache, Nginx), starting services, or running configuration scripts.
*   **Requirement:** You must define a `connection` block so Terraform knows how to SSH in.
*   **Example:**
    ```hcl
    provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "sudo yum install httpd -y",
        "sudo systemctl start httpd"
      ]
    }
    ```

#### 3. `file` (The Courier)
*   **Concept:** Copies files or directories from your local machine to the remote resource.
*   **Use Case:** Uploading a configuration file (e.g., `index.html` or `nginx.conf`) to the server.
*   **Example:**
    ```hcl
    provisioner "file" {
      source      = "index.html"
      destination = "/var/www/html/index.html"
    }
    ```

---

### The "Connection" Block (Crucial)

For `remote-exec` and `file` provisioners to work, Terraform needs to know **how** to log in to the server. This is done via the `connection` block.

You can define this `connection` block inside the specific provisioner, or globally for the whole resource (as seen in the lecture).

**Global Connection (Recommended in Lecture):**
```hcl
resource "aws_instance" "web" {
  # ... instance config ...

  # Defined once, used by all provisioners below
  connection {
    type        = "ssh"
    user        = "ec2-user"      # Default user for Amazon Linux
    host        = self.public_ip # Refers to this instance's IP
    private_key = file("my-key.pem") # Reads the CONTENT of the key file
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/index.html /var/www/html/index.html"
    ]
  }
}
```

**Key Technical Detail (from lecture):**
The `private_key` argument requires the **content** of the key, not just the file path. We use the `file()` function to read the content.
*   ❌ Wrong: `private_key = "my-key.pem"`
*   ✅ Right: `private_key = file("my-key.pem")`

---

