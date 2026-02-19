 AWS Cloud Computing – 
---

## Part 1: Cloud Service Models

Cloud service models define who manages what in the cloud stack. AWS offers services across all three models.

---

### 1. IaaS (Infrastructure as a Service)

#### Definition

Infrastructure as a Service (IaaS) provides virtualized computing resources over the internet.
It is the foundational building block of Cloud IT, offering maximum control to users.

---

#### Responsibility Model

**AWS Responsibility**
- Physical data centers
- Hardware
- Virtualization layer
- Networking infrastructure

**User Responsibility**
- Operating System (OS)
- Runtime
- Applications
- Data
- Security patches and updates

This shared responsibility gives users full administrative control over the system.

---

#### AWS IaaS Examples

| Service | Description |
|---------|-------------|
| **Amazon EC2** | Virtual servers with scalable compute capacity. User controls instance type, OS, storage, and networking |
| **Amazon S3** | Object storage service for virtually unlimited data. Used for backups, static websites, logs, and media storage |
| **Amazon EBS** | Block-level storage attached to EC2 instances. Used for OS disks, databases, and applications requiring low latency |
| **Amazon VPC** | Virtual Private Cloud for isolated networking. Enables custom IP ranges, subnets, route tables, and gateways |
| **Amazon Route 53** | Highly available DNS and domain name service. Used for routing traffic to AWS resources globally |

---

#### Characteristics

- Full control over OS, runtime, and applications
- Highly flexible infrastructure
- Pay-as-you-go pricing model
- User is responsible for:
  - OS installation
  - Security patching
  - Application deployment
  - Configuration management

---

#### Use Cases

- High-performance computing workloads
- Website and application hosting
- Development and testing environments
- Disaster recovery setups
- Lift-and-shift migrations from on-premise to cloud

---

### 2. PaaS (Platform as a Service)

#### Definition

Platform as a Service (PaaS) provides a fully managed platform and runtime environment to develop, run, and manage applications without dealing with infrastructure complexity.

---

#### Responsibility Model

**AWS Responsibility**
- Infrastructure
- Networking
- Servers
- Operating system
- Platform management
- Scaling and availability

**User Responsibility**
- Application code
- Application data

---

#### AWS PaaS Examples

| Service | Description |
|---------|-------------|
| **AWS Elastic Beanstalk** | Simplified application deployment platform. Supports Java, Python, Node.js, .NET, PHP, Go, and Docker |
| **AWS Lambda** | Serverless compute service. Executes code in response to events. No server or OS management required |
| **Amazon RDS** | Fully managed relational database service. Handles backups, patching, replication, and failover |
| **AWS App Runner** | Fully managed service for containerized web applications. Ideal for microservices and APIs |
| **Amazon API Gateway** | Managed service for creating, publishing, and securing APIs |

---

#### Characteristics

- Developers focus only on writing code
- Infrastructure and OS managed by AWS
- Built-in:
  - Auto-scaling
  - Monitoring
  - Security
- Faster development and deployment cycles
- User responsible only for application logic and data

---

#### Use Cases

- Web application development
- API development and management
- Microservices-based architectures
- Rapid prototyping and MVP creation
- Event-driven applications

---

### 3. SaaS (Software as a Service)

#### Definition

Software as a Service (SaaS) delivers a complete, ready-to-use software application over the internet.
Users simply consume the application, without managing infrastructure or platforms.

---

#### Responsibility Model

**AWS Responsibility**
- Infrastructure
- Platform
- Software
- Security
- Maintenance
- Availability

**User Usage**
- Data usage and application configuration only

---

#### AWS SaaS Examples

| Service | Description |
|---------|-------------|
| **Amazon WorkSpaces** | Fully managed virtual desktop service |
| **Amazon Chime** | Communication and collaboration service |
| **AWS QuickSight** | Business intelligence and analytics platform |
| **Amazon Connect** | Cloud-based contact center solution |
| **AWS WorkDocs** | Secure document storage and collaboration service |

---

#### Characteristics

- No installation or maintenance required
- Access via web browser or mobile applications
- Multi-tenant architecture with shared infrastructure
- AWS manages everything behind the scenes
- User only focuses on business usage

---

#### Use Cases

- Business productivity tools
- Team collaboration and communication
- Analytics and reporting
- Customer relationship management (CRM)
- End-user software consumption

---

## Part 2: AWS Infrastructure Components

---

### 1. AWS Data Center

#### What is a Data Center in AWS?

- A physical facility that stores computing machines and related hardware
- Each data center contains tens of thousands of servers (commonly estimated between 50,000 to 80,000)
- Designed with:
  - Redundant power
  - Cooling systems
  - Networking
- Protected against:
  - Cyber threats
  - Unauthorized physical access
  - Natural disasters

> **Data centers are never exposed directly to customers.**

---

### 2. Availability Zone (AZ)

#### Definition

- An Availability Zone consists of one or more discrete data centers
- Each AZ has:
  - Independent power
  - Independent networking
  - Independent cooling
- AZs within a region are connected via high-bandwidth, low-latency private fiber networks
- Latency between AZs is typically single-digit milliseconds

---

#### Key Points

- AWS operates 100+ Availability Zones globally (number increases over time)
- AZs are located up to ~60 miles (100 km) apart within a region
- Designed to prevent correlated failures
- Enables high availability and fault tolerance

---

## Part 3: AWS Service Scope (Global vs Regional vs AZ)

---

### 3. Global Services

#### Definition

- Global services are accessible from any AWS region
- The control plane is managed centrally
- The data plane is distributed globally

---

#### Examples

| Service | Description |
|---------|-------------|
| **Amazon S3** | Global namespace for buckets. Data resides in regions but service is globally accessible |
| **Amazon CloudFront** | Global Content Delivery Network (CDN) |
| **AWS IAM** | Identity and Access Management. Users, roles, and policies are global |
| **Amazon Route 53** | Global DNS service with worldwide routing |

---

### 4. Region-Specific Services

#### Definition

- These services operate within a specific AWS region
- Resources are isolated to the region where they are created

---

#### Core Region Services

- Amazon EC2
- Amazon RDS
- AWS Lambda
- Amazon VPC
- Amazon CloudWatch
- Amazon S3 (data stored regionally)

---

#### Region Selection Criteria

- Latency requirements
- Data residency and compliance laws
- Service availability
- Cost considerations
- Disaster recovery strategy

---

### 5. Availability Zone–Specific Services

#### Definition

- These services are tied to specific Availability Zones
- Used for fault isolation and high availability design

---

#### Examples

| Service | Description |
|---------|-------------|
| **Amazon EC2** | Instances are launched in a specific AZ. Placement control enables HA architectures |
| **Amazon EBS** | EBS volumes are AZ-specific. Can only attach to EC2 instances in the same AZ |

---

#### Benefits

- Enables high availability by distributing workloads across AZs
- Supports disaster recovery strategies
- Prevents single-point-of-failure scenarios

---

### 6. Edge Locations (Cache Servers)

#### Definition

- Edge locations are AWS data centers optimized for low-latency content delivery
- Smaller than full AWS regions
- Designed to cache content closer to end users

---

#### Key Characteristics

- Located geographically closer to users
- Used primarily by:
  - Amazon CloudFront
  - AWS Global Accelerator
- Reduce latency and improve user experience

---

#### Example Locations (India)

- Mumbai
- Delhi
- Kolkata
- Chennai
- Bengaluru
- Hyderabad

---

> **Interview Tip (High Value)**
> 
> If asked: *"Design a highly available AWS architecture"*
> 
> Your answer should explicitly mention:
> - Multiple Availability Zones
> - Region-aware service selection
> - Edge locations for performance
> - Shared responsibility model understanding

---

# Amazon EC2 – Deep Dive (Interview & Practical Notes)

---

## Part 4: Amazon EC2 Deep Dive

Amazon EC2 (Elastic Compute Cloud) is the core compute service in AWS. Most AWS architectures either start with EC2 or integrate with it indirectly.

---

### 1. EC2 Launch Process Overview

#### Definition

EC2 = Launch Instance / Server / Virtual Machine

An EC2 instance is a resizable virtual server running inside an AWS data center.

---

#### Launch Workflow (Conceptual Flow)

When you launch an EC2 instance, AWS follows this logical sequence:

```

Launch Instance
→ AMI (Amazon Machine Image – Template)
→ Instance Type
→ Operating System (example: Ubuntu)
→ Key Pair
→ Security Group

```

Each step directly impacts performance, security, and cost.

---

#### Explanation of Each Step

| Component | Description |
|-----------|-------------|
| **AMI (Amazon Machine Image)** | A preconfigured template that defines: Operating System, Preinstalled software, Root volume configuration. Examples: Amazon Linux, Ubuntu, Windows Server |
| **Instance Type** | Defines: vCPU count, RAM, Network performance. Example: t2.micro (Free Tier eligible) |
| **Operating System** | Chosen via AMI. Common interview mention: Ubuntu, Amazon Linux, Windows |
| **Key Pair** | Used for secure login authentication |
| **Security Group** | Acts as a virtual firewall controlling inbound and outbound traffic |

---

### 2. Key Components in EC2

---

#### Key Pair

Key pairs enable secure access to EC2 instances using public-key cryptography.

**Public Key**
- Stored securely in AWS
- Injected into the instance during launch

**Private Key**
- Downloaded and stored on the user's local machine
- AWS never stores or recovers this key
- User is fully responsible for key safety

> **If the private key is lost:**
> - You cannot SSH directly
> - Recovery requires advanced steps (detach root volume, etc.)

---

#### Interview Question (IQ): Hostname

**Hostname**
- The internal name used to identify the EC2 instance
- Helps in:
  - System identification
  - Networking
  - Logs and monitoring
- Can be customized at OS level

> **Interview angle:**
> Hostname is not the same as Instance ID, but both uniquely identify instances at different layers.

---

### 3. Status Checks in EC2

#### Core Interview Question

> *"How many types of status checks are there in EC2?"*

**Answer: 2 types**

The purpose of status checks is to determine where the problem exists:
- AWS infrastructure side
- OR user-controlled instance side

---

#### Status Check Result Format

| Result | Meaning |
|--------|---------|
| **2/2 checks passed** | Healthy (Green) |
| **1/2 checks passed** | Partial failure |
| **0/2 checks passed** | Instance is unhealthy |

---

#### A. System Status Checks

**Purpose**
- Monitors the AWS-managed infrastructure that hosts your EC2 instance
- These issues are not under user control

**Monitors for**
- Network connectivity problems on AWS side
- Power failures
- Physical host failures
- Hypervisor issues
- AWS internal hardware or software problems

> **Key Point (Interview Gold)**
> 
> If System Status Check fails:
> - User usually cannot fix it directly
> - AWS may:
>   - Recover the instance
>   - Migrate it
>   - Require a stop/start action

---

#### B. Instance Status Checks

**Purpose**
- Monitors the user-controlled software layer
- Focuses on whether the instance itself is functioning correctly

**Monitors for**
- Network interface health (via ARP requests)
- Operating System boot completion
- OS-level configuration
- Kernel functionality
- Software misconfiguration

> **Key Point**
> 
> If Instance Status Check fails:
> - The issue is usually:
>   - OS crash
>   - Kernel panic
>   - Incorrect firewall rules
>   - Application misconfiguration
> - User is responsible for troubleshooting

---

#### Interview Summary (Status Checks)

| Check Failed | Problem Location |
|--------------|------------------|
| **System Check failed** | AWS-side problem |
| **Instance Check failed** | User-side problem |

> This distinction is frequently asked in interviews.

---

## Part 5: AWS Nitro Enclaves

Nitro Enclaves are part of AWS's advanced security architecture.

---

### 1. Definition

- AWS Nitro Enclaves allow you to create isolated execution environments inside an EC2 instance
- Designed for security-critical workloads
- Ideal for processing highly sensitive data

These enclaves are built on the AWS Nitro System, not traditional virtualization.

---

### 2. Key Characteristics (Constraints)

Nitro Enclaves intentionally operate under strict limitations to maximize security.

---

#### i) No Persistent Storage

- Data stored inside an enclave:
  - Exists only during runtime
  - Is destroyed after enclave termination
- Prevents data persistence attacks

---

#### ii) No Interactive Access

- You cannot SSH into an enclave
- No shell access
- All interactions happen programmatically

---

#### iii) No External Networking

- Enclaves:
  - Have no internet access
  - Cannot communicate with external networks
- Communication allowed only via secure local sockets with the parent instance

---

#### iv) CPU and Memory Isolation

- Dedicated CPU and memory resources
- Parent EC2 instance:
  - Cannot inspect
  - Cannot access
  - Cannot modify enclave memory

This enforces strong isolation guarantees.

---

### 3. Summary

- Nitro Enclaves create a super-secure, isolated environment inside an EC2 instance
- Designed to reduce attack surface
- Used when data confidentiality is more important than convenience

---

### 4. Use Cases (Examples)

Nitro Enclaves are commonly used for processing:

- Credit card numbers (PCI-DSS compliance)
- Medical records (HIPAA compliance)
- Personally Identifiable Information (PII)
- Encryption keys and secrets
- Secure data signing and verification

---

> **Interview Tip (High Impact)**
> 
> If asked: *"How does AWS protect sensitive data inside EC2?"*
> 
> A strong answer should include:
> - Nitro System
> - Nitro Enclaves
> - Isolation
> - No networking
> - No persistent storage
```
