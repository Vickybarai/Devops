Amazon RDS (Relational Database Service)


---

📌 Topic

Amazon RDS (Relational Database Service)


---

📖 Definition

Amazon RDS is a fully managed relational database service that allows you to create, operate, scale, and maintain relational databases without managing underlying infrastructure such as OS patching, backups, or failover.


---

🗄️ Supported Database Engines

Amazon Aurora

MySQL

PostgreSQL

MariaDB

Oracle

SQL Server



---

✅ Key Advantages of RDS

Automated OS & DB patching

Automated backups with Point-in-Time Recovery

Multi-AZ high availability

Vertical & horizontal scalability

Integrated security (IAM, Security Groups, Encryption)



---

🔄 SQL vs NoSQL Comparison

Feature	SQL (Relational)	NoSQL (Non-Relational)

Schema	Fixed	Flexible
Scaling	Vertical	Horizontal
Consistency	ACID	Eventual
Examples	RDS, Aurora	DynamoDB
Use Case	Transactions	High traffic apps



---

💾 Backup & Recovery

Automated Backup

Daily snapshots

Continuous transaction logs

Point-in-Time Recovery (up to 35 days)


Manual Snapshot

User-initiated

Retained until manually deleted

Used for migration & long-term backup



---

📈 Read Replicas

Used for read scaling

Asynchronous replication

Read-only

Offloads traffic from primary DB


Primary DB  --->  Read Replica


---

🛡️ Multi-AZ Deployment

Designed for High Availability

Synchronous replication

Automatic failover

Standby is not accessible for reads


AZ-1 (Primary) <==== Sync ====> AZ-2 (Standby)


---

🔐 Networking & Security

Security Groups

Database	Port

MySQL / MariaDB	3306
PostgreSQL	5432


Database should be in Private Subnet

Allow inbound access only from application Security Group


DB Subnet Group

Minimum 2 subnets

Must be in different Availability Zones

Required for Multi-AZ



---

🚀 Mini Project: Java Application with Amazon RDS


---

🧱 Architecture

User
 ↓
EC2 (Java + Tomcat)
 ↓
Amazon RDS (MariaDB)
 ↑
Artifacts from S3


---

Step 1: Create RDS Database

Console Path

RDS → Databases → Create Database

Configuration

Engine: MariaDB / MySQL

Template: Free Tier

DB Identifier: studentdb

Master Username: admin

Password: admin1234



---

Step 2: Create EC2 Instance

AMI: Amazon Linux

Instance Type: t2.micro / t3.micro


Security Group Rules

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

Step 4: Configure EC2

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

Step 6: Download Artifacts from S3

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

Step 10: Verify Database Connectivity

mysql -u admin -h <RDS-ENDPOINT> -p
show tables;
desc students;


---

🧠 Interview Key Points

RDS is managed, EC2 DB is self-managed

Multi-AZ ≠ Read Scaling

Read Replicas ≠ High Availability

RDS instances cannot be SSH accessed

Databases should never be public



---
