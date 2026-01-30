Amazon Machine Images (AMI) – Complete Interview & Documentation Guide

1. Definition & Core Concepts

What is an AMI?

AMI (Amazon Machine Image) is a reusable image that contains everything required to launch an EC2 instance, including:

Operating System (OS)

System configurations

Installed software and packages

Application-level setup


> Think of an AMI as a golden snapshot of an EC2 instance.




---

Purpose of AMI

Acts as a backup of an EC2 instance

Enables fast recovery in case of failure

Allows cloning of identical environments

Supports scaling and automation



---

Important Constraint (Security & Access)

Security Groups (Firewall rules) are NOT copied with an AMI

Key Pairs are NOT embedded inside the AMI

While launching a new instance from an AMI:

You must select or create a Key Pair again

You must attach Security Groups again



> This is a common interview trap – AMI does NOT copy networking or access rules.




---

2. Workflow: Creating an AMI

Step-by-Step Process

1. Go to:

EC2 → Instances


2. Select the running or stopped instance


3. Navigate to:

Actions → Images and templates → Create image



Fill Image Details

Name: my-instance-ami

Description: Optional

Root Volume:

Can increase or modify size


Tags:

Optional (recommended for cost tracking)



> AWS creates a point-in-time snapshot of attached EBS volumes.




---

3. Workflow: Copy AMI to Another Region

Why Copy AMI?

Disaster recovery

Multi-region deployment

Latency optimization

Compliance requirements


Steps

1. Navigate to:

EC2 → AMIs


2. Select the AMI


3. Choose:

Actions → Copy AMI



Configuration

Source Region: Current region

Destination Region: Target region (e.g., us-east-1)

Encryption: Optional (recommended)


Result

Switch to the destination region

The copied AMI will appear and can be used to launch instances



---

4. Workflow: Editing Instance User Data

Key Rule

> User Data can only be edited when the instance is STOPPED



Steps

1. Stop the instance


2. Go to:

Actions → Instance settings → Edit user data


3. Modify the startup script


4. Save and restart the instance




---

5. Method 2 (IMPORTANT): Custom Key Pair Handling with AMI

Why Method 2 is Critical (Interview Focus)

When launching an EC2 instance from an AMI, the original SSH key is NOT reused automatically.

This means:

You must assign a new or existing Key Pair

Otherwise, you will lose SSH access



---

Method 2: Launching AMI with Custom Key Pair

During Launch from AMI:

1. Select AMI


2. Click:

Launch instance from AMI


3. In Key Pair (login) section:

Select Existing key pair

OR Create new key pair



4. Download .pem file securely



> This step restores SSH access to the new instance.




---

Real-World Use Case

AMI copied to another region

Original key pair does NOT exist in that region

You must create a new key pair in the target region



---

Interview Tip

> AMI does not store private keys
SSH access is controlled only at launch time




---

6. Advanced AMI Options

Modifications During Launch

When launching an instance from an AMI, you can:

Change Instance Type

Modify Root Volume size

Add additional EBS volumes

Assign New Security Groups

Attach IAM Role



---

Deregistering (Deleting) an AMI

To delete an AMI:

EC2 → AMIs → Select AMI → Actions → Deregister

⚠️ Note:

Deregistering AMI does NOT delete EBS snapshots automatically

Snapshots must be deleted manually to avoid cost



---

7. Types of AMIs (Based on Storage Backend)

1. Instance Store AMI

Uses ephemeral storage

Data is temporary

Data lost when instance stops or terminates

Faster boot time

Rarely used today



---

2. EBS-Backed AMI (Most Common)

Uses EBS snapshots

Data is persistent

Supports stop/start

Ideal for production workloads



---

8. AMI Catalog Types (Image Sources)

1. Quick Start AMIs

Official AWS images

Examples:

Amazon Linux 2

Ubuntu

Windows Server




---

2. My AMIs

Custom images created by you

Used for backups, scaling, DR



---

3. AWS Marketplace

Vendor-provided AMIs

Paid or subscription-based

Examples:

Firewalls

Databases

Enterprise software


~6,000+ options



---

4. Community AMIs

Free images shared by users

Use with caution

Always verify source



---

9. One-Line Interview Summary

> AMI is a reusable EC2 image used for backup, cloning, and scaling, but it does not include security groups or SSH keys, which must be configured again during launch.


