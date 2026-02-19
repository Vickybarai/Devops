Route 53 with CloudFront (Global Content Delivery)

📌 Overview

This guide explains how to integrate Amazon Route 53 with Amazon CloudFront to serve a static website globally with low latency and HTTPS security.

CloudFront acts as a CDN (Content Delivery Network), while Route 53 handles DNS routing.


---

🎯 Goal

Serve website content faster worldwide

Use AWS-managed HTTPS

Improve performance and security

Enable scalable global access



---

🔁 Architecture Workflow

User Browser
     ↓
Route 53 (DNS)
     ↓
CloudFront (CDN - Global Edge Locations)
     ↓
S3 Bucket (Origin)


---

Part 1: S3 Bucket Setup (Origin)

1. Create S3 Bucket

AWS Console → S3 → Create Bucket

Bucket Name: demo-website-bucket (must be globally unique)

Region: Choose your preferred region

Block Public Access:

Keep enabled if using OAC (Recommended)


Click Create bucket



---

2. Upload Website Content

Upload:

index.html

CSS / JS / Images (if any)




---

3. Enable Static Website Hosting (Optional)

> Required only for direct S3 hosting, not mandatory when using CloudFront + OAC.



S3 → Bucket → Properties

Static website hosting → Enable

Index document: index.html



---

Part 2: Create CloudFront Distribution

1. Start Distribution

AWS Console → CloudFront

Click Create Distribution



---

2. Origin Configuration

Origin Domain Name: Select your S3 bucket

Origin Access:

Choose Origin Access Control (OAC) ✅ (Recommended)


Create new OAC

Restrict bucket access: Yes



---

3. Default Cache Behavior

Viewer Protocol Policy:
Redirect HTTP to HTTPS

Allowed HTTP Methods:
GET, HEAD



---

4. Distribution Settings

Price Class:
Price Class 100 (Cost-effective / Free Tier friendly)

Default Root Object:
index.html


Click Create Distribution


---

Part 3: Allow CloudFront Access to S3 (Bucket Policy)

CloudFront cannot access S3 unless permission is explicitly granted.

1. Copy Policy from CloudFront

CloudFront → Distribution

Look for banner:

> "The S3 bucket policy needs to be updated"



Click Copy Policy



---

2. Apply Policy to S3

S3 → Bucket → Permissions

Scroll to Bucket Policy

Click Edit

Paste the copied policy

Click Save changes


✅ CloudFront can now securely read S3 content.


---

Part 4: Connect Custom Domain Using Route 53

1. Copy CloudFront Domain Name

CloudFront → Distribution

Copy domain:

dxxxxx.cloudfront.net



---

2. Create Alias Record in Route 53

Route 53 → Hosted Zones

Select your domain (e.g., mywebsite.com)

Click Create record


Record Configuration:

Record Name:
(Leave blank for root domain)

Record Type:
A – IPv4 address

Alias:
Yes

Route traffic to:

Alias to CloudFront distribution

Region: us-east-1 (Global)


Select your CloudFront distribution

Click Create records



---

✅ Verification

1. Open browser


2. Paste:

CloudFront URL OR

Your custom domain



3. Website should load:

Over HTTPS

With global low latency





---

🚀 Key Benefits

Global performance via AWS edge locations

Secure access using HTTPS

No public S3 exposure

Highly scalable and production-ready



---

📎 Notes

DNS propagation may take 5–30 minutes

SSL certificate is automatically handled by CloudFront

Best practice: Always use OAC instead of public S3


