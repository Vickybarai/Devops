

SSL/TLS Setup on AWS

Enable HTTPS for Custom Domain using Route 53, ACM & Application Load Balancer (ALB)


---

📌 Topic Overview

This guide explains how to secure a custom domain with HTTPS (SSL/TLS) on AWS using managed, best-practice services.

AWS handles:

Certificate issuance & renewal (ACM)

SSL termination (ALB)

DNS routing (Route 53)


You focus only on application logic.


---

🔄 Architecture Workflow

Custom Domain (Route 53)
        ↓
AWS Certificate Manager (SSL/TLS)
        ↓
Application Load Balancer (HTTPS : 443)
        ↓
Target Group
        ↓
EC2 Instance (Nginx / App)
        ↓
Browser (Secure HTTPS)


---

🧩 Part 1: Launch & Configure EC2 Instance

🎯 Goal

Run a web server that will receive traffic only from the Load Balancer.


---

1️⃣ Launch EC2

Name: web-server

AMI: Ubuntu

Instance Type: t2.micro / t3.micro

Key Pair: Select existing or create new


Network & Security Group

Auto-assign Public IP: Enable

Inbound Rules:

SSH (22) → Your IP

HTTP (80) → 0.0.0.0/0

HTTPS (443) → 0.0.0.0/0




---

2️⃣ Install Web Server & Deploy Website

Connect to EC2 and run:

sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

Deploy Sample Website

sudo apt install wget unzip -y
wget <link_to_zip_file>
unzip themwagon.zip

Move files to web root:

sudo rm -rf /var/www/html/*
sudo mv themwagon/* /var/www/html/

✅ Verify using EC2 Public IP


---

🌍 Part 2: Domain & Route 53 (Pre-check)

Prerequisites

Domain already registered (GoDaddy / Hostinger)

Nameservers updated to Route 53 NS records


⚠️
You may already have an A record pointing to EC2 —
this will be replaced later with ALB Alias record.


---

🔐 Part 3: Request & Validate SSL Certificate (ACM)

🎯 Goal

Obtain a free public SSL certificate.


---

1️⃣ Request Certificate

Go to AWS Certificate Manager

Click Request certificate

Choose Public certificate


Domain Names

mywebsitedemo.com
*.mywebsitedemo.com

Validation Method: DNS validation

Click Request



---

2️⃣ DNS Validation

Open the pending certificate

Click Create records in Route 53

Confirm → Create records


⏳ Wait 5–20 minutes

✅ Status becomes: Issued


---

⚖️ Part 4: Create Application Load Balancer (ALB)

🎯 Goal

ALB handles SSL termination and forwards traffic securely.


---

1️⃣ Create Target Group

Type: Instances

Protocol: HTTP

Port: 80

Name: tg-ubuntu


Register target:

Select EC2 instance

Click Include as pending

Create Target Group



---

2️⃣ Create Load Balancer

Type: Application Load Balancer

Scheme: Internet-facing

IP type: IPv4

Network:

Select VPC

Select minimum 2 AZs



Security Group

Allow HTTP (80) & HTTPS (443)



---

Listeners Configuration

Listener 1

HTTP : 80

(Temporary – will redirect later)


Listener 2

HTTPS : 443

Default action → Forward to tg-ubuntu

SSL Certificate → Select ACM certificate


Create Load Balancer ✅


---

🔁 Part 5: Redirect HTTP → HTTPS

🎯 Goal

Force secure traffic only.


---

1. Go to EC2 → Load Balancers


2. Select ALB → Listeners


3. Edit HTTP : 80 listener



Update Rule

Remove forward action

Add Redirect

Protocol: HTTPS

Port: 443

Host / Path / Query: Preserve

Status Code: 301 (Permanent)



Save changes ✅


---

🌐 Part 6: Update Route 53 (Alias Record)

🎯 Goal

Point domain to ALB instead of EC2 IP


---

1. Route 53 → Hosted Zones


2. Select domain


3. Create / Edit record



Record Configuration

Record Name: (blank – root domain)

Record Type: A

Alias: Yes

Route traffic to:

Application Load Balancer

Select Region

Select ALB



Create record ✅


---

✅ Part 7: Final Verification

Test in Browser

http://yourdomain.com

Expected Result

Auto-redirects to:


https://yourdomain.com

🔒 Padlock icon visible

SSL Certificate issued by Amazon



---

🧠 Key Interview Points

ACM certificates are free

ACM works only with ALB, NLB, CloudFront

SSL termination happens at Load Balancer

Route 53 Alias records are AWS-native (no IPs)

HTTP → HTTPS redirect improves security & SEO



---

🚀 Production Best Practices

Remove EC2 public IP access

Allow EC2 inbound traffic only from ALB SG

Enable ALB access logs

Add WAF for security

Use Auto Scaling Group



