
Connect a Custom Domain to an EC2 Instance using Route 53 & Third-Party Registrar


---

🔄 Overall Workflow

Domain Registrar (GoDaddy / Hostinger)
            ↓
        AWS Route 53
            ↓
        EC2 Instance
            ↓
          Browser


---

🖥️ Step 1: Create EC2 Instance

1. Go to AWS Console → EC2 → Launch Instance


2. Configure instance:

Name: (Any meaningful name)

AMI / OS: Ubuntu / Amazon Linux

Instance Type: t2.micro / t3.micro (Free tier)

Key Pair: Select or create



3. Network Settings (Edit):

VPC: Default

Subnet: Public Subnet

Auto-assign Public IP: Enable

Security Group:

HTTP (80)

HTTPS (443) (recommended)

SSH (22)




4. Click Launch Instance




---

🌐 Step 2: Install Web Server on EC2

Connect to EC2 using SSH, then run:

sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx


---

📦 (Optional) Deploy Website Files

sudo apt install wget unzip -y
wget <website-zip-link>
unzip themwagon.zip

Clean default directory and move website files:

sudo rm -rf /var/www/html/*
sudo mv themwagon/* /var/www/html/

✅ Verification
Open EC2 Public IP in browser
You should see your website.


---

🌍 Step 3: Create Hosted Zone in Route 53

1. Go to Route 53 → Hosted zones


2. Click Create hosted zone


3. Fill details:

Domain Name: themwagon.com / vickydevops.com

Type: Public hosted zone



4. Click Create



Auto-Created Records

NS (Name Server)

SOA (Start of Authority)



---

🔁 Step 4: Update Nameservers in GoDaddy

1. Login to GoDaddy


2. Go to My Products → Domains → DNS


3. Edit Nameservers


4. Select Enter my own nameservers


5. Copy all 4 NS records from Route 53


6. Paste into GoDaddy NS fields


7. Save changes



⏳ Propagation Time

15 minutes to 1 hour (sometimes up to 24 hours)


🔍 Verification

Use online NS lookup tools to confirm update



---

🧾 Step 5: Create A Record in Route 53

1. Go to Route 53 → Hosted Zone → Create record


2. Configure:

Record Name:

Leave blank → root domain

OR www / vickydevops.shop


Record Type: A – IPv4 address

Alias: No

Value: EC2 Public IP

TTL: Default



3. Click Create record




---

✅ Final Verification

Open browser

Enter:


http://yourdomain.com

🎉 Your custom domain is now pointing to your EC2 instance.


---

⚠️ Common Troubleshooting

Domain not loading?

Check NS propagation

Verify EC2 Public IP hasn’t changed

Ensure port 80 is open


For production:

Use Elastic IP

Enable HTTPS (SSL) using ACM + ALB or Certbot




---

📌 Interview Notes

Route 53 does DNS mapping, not hosting

Nameserver change is mandatory

A record maps domain → IP

Alias record used for AWS services (ALB, S3)


