

Scaling & Storage Performance (AWS – Interview Notes)


---

📌 Topic: Scaling (Concepts & Types)

1️⃣ What is Scaling?

Scaling is the ability of a system to increase or decrease its capacity based on demand while maintaining:

Performance

Availability

Cost efficiency



---

2️⃣ Types of Scaling

🔹 Manual Scaling vs Auto Scaling

Manual Scaling

Capacity is increased or decreased manually by a human

Requires operational intervention


Pros

Simple

Full manual control


Cons

Slow response

Error-prone

Not suitable for production


Use Cases

Dev / Test environments

Small workloads



---

Auto Scaling

Capacity adjusts automatically

Based on:

Metrics

Schedules

Forecasts



Pros

High availability

Cost-optimized

Fast reaction to traffic spikes


Cons

Requires correct policy configuration


Use Cases

Production workloads

Web apps & APIs



---

🔹 Horizontal vs Vertical Scaling

Horizontal Scaling (Scale Out / In)

Adds or removes instances

Example: 2 EC2 → 6 EC2


Advantages

Fault tolerance

High availability

Long-term scalability


Requirements

Stateless design

Load balancer

Shared or distributed storage


Best For

Microservices

Cloud-native apps



---

Vertical Scaling (Scale Up / Down)

Increase resources of a single instance

Example: t3.medium → t3.large


Advantages

Simple to implement

No architecture changes


Limitations

Hardware limits

Possible downtime

Single point of failure


Best For

Monolithic applications

Short-term performance boost



---

📌 Topic: Auto Scaling Methods

1️⃣ Static Scaling (Baseline)

Fixed min / desired / max capacity

Rarely changes

Ensures minimum availability


Use Case

Always-on workloads



---

2️⃣ Dynamic Scaling

Reactive scaling

Responds to live metrics:

CPU

Requests

Queue depth



Policies

Target Tracking

Step Scaling

Simple Scaling



---

3️⃣ Predictive Scaling

Proactive scaling

Uses historical data & ML

Scales before traffic arrives


Best For

Seasonal traffic

Predictable demand



---

4️⃣ Scheduled Scaling

Time-based scaling

Example:

Scale out: Weekdays 9–11 AM

Scale in: Night hours



Best For

Predictable workloads



---

📌 Topic: Dynamic Scaling Policy Types

🔹 Target Tracking Scaling

Maintains a target metric

Example:


CPU Utilization = 50%

AWS adds/removes capacity automatically



---

🔹 Step Scaling

Multiple thresholds with graded actions


Example

CPU ≥ 70% → +1 instance

CPU ≥ 85% → +2 instances



---

🔹 Simple Scaling

One alarm → one scaling action

Legacy approach

Less flexible



---

📌 Topic: Storage Performance Terminology


---

1️⃣ IOPS (Input/Output Operations Per Second)

Number of read/write operations per second

Focuses on operation count, not data size


Best For

Databases

Small random I/O workloads



---

2️⃣ Latency

Time taken to complete a single I/O request

Measured in milliseconds (ms)


Key Point

Lower latency = faster application response



---

3️⃣ Throughput

Amount of data transferred per second

Measured in MB/s or GB/s


Formula

Throughput ≈ IOPS × Block Size

Best For

Large file transfers

Streaming

Analytics



---

4️⃣ Block Size & Data Chunks

Small Block Size

More I/O operations

Higher IOPS

Lower latency per operation


Use Case

Transactional databases



---

Large Block Size

Fewer operations

Higher throughput

Longer I/O duration


Use Case

Backup

Media files

Big data workloads



---

🎯 Interview Mapping (Quick Recall)

Requirement	Choose

High availability	Horizontal Scaling
Quick performance boost	Vertical Scaling
Unpredictable traffic	Auto Scaling
Predictable traffic	Scheduled Scaling
Databases	High IOPS + Low Latency
Analytics	High Throughput



---

✅ Key Interview Takeaways

Auto Scaling enables self-healing architecture

Horizontal scaling is cloud-native best practice

IOPS ≠ Throughput

Latency impacts user experience directly

Scaling + Load Balancer = production readiness

___


###Auto Scaling Configuration (Scale Out / Scale In) – AWS Hands-On


---

📌 Overview

This guide demonstrates how to configure Auto Scaling with an Application Load Balancer (ALB) to automatically:

Scale Out (add instances) when load increases

Scale In (remove instances) when load decreases


It uses:

Launch Templates

Auto Scaling Groups (ASG)

CloudWatch Alarms

ALB with Path-Based Routing



---

🧭 Architecture Flow

User Traffic
     ↓
Application Load Balancer (ALB)
     ↓
Target Groups (Home / Mobile / Laptop)
     ↓
Auto Scaling Groups (ASG)
     ↓
EC2 Instances (Auto Scale In / Out)


---

Step 1: Change AWS Region

Ensure you are working in the correct AWS Region

All resources (ALB, ASG, EC2, Target Groups) must be in the same region



---

Step 2: Create Security Group

Configuration

Name & Description: As per your project

Inbound Rules

HTTP (80) → Anywhere IPv4

SSH (22) → Anywhere IPv4


Outbound Rules

All traffic → Anywhere




---

Step 3: Create Launch Template

Launch Template Configuration

AMI: Amazon Linux

Instance Type: t2.micro

Key Pair: Select existing key

Security Group: Select SG created in Step 2

Subnet: ❌ Leave blank (ASG will decide)

Advanced Details

Paste User Data script (web server setup)



#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "<h1>Home Page - $HOSTNAME</h1>" > /var/www/html/index.html

Click Create Launch Template


> 🔁 Repeat Launch Template creation for Laptop and Mobile if separate scripts are required




---

Step 4: Create Target Groups

Create three target groups:

Target Group	Protocol	Port	Health Check Path

tg-home	HTTP	80	/
tg-laptop	HTTP	80	/laptop
tg-mobile	HTTP	80	/mobile


Steps

EC2 → Target Groups → Create

Target Type: Instance

Protocol: HTTP

Port: 80

Register instances later via ASG



---

Step 5: Create Application Load Balancer (ALB)

ALB Configuration

Name: AppLB

Type: Application Load Balancer

Scheme: Internet-facing

VPC: Default

Subnets: Select at least 2 (recommended: all)

Security Group: Select SG from Step 2

Listener

HTTP : 80

Default Action → Forward to tg-home



Click Create Load Balancer


---

Step 6: Configure Path-Based Routing Rules

Listener Rules (HTTP : 80)

Rule 1: Laptop

Condition: Path → /laptop/*

Action: Forward → tg-laptop

Priority: 2


Rule 2: Mobile

Condition: Path → /mobile/*

Action: Forward → tg-mobile

Priority: 3



---

Step 7: Create Auto Scaling Groups (ASG)

Step 7.1: Home ASG

Name: home-ASG

Launch Template: Home template

VPC: Default

Availability Zones: Select Any / All

Load Balancer

Attach to existing ALB

Select Target Group → tg-home


Capacity

Desired: 2

Minimum: 1

Maximum: 3


Monitoring: Enable



---

Step 7.2 & 7.3: Laptop & Mobile ASGs

Repeat the same steps:

ASG Name	Target Group

laptop-ASG	tg-laptop
mobile-ASG	tg-mobile



---

Step 8: CloudWatch Alarm (Scale Out)

Create High CPU Alarm

CloudWatch → Alarms → Create Alarm

Metric:

EC2 → By Auto Scaling Group

Metric: CPU Utilization


Condition:

Static

≥ 20%


Notification:

Create new SNS Topic

Enter email & confirm subscription


Alarm Name: cpu-high-alarm



---

Step 9: Scaling Policy (Scale Out)

EC2 → Auto Scaling Groups → home-ASG

Automatic Scaling → Create Policy

Policy Type: Simple Scaling

Policy Name: policy-home-scale-out

Alarm: cpu-high-alarm

Action: Add +1 instance

Cooldown: 100 seconds



---

📉 Auto Scaling (Scale In)


---

Step 10: CloudWatch Alarm (Scale In)

Metric: CPU Utilization

Condition:

Static

≤ 10%


Period: 1 minute

Datapoints: 2

SNS Topic: Existing topic

Alarm Name: cpu-low-alarm



---

Step 11: Scaling Policy (Scale In)

Auto Scaling Group → home-ASG

Policy Type: Simple Scaling

Policy Name: policy-home-scale-in

Alarm: cpu-low-alarm

Action: Remove -1 instance

Cooldown: 100 seconds



---

🧪 Testing Auto Scaling

Connect to EC2 Instance

sudo -i
yum update -y
yum install stress -y

> Enable EPEL if required



Generate CPU Load

stress --cpu 2 --timeout 300

Expected Behavior

CPU > 20% → Scale Out

New EC2 instance added

CPU < 10% → Scale In

Extra instance terminated



---

🧹 Cleanup (Very Important)

Delete resources in this exact order:

1. Auto Scaling Groups (ASG)


2. Launch Templates


3. Application Load Balancer (ALB)


4. Target Groups


5. Security Groups


6. CloudWatch Alarms


7. SNS Topics




---

🎯 Interview Takeaways

Auto Scaling provides self-healing

ALB + ASG is a production-grade architecture

Scale Out = High CPU

Scale In = Low CPU

CloudWatch + SNS = Monitoring & Alerting



