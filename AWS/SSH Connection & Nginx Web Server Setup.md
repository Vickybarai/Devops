
SSH Connection & Nginx Web Server Setup

(Hands-on + Interview-Ready Guide)

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

This approach reflects real DevOps practices, where root or default users are avoided.


---

Step 1: Create a New User

sudo -i
adduser vicky
cd .ssh/
ls

Checks for existing authorized_keys


su - vicky

Switch to the new user



---

Step 2: Generate a Custom SSH Key

ssh-keygen

Cryptographic algorithm selected automatically

Location:


/home/vicky/vicky-key

Passphrase: press Enter for none (lab usage)



---

Step 3: Configure SSH Directory and Keys

mkdir .ssh
cd .ssh
touch authorized_keys
pwd

Copy the public key into authorized_keys:

cp ../vicky-key.pub authorized_keys
cat authorized_keys


---

Extract the Private Key (Client Side)

cat vicky-key

Copy full key content

Paste into Notepad on your local PC

Save as file

File type: All files

Example name: vicky-key




---

🔴 Critical Fix: SSH Permission Requirements (MUST DO)

SSH will reject connections silently if permissions are wrong.

Run these commands without fail:

chmod 700 .ssh
chmod 600 .ssh/authorized_keys

Why this matters (Interview Gold)

SSH refuses access if:

.ssh is writable by others

authorized_keys has loose permissions



---

Step 4: Connect Using Custom User

Use MobaXterm

Username: vicky

Select private key: vicky-key

Connect → Login successful



---

Part 9: Deploying a Theme (Project Workflow)

Objective

Deploy a static website template from Themewagon.com using Nginx.


---

1. Preparation

Copy theme download link from Themewagon

Connect via SSH:


ssh -i vicky-key vicky@<public-ip>

(or use MobaXterm)


---

2. Install Required Packages

sudo apt update -y
sudo apt install nginx -y


---

3. Deployment Steps

Navigate to Web Root

cd /var/www/html/


---

Remove Default Files

sudo rm -rvf *


---

Download Theme

wget <theme-link>


---

🔴 Critical Fix: ZIP Extraction (Hidden Failure)

Themewagon downloads ZIP files, not raw HTML.

You MUST extract it.

sudo apt install unzip -y
unzip <downloaded-file.zip>


---

Copy Extracted Files

cp -rvf <extracted-folder>/* /var/www/html/


---

Restart and Enable Nginx

sudo systemctl restart nginx
sudo systemctl enable nginx


---

4. Final Verification

Open browser

Paste:


http://<public-ip>

Your theme should now load successfully.


---

🥊 Sparring Partner Analysis (Why Deployments Fail)


---

1. The chmod Trap (Very Common Interview Question)

Symptom

SSH key is correct

Connection still fails


Root Cause

Incorrect permissions on:

.ssh

authorized_keys



Correct Answer (Interview)

> “SSH is permission-sensitive. If the .ssh directory or authorized_keys file has insecure permissions, SSH blocks the login.”




---

2. The wget vs unzip Reality

Symptom

Website does not load

Browser downloads a ZIP file instead


Root Cause

ZIP file copied directly to web root

No extraction done


Correct Fix

Install unzip

Extract files

Copy extracted HTML assets



---
