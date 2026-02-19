
AWS IAM (Identity & Access Management) – Complete Notes & Lab


---

📘 What is IAM?

> IAM (Identity & Access Management) is a global AWS service that controls:

Authentication → Who you are

Authorization → What you are allowed to do




IAM securely manages access to AWS resources without region dependency.


---

🔑 Core IAM Concepts

Term	Meaning

Authentication	Verifying identity (login)
Authorization	Verifying permissions (allowed actions)
Global Service	IAM applies across all AWS regions



---

🧩 Main Four Components of IAM

1️⃣ User

An individual person or service

Has long-term credentials (username/password, access keys)


2️⃣ Group

A collection of IAM users

Permissions are assigned via policies

All users inherit group permissions


3️⃣ Role

An identity with temporary permissions

Can be assumed by:

IAM users

AWS services (EC2, Lambda, etc.)


No password or access keys


4️⃣ Policy

A JSON document

Defines what actions are allowed or denied



---

👤 Steps to Create an IAM User

Step 1: Create User

IAM → Users → Create user

User name: demo

User type: IAM User

Console access: ✅ Enabled

Password: Custom

Click Next



---

Step 2: Set Permissions

Choose ONE of the following:

Option 1: Add user to group (Recommended)

User inherits group permissions


Option 2: Copy permissions

Clone permissions from another user


Option 3: Attach policies directly

Example:

Select AmazonEC2FullAccess


Total AWS permissions: ~1408


Click Next


---

Step 3 & 4: Review & Create

Review → Create user

Download credentials .csv file


> ⚠️ Password is shown only once
Always download the .csv immediately




---

🚫 IAM Limits (Per AWS Account)

Resource	Limit

IAM Users	5,000
IAM Groups	300
IAM Roles	1,000 (per region)
Managed policies per user/role	20
Policies per group	10



---

📜 IAM Policies & ARN


---

📄 Policy Definition

> A policy is a JSON document that defines permissions using:

Effect (Allow / Deny)

Actions

Resources





---

🧠 Types of IAM Policies

Identity-Based Policies

Attached to:

User

Group

Role



AWS Managed Policies

Created & maintained by AWS

Example:

AmazonEC2FullAccess



Custom Policies

Created by you

Granular permissions (Read / Write / Delete)


Inline Policies

Embedded directly into a user/group/role

Deleted automatically when entity is deleted


Permission Boundary (Advanced)

Sets maximum permissions

Acts as a guardrail


Resource-Based Policies

Attached directly to resources

Example:

S3 bucket policy



Session Policies

Temporary policies when assuming a role


Organization Policies (SCP)

Service Control Policies

Used in AWS Organizations


ACL Policies

Legacy permission mechanism



---

🧪 Creating a Policy (Hands-On Lab)


---

Step 1: Create Policy

IAM → Policies → Create policy

Policy editor: Visual

Service: EC2

Effect: Allow / Deny

Actions:

StartInstances

TerminateInstances


Resources:

All resources


Next

Policy Name: my-policy

Create



---

Step 2: Attach Policy

IAM → Policies → my-policy → Actions → Attach

Select User: demo

Attach policy



---

🔍 Verification Scenario (Important)

Scenario:

User has EC2 Full Access

Custom policy DENIES:

Start EC2

Terminate EC2



Result:

> ❌ User cannot start or terminate EC2
✅ Other EC2 permissions still work



Rule:

DENY always overrides ALLOW


---

🎯 Ways to Grant Permission to a Single User

1. Attach managed policy (most common)


2. Attach custom policy


3. Create inline policy




---

🧷 Inline Policies (Deep Dive)

What is an Inline Policy?

A custom policy embedded directly into a user

Not reusable

User-specific


Key Characteristics

Feature	Inline Policy

Scope	Single user/group/role
Reusable	❌ No
Auto-deleted	✅ Yes
Visibility	Only for attached entity



---

🆔 ARN (Amazon Resource Name)

> ARN uniquely identifies every AWS resource



ARN Format

arn:aws:{service}:{region}:{account-id}:{resource}

Example

arn:aws:s3:::my-bucket/my-folder/my-file.txt


---

🎭 IAM Roles (Important Interview Topic)

What is a Role?

A temporary identity

Used by:

EC2

Lambda

Users


No password

Uses temporary credentials


Example Use Case

> EC2 instance needs to upload files to S3
✅ Use IAM Role
❌ Do NOT store access keys on instance




---

🚧 Permission Boundaries

Definition

> A permission boundary sets the maximum permissions an IAM user or role can ever have.



Why It Matters

Acts as a security guardrail

Prevents privilege escalation

Even admins cannot exceed it



---

🧠 Interview Takeaways

IAM is global

Policies are JSON-based

Roles = temporary access

Inline policies are non-reusable

Deny > Allow (always)

Permission boundaries = maximum limit



