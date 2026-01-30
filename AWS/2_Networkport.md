1. Remote Access & Management

These ports provide direct administrative access to servers and must be treated as high-risk entry points.


---

Port 22 (TCP) – SSH (Secure Shell)

Usage

Secure remote access to Linux servers

Primary method to manage EC2 Linux instances


DevOps Security Note

Never open Port 22 to 0.0.0.0/0 in production

Always restrict access to:

Your IP address

Corporate VPN IP range


Use key-based authentication only




---

Port 3389 (TCP) – RDP (Remote Desktop Protocol)

Usage

Remote desktop access for Windows servers

Commonly used for Windows EC2 instances


Security Note

Should be IP-restricted similar to SSH

Often targeted in brute-force attacks




---

Port 23 (TCP) – Telnet

Usage

Legacy remote terminal access


DevOps Reality

Data is transmitted in plain text

Rarely used today

Fully replaced by SSH in modern environments




---

2. Web Traffic & Application Delivery

These ports are essential for delivering web applications to end users.


---

Port 80 (TCP) – HTTP

Usage

Standard web traffic

Used by web servers such as Apache and Nginx


Note

Unencrypted

Often redirected to HTTPS in production




---

Port 443 (TCP) – HTTPS

Usage

Secure web traffic using SSL/TLS


DevOps Best Practice

Always prefer HTTPS in production

Required for compliance and security standards




---

Port 8080 (TCP) – HTTP Alternate / Proxy

Usage

Common for:

Jenkins

Apache Tomcat

Proxy services



Interview Tip

Frequently appears in DevOps toolchains




---

Port 8443 (TCP) – Alternate HTTPS

Usage

Secure alternative HTTPS port

Often used for admin consoles and dashboards




---

3. Application Development

(Local & Dev Environments)

These ports are common in development and CI/CD workflows.


---

Port 3000 (TCP) – Node.js / React

Usage

Default development port for JavaScript frameworks

React, Node.js, Express




---

Port 5000 (TCP) – Flask / Python

Usage

Default Flask development server port

Common in Python-based microservices




---

Port 8000 (TCP) – HTTP Development

Usage

Frequently used by:

Django

Simple Python HTTP servers





---

Port 9000 (TCP) – App Admin / SonarQube

Usage

Management and admin portals

Examples:

SonarQube

Portainer

PHP-FPM





---

4. Databases

(Managed & Self-Hosted)

Database ports are never meant to be public.


---

Port 3306 (TCP) – MySQL / MariaDB / Aurora

Usage

Standard MySQL-compatible database access


AWS Context

Amazon RDS MySQL

Amazon Aurora MySQL




---

Port 5432 (TCP) – PostgreSQL

Usage

PostgreSQL database connections


AWS Context

Amazon RDS PostgreSQL

Amazon Aurora PostgreSQL




---

Port 1433 (TCP) – Microsoft SQL Server

Usage

SQL Server (TDS protocol)




---

Port 27017 (TCP) – MongoDB / DocumentDB

Usage

NoSQL document database connections


AWS Context

Amazon DocumentDB (MongoDB compatible)




---

Port 6379 (TCP) – Redis / ElastiCache

Usage

In-memory caching

Message brokering


AWS Context

Amazon ElastiCache (Redis)




---

5. Infrastructure Services

(Networking & File Storage)

These ports enable core infrastructure functionality.


---

Port 53 (TCP/UDP) – DNS

Usage

Domain name resolution


AWS Context

Amazon Route 53

VPC internal DNS




---

Port 2049 (TCP/UDP) – NFS

Usage

Network File System


AWS Context

Amazon EFS mounting




---

Port 445 (TCP) – SMB / CIFS

Usage

Windows file sharing


AWS Context

Amazon FSx for Windows

Samba




---

Port 20, 21 (TCP) – FTP

Usage

File transfers


DevOps Reality

Considered legacy

Often replaced by SFTP or SCP




---

6. Email Services

Email-related ports still appear in interviews for basic networking validation.


---

Port 25 (TCP) – SMTP

Usage

Email sending


AWS Context

Amazon SES (often restricted on EC2)




---

Port 110 (TCP) – POP3

Usage

Email retrieval




---

Port 143 (TCP) – IMAP

Usage

Email access and synchronization




---

🥊 Sparring Partner Analysis (Interview Traps)

This section is where interviewers separate theoretical learners from production engineers.


---

Trap 1: The Ephemeral Port Question

Scenario

You allowed inbound Port 80 in your Network ACL

Users still cannot access the website


Why This Happens

Incoming request enters on Port 80

Server response does not return on Port 80

The response goes back on a random Ephemeral Port


Ephemeral Port Range

Typically: 1024 – 65535


The Fix

In Network ACLs (stateless):

You must explicitly allow:

Inbound Port 80

Outbound Ephemeral Ports



In Security Groups (stateful):

Return traffic is automatically allowed



DevOps Rule

NACLs require explicit inbound and outbound rules

Security Groups automatically allow return traffic



---

Trap 2: Securing Port 22 (SSH)

Common Weak Answer

“I use a key pair.”


Interview-Grade Answer

“I restrict Port 22 in the Security Group to My IP only or a corporate VPN IP.”

“I never expose SSH to 0.0.0.0/0.”

“Key-based authentication is mandatory.”


This shows security ownership, not just knowledge.


---
