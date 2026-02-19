#  S3 Static Website Hosting

S3 can host **static websites** (HTML, CSS, JS) without any server.

---

## Step 1: Create Bucket

- AWS Console → **S3** → **Buckets** → **Create bucket**
- **Bucket name**: `my-demo-website`  
  > ⚠️ Must be **globally unique**
- **Region**: Choose any (closer to users = better latency)
- **Object Ownership**:  
  - Select **ACLs enabled**
- **Block Public Access**:
  - ❌ Uncheck **Block all public access**
  - ✅ Check acknowledgment:
    > *I acknowledge that the current settings might result in this bucket becoming public*
- **Bucket Versioning**: Disabled (default)
- **Tags**: Optional
- **Default Encryption**: Disabled (default)
- Click **Create bucket**

---

## Step 2: Upload Website Files

- Open bucket → **Upload**
- Click **Add files / Add folder**
  - Upload `index.html` (mandatory)
  - Optional: `error.html`, CSS, JS
- Go to **Permissions tab**:
  - Manage public permissions
  - ✅ Grant **public read access**
- **Properties tab**:
  - Storage class → **Standard**
- Click **Upload**

> 🔎 This step makes **objects public**, not the bucket.

---

## Step 3: Enable Static Website Hosting

- Bucket → **Properties**
- Scroll to **Static website hosting** → **Edit**
- Select **Enable**
- Hosting type: **Host a static website**
- **Index document**: `index.html`
- (Optional) **Error document**: `error.html`
- Click **Save changes**

---

## Step 4: Grant Public Access (Bucket Level)

- Bucket → **Permissions**
- **Object Ownership** → Edit
  - Select **ACLs enabled**
  - Acknowledge warning → Save
- Scroll to **Access Control List (ACL)**
  - Click **Edit**
  - Under **Everyone (public access)**:
    - ✅ List
    - ✅ Read objects
  - Acknowledge warning → Save

> 🔐 This allows **public users** to list and read objects.

---

## Step 5: Access Website

- Bucket → **Properties**
- Scroll to **Static website hosting**
- Copy **Bucket website endpoint**
- Paste URL in browser

✅ Website is live

---

## Step 6: Cleanup (Static Website)

- Bucket → Objects → Select all → **Delete**
- Bucket → **Delete**

---

---

## 📌 Topic 2: S3 Bucket Versioning

Versioning protects against **accidental delete & overwrite**.

---

## Step 1: Enable Versioning

- S3 → Select Bucket → **Properties**
- **Bucket Versioning** → Edit
- Select **Enable**
- Save changes

---

## Step 2: Upload Multiple Versions

1. Create file: `demo-version.txt`
   ```text
   version 1

2. Upload file to bucket


3. Modify file:

version 2

Upload again


4. Modify file:

version 3

Upload again




---

Step 3: View & Delete Versions

Bucket → Objects

Toggle Show versions → ON

Each upload has:

Unique Version ID


Delete behavior:

Deleting current version → creates Delete Marker

Older version becomes recoverable


To permanently delete:

Select specific Version ID → Delete



> ⭐ Versioning = data safety + audit trail




---


---

📌 Topic 3: S3 Cross-Region Replication (CRR)

CRR automatically replicates objects to another region.


---

🔑 Prerequisites

Versioning must be enabled

Source & Destination buckets:

Must be in different regions


Proper IAM role required (auto-created by AWS)



---

Step 1: Source Bucket Setup

Use existing bucket or create new

Enable Versioning

Upload files (preferably multiple versions)



---

Step 2: Destination Bucket Setup

S3 → Create bucket

Bucket name: my-destination-buck-123

Region: Different from source
(Example: Source = us-east-1, Destination = us-west-2)

Enable Versioning

Create bucket



---

Step 3: Create Replication Rule

Source bucket → Management

Scroll to Replication rules → Create rule


Rule Configuration

Rule name: demo-rule

Status: Enabled


Scope

Apply to all objects

OR limit using prefix/tags



Destination

Choose bucket in this account

Select destination bucket


IAM Role

Select Create new role

AWS creates: s3crr_role_for_...



Advanced Options (Optional)

Change storage class (e.g., One Zone-IA)

Replication Time Control (RTC)

Delete marker replication


Existing Objects

Select Yes (important)

Save rule



---

Step 4: Batch Operations (Existing Objects)

> CRR works only for new objects by default
Batch Operations handle old/existing objects



Redirected to Batch Operations

Create Job:

Source: Inventory / CSV

Operation: Replicate

IAM Role: Replication role

Priority: 10


Create Job



---

Step 5: Verification

Monitor Batch Job:

Status: Running → Complete


Destination bucket → Objects

Verify files & versions


Upload new file to source

Check destination → auto-replicated




---

Step 6: Cleanup (CRR)

Delete replication rules

Empty destination bucket → Delete

Empty source bucket → Delete



---


---

🧠 Key Exam + Interview Notes (Added)

> Deny > Allow always wins
Versioning is mandatory for CRR
S3 Static Website does NOT support HTTPS directly (use CloudFront)
Delete marker ≠ permanent delete
Batch Operations = large-scale object management




