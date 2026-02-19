# 
## 📌 Topic: AWS CLI (Command Line Interface)

### Definition
- **AWS CLI** is a unified command-line tool to manage AWS services directly from the terminal.
- Enables **automation, scripting, faster operations**, and **infrastructure control**.
- Commonly used in **DevOps pipelines, EC2 management, S3 operations, IAM automation**.

---
command copy paste from AWS CLI documentation.

## 🧱 Step 1: AWS CLI Installation on EC2 (Ubuntu)

### 1. Launch EC2 Instance
- AMI: **Ubuntu**
- Connect using **SSH**

### 2. Update System & Install Dependencies

```bash
sudo -i
apt update -y
apt install unzip -y
```
3. Install AWS CLI (v2)
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
```
4. Verify Installation
```bash
aws --version
```
✅ Output confirms AWS CLI is installed.


---

🔐 Step 2: AWS CLI Configuration (Two Methods)


---

⚠️ Method A: Insecure Method (Access Keys)

> ❌ Not recommended for EC2 in production
Keys are stored locally and can be leaked.



1. Create Access Key

IAM → Users → Select User

Security Credentials tab

Click Create access key

Save:

Access Key ID

Secret Access Key



2. Configure CLI
```bash
aws configure
```
Enter:

Access Key ID

Secret Access Key

Default region (e.g., us-east-1)

Output format (json or table)


📂 Stored at:

~/.aws/credentials
~/.aws/config


---

✅ Method B: Secure Method (IAM Role) — BEST PRACTICE

> ✔ Recommended for EC2, production, DevOps



Goal

Avoid hardcoding credentials

Use temporary credentials via IAM Role



---

1. Create IAM Role

IAM → Roles → Create role

Trusted entity: AWS Service

Use case: EC2

Permissions: AdministratorAccess (for learning; restrict in prod)

Role name: CLI-Role

Create role



---

2. Attach Role to EC2

EC2 → Select Instance

Actions → Security → Modify IAM Role

Select CLI-Role

Update IAM role



---

3. Verify Role Access
```bash
aws s3 ls
```
✅ Lists S3 buckets → confirms role is working
🔐 No access keys used


---

⚙️ Step 3: AWS CLI Basic Management Commands


---

1. Set Output Format (Optional)

aws configure

Press Enter to skip keys

Set output format: table



---

2. Create IAM User
```bash
aws iam create-user --user-name demo-user
```

---

3. Create IAM Group
```bash
aws iam create-group --group-name devops-group
```

---

4. Add User to Group
```bash
aws iam add-user-to-group \
--user-name demo-user \
--group-name devops-group
```

---

🧾 Step 4: Create & Attach Custom IAM Policy (CLI)


---

1. Create Policy JSON File
```bash
vim policy.json

Example policy (Full S3 access):

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
```

Save & exit:

:wq


---

2. Create Policy Using CLI
```bash
aws iam create-policy \
--policy-name S3FullAccessCustom \
--policy-document file://policy.json
```
📌 Note the Policy ARN from output.


---

3. Attach Policy to User
```bash
aws iam attach-user-policy \
--user-name demo-user \
--policy-arn arn:aws:iam::<account-id>:policy/S3FullAccessCustom
```

---

🪣 Step 5: S3 Management via AWS CLI


---

1. List All Buckets
```bash
aws s3 ls
```
✔ Verifies S3 access and permissions


---

2. Move / Rename Object
```bash
aws s3 mv \
s3://my-bucket/old-file.txt \
s3://my-bucket/new-file.txt
```
📌 Same command works for rename + move


---

3. Delete Object
```bash
aws s3 rm s3://my-bucket/file.txt
```
> ⚠ Objects must be deleted before deleting bucket




---

4. Delete Bucket
```bash
aws s3 rb s3://my-bucket
```
To force delete (bucket + all objects):
```bash
aws s3 rb s3://my-bucket --force
```

---

🧠 Additional Important Notes (Added)

> ✔ IAM Role > Access Keys (Security priority)
✔ AWS CLI uses temporary credentials with roles
✔ CLI is required for automation, scripting, CI/CD
✔ Policies are evaluated with Explicit Deny > Allow
✔ Output formats: json, table, text




---

✅ Summary

AWS CLI = core DevOps skill

Two auth methods:

❌ Access Keys (learning only)

✅ IAM Role (production)


Manage:

IAM users, groups, policies

S3 buckets & objects


Foundation for:

Terraform

CI/CD

Cloud automation




---

📌 Next recommended topics:

AWS CLI + EC2 Automation

AWS CLI + S3 Sync

AWS CLI + CloudWatch


