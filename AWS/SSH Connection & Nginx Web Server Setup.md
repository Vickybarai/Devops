
SSH Connection & Nginx Web Server Setup

This section covers secure SSH access, Nginx web server setup, custom user & key management, and real-world static website deployment on AWS EC2.


---

Part 7: SSH Connection & Nginx Web Server Setup


---

1. SSH Concept

Definition

SSH (Secure Shell) is a cryptographic network protocol that enables a secure, encrypted connection between two computers over an unsecured network.


---

Goal

Securely connect to an EC2 instance

Authenticate using custom SSH key pairs

Avoid password-based access (industry best practice)



---

2. Method 1: Standard Setup Workflow

This is the most common EC2 access method used in labs and real environments.


---

Step 1: Create EC2 Instance

Open AWS Console → Launch Instance

Choose Ubuntu

Create or select an existing key pair (.pem)

Configure Security Group:

Allow Port 22 (SSH)

Allow Port 80 (HTTP)



Security note:

SSH should later be restricted to your IP only



---

Step 2: Connect to the Instance

Using Command Line (Linux / Mac / Git Bash)

ssh -i my-key.pem ubuntu@<public-ip>


---

Using MobaXterm (Windows)

Select SSH

Paste Public IP

Username: ubuntu

Select **key-pair.pem`

Connect



---

Step 3: Install and Start Nginx

sudo apt update -y
sudo apt install nginx -y
sudo systemctl status nginx
sudo systemctl enable nginx

status → verifies service is running

enable → ensures auto-start after reboot



---

Step 4: Create a Custom HTML Page

vim index.html

Add your HTML content

Save and exit


ls
cp -rvf index.html /var/www/html/


---

Verification

Open browser

Visit:


http://<public-ip>

If Nginx is configured correctly, your custom page will load.


---

Part 8: Advanced User & Custom Key Management

(Method 2 – Industry-Style Access Control)

---
Method 2: Advanced User & Custom SSH Key Management

Default users (ubuntu, ec2-user) are not ideal for production

Custom users improve:

Accountability

Security

Access auditing


SSH key-based authentication is mandatory in modern DevOps


Interviewers ask this to test:

Linux permissions

SSH internals

Security maturity



---

Architecture Overview (Conceptual)

EC2 Instance

Custom Linux User (vicky)

Custom SSH Key Pair (User-managed)

SSH Authentication via authorized_keys

Strict permission enforcement



---

Step 1: Switch to Root User

Root access is required to create users and manage system files.

sudo -i


---

Step 2: Create a New User

adduser vicky

Creates:

Home directory: /home/vicky

User entry in /etc/passwd


Sets password (not used for SSH, but required by system)



---

Step 3: Switch to the New User

su - vicky

Loads user environment

Ensures correct home directory context


Verify location:

pwd

Expected output:

/home/vicky


---

Step 4: Generate a Custom SSH Key (Server-Side)

Generate a user-specific key pair.

ssh-keygen

During prompts:

File location:

/home/vicky/vicky-key

Passphrase:

Press Enter (lab)

In production, passphrase is recommended



This creates:

vicky-key → Private Key

vicky-key.pub → Public Key



---

Step 5: Create SSH Configuration Directory

SSH expects keys in a very specific structure.

mkdir .ssh
cd .ssh
touch authorized_keys

Verify:

pwd
ls

Expected:

/home/vicky/.ssh
authorized_keys


---

Step 6: Register the Public Key

Copy the public key into the authorized list.

cp ../vicky-key.pub authorized_keys

Verify contents:

cat authorized_keys

This file tells SSH:

> “This public key is allowed to log in as user vicky.”




---

🔴 Step 7: FIX PERMISSIONS (MOST COMMON FAILURE)

SSH will refuse login if permissions are incorrect.
This is non-negotiable.

Run exactly these commands:

chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys


---

Why These Permissions Are Mandatory

700 .ssh

Only user can read/write/execute


600 authorized_keys

Only user can read/write



If permissions are looser:

SSH assumes compromise

Login is silently blocked



---

🔥 Interview Question (Very Common)

Q:

> “Why does SSH fail even when the key is correct?”



Answer:

> “Because SSH enforces strict permissions. If .ssh or authorized_keys is writable by others, SSH blocks access.”




---

Step 8: Extract the Private Key (Client Use)

Display the private key:

cat ~/vicky-key

Steps on local machine:

Copy full key content

Open Notepad

Paste key

Save file:

Name: vicky-key

File type: All files

No .txt extension



⚠️ Never share this file.


---

Step 9: Connect Using Custom User

Using Command Line

ssh -i vicky-key vicky@<public-ip>


---

Using MobaXterm

Session type: SSH

Remote host: <public-ip>

Username: vicky

Use private key: vicky-key

Connect


Login successful → Custom user access achieved.


---

Security Best Practices (Production Notes)

Disable password-based SSH login

Restrict Port 22 to:

Your IP

Corporate VPN


Rotate keys periodically

One user = one key



---

Why This Method Is Preferred in DevOps

Least-privilege access

User-level accountability

Easier access revocation

Strong audit posture



---

Final Interview Takeaway

If asked:

> “How do you provide secure EC2 access to a team member?”



A strong answer includes:

Create custom Linux user

Generate SSH key

Configure .ssh/authorized_keys

Enforce strict permissions

Restrict SSH at Security Group level



