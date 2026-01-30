Amazon RDS (Relational Database Service) – Complete Guide & Mini Project


---

📌 Topic Identification

Primary Topic:

> Amazon RDS (Relational Database Service)



Sub-Topics Covered:

RDS Core Concepts

SQL vs NoSQL Comparison

Backup, Recovery & Scaling

High Availability (Multi-AZ)

Read Replicas

Networking & Security

End-to-End Mini Project (Java + Tomcat + RDS + S3)



---

1️⃣ What is Amazon RDS?

Amazon RDS is a fully managed relational database service provided by AWS that simplifies database deployment, operations, scaling, backup, and maintenance.

Why RDS Exists

If you host a database on EC2, you are responsible for:

OS patching

DB installation

Backups

Failover

Monitoring

Scaling


👉 RDS offloads all operational overhead to AWS, allowing teams to focus on application development.


---

2️⃣ Supported Database Engines

Engine	Description

Amazon Aurora	AWS-built, MySQL/PostgreSQL compatible, high performance
MySQL	Popular open-source relational DB
PostgreSQL	Advanced open-source relational DB
MariaDB	MySQL fork with performance improvements
Oracle	Enterprise-grade commercial DB
SQL Server	Microsoft enterprise relational DB



---

3️⃣ Key Advantages of Amazon RDS

✅ Fully Managed

OS patching handled by AWS

Database engine updates automated


✅ Automated Backups

Daily snapshots

Transaction logs stored continuously

Point-in-Time Recovery (PITR) up to 35 days


✅ High Availability

Multi-AZ deployment

Automatic failover during outages


✅ Scalability

Vertical scaling (instance size)

Horizontal scaling (Read Replicas)


✅ Security

IAM integration

Security Groups

Encryption at rest & in transit



---

4️⃣ SQL vs NoSQL (Interview-Critical)

Feature	SQL (Relational)	NoSQL (Non-Relational)

Data Model	Tables, rows, schema	Key-value, document, graph
Schema	Fixed	Flexible
Scaling	Vertical	Horizontal
Transactions	ACID compliant	BASE (eventual consistency)
Examples	RDS, Aurora	DynamoDB, DocumentDB
Best Use	Banking, ERP, Inventory	High traffic, flexible apps



---

5️⃣ Backup, Recovery & Scaling in RDS

🔹 Automated Backups

Enabled by default

Daily snapshot + transaction logs

Restore to any second within retention period


🔹 Manual Snapshots

User-initiated

Stored indefinitely

Used for long-term backup & migration



---

6️⃣ Read Replicas (Scaling Reads)

Purpose:

> Improve read performance and offload read traffic.



Key Points:

Read-only copies of primary DB

Asynchronous replication

Used for analytics, reporting, dashboards


Primary DB  --->  Read Replica (Async)


---

7️⃣ Multi-AZ Deployment (High Availability)

Purpose:

> Disaster Recovery & Fault Tolerance



How it works:

Primary DB in AZ-A

Standby DB in AZ-B

Synchronous replication

Automatic failover


AZ-A (Primary)  <==== Sync ====>  AZ-B (Standby)

✔ Zero application change during failover
❌ Standby cannot be used for reads


---

8️⃣ Networking & Security Best Practices

🔐 Security Groups

Databases should live in Private Subnets

No public internet access


Engine	Port

MySQL / MariaDB	3306
PostgreSQL	5432


Best Practice:
Allow inbound traffic only from EC2 Security Group, not 0.0.0.0/0.


---

🌐 DB Subnet Group

Logical grouping of minimum 2 subnets

Each subnet must be in different AZ

Required for Multi-AZ deployments



---

9️⃣ Mini Project – Java Application with RDS

🧩 Architecture Overview

User
 ↓
EC2 (Tomcat + Java App)
 ↓
Amazon RDS (MariaDB)
 ↑
Artifacts from S3


---

🔟 Step-by-Step Implementation


---

Step 1: Create RDS Database

Console Path:

RDS → Databases → Create Database

Configuration:

Creation Method: Standard

Engine: MariaDB / MySQL

Template: Free Tier

DB Identifier: studentdb

Master Username: admin

Password: admin1234



---

Step 2: Create EC2 Instance

AMI: Amazon Linux

Instance Type: t2.micro / t3.micro

Security Group:

TCP 8080 (Tomcat)

SSH (My IP)

MySQL 3306 (from same SG)




---

Step 3: Create S3 Bucket

Disable Block Public Access

Upload:

student.war

mysql-connector.jar


Copy object URLs



---

Step 4: Configure EC2 Instance

sudo -i
dnf update -y
dnf install java-1.8.0 -y
dnf install mariadb105-server -y
systemctl start mariadb
systemctl enable mariadb


---

Step 5: Install Apache Tomcat

wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.86/bin/apache-tomcat-9.0.86.tar.gz
tar -xzvf apache-tomcat-9.0.86.tar.gz


---

Step 6: Download Application Artifacts from S3

wget <student.war-url> -P apache-tomcat-9.0.86/webapps/
wget <mysql-connector-url> -P apache-tomcat-9.0.86/lib/


---

Step 7: Configure Database Connection

cd apache-tomcat-9.0.86/conf
vim context.xml

<Resource name="jdbc/studentdb"
          auth="Container"
          type="javax.sql.DataSource"
          username="admin"
          password="admin1234"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://<RDS-ENDPOINT>:3306/studentdb"/>


---

Step 8: Start Tomcat Server

cd apache-tomcat-9.0.86/bin
./catalina.sh start


---

Step 9: Verify Application

http://<EC2-PUBLIC-IP>:8080/student


---

Step 10: Verify Database Connection

mysql -u admin -h <RDS-ENDPOINT> -p
show tables;
desc students;


---

🔚 Final Notes (Interview Gold)

RDS ≠ Serverless DB (Aurora Serverless is)

Multi-AZ = Availability, not scaling

Read Replica = Scaling reads, not writes

RDS cannot be SSH’d into

Always use Private Subnets for DB


