AWS IAM – Permission Boundaries


---

📌 Topic

Permission Boundary in AWS IAM


---

📖 Definition

A Permission Boundary is an advanced IAM feature that sets the maximum permissions an IAM user or role can have, even if they are assigned powerful policies like AdministratorAccess.

> 👉 Effective permissions = IAM Policy ∩ Permission Boundary




---

🎯 Why Permission Boundaries Are Used

Restrict admin users safely

Delegate IAM user creation without full privileges

Enforce least-privilege security model

Prevent privilege escalation



---

🧠 Key Characteristics

Permission boundaries do not grant permissions

They only limit what permissions can be used

Works with:

IAM Users

IAM Roles


Common in enterprise & multi-team environments



---

🪜 Step-by-Step Implementation


---

Step 1: Create a New IAM User

Console Path

AWS Console → IAM → Users → Create user

Configuration

User name: pb-admin-user

Access type: AWS Management Console

Password: Custom password

Permissions:

Select Attach policies directly

Attach AdministratorAccess


Tags: Optional

Click Create user



---

Step 2: Apply Permission Boundary

Console Path

IAM → Users → pb-admin-user → Permissions

Actions

Click Set permissions boundary

Choose Use a managed policy

Search & select: AmazonEC2FullAccess

Click Set permission boundary



---

🔒 Permission Boundary Applied

Boundary Policy: AmazonEC2FullAccess

This means:

User can perform only EC2-related actions

All other services are implicitly blocked



---

Step 3: Login as the IAM User

Console Path

IAM Dashboard → Sign-in URL

Open the IAM Sign-in URL

Login using:

Username: pb-admin-user

Password: (set earlier)




---

Step 4: Verify Effective Permissions

✅ Allowed Actions

Launch EC2 instances

Manage EC2 resources


✔ Reason: EC2 actions are allowed by the permission boundary


---

❌ Blocked Actions

Access S3

Create IAM users

Create RDS databases


❌ Reason: These services are outside the boundary, even though the user has AdministratorAccess


---

🔍 Permission Evaluation Flow

IAM Policy (AdministratorAccess)
          ∩
Permission Boundary (EC2 Only)
          ↓
Final Permissions = EC2 Only


---

🧪 Real-World Use Case

Cloud Admin creates IAM users for DevOps team

Developers need EC2 access

Admin prevents access to:

IAM

Billing

S3

RDS



➡ Permission Boundary enforces this safely


---

⚠️ Common Mistakes

Assuming permission boundary grants access ❌

Forgetting to attach IAM policy ❌

Applying boundary but testing with root user ❌



---

🎯 Interview Key Points

Permission Boundary ≠ IAM Policy

Boundary limits maximum permissions

Used to restrict powerful users

AdministratorAccess can still be restricted

Mostly used in large organizations

