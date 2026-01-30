# EC2 Deep-Dive Notes (Notebook Format)
Covering:
- Instance Types
- Instance Tenancy
- Placement Groups
- Network Interfaces (NIC / ENI)
- Elastic IP
- Security Groups vs NACLs

---

## Topic: EC2 Instance Types

### Definition
**EC2 Instance Types** define the hardware configuration of an EC2 instance, including CPU, memory, storage, and networking capacity. They are grouped based on workload use cases.

---

### Instance Type Families (IQ – Type, Series)

> Format Example: `t3.micro`
- **Family**: t (General purpose)
- **Generation**: 3
- **Size**: micro

---

### Categories of EC2 Instance Types

- **General Purpose**
  - Balanced CPU, memory, and networking
  - Examples: `t2`, `t3`, `t4g`, `m5`
  - Use case: Web servers, dev/test, small databases

- **Compute Optimized**
  - High CPU performance
  - Examples: `c5`, `c6`
  - Use case: Scientific modeling, batch processing, high-performance servers

- **Memory Optimized**
  - High memory capacity
  - Examples: `r5`, `x1`
  - Use case: In-memory databases, real-time big data analytics

- **Accelerated Computing**
  - Uses GPUs / FPGAs
  - Examples: `p`, `g`, `inf`
  - Use case: Machine learning, AI, video rendering

- **Storage Optimized**
  - High IOPS and throughput using local storage
  - Examples: `i3`, `d2`
  - Use case: Data warehousing, log processing

---

## Topic: Instance Tenancy

### Definition
**Instance Tenancy** defines how your EC2 instance is placed on the underlying physical hardware.

---

### Instance Tenancy Types (3 Types)

- **Shared (Default)**
  - Instances may share hardware with other AWS customers
  - Lowest cost
  - Most commonly used

- **Dedicated Instance**
  - Hardware dedicated to **a single AWS customer**
  - May run multiple instances from the same customer
  - No control over the physical host

- **Dedicated Host**
  - A **physical server fully dedicated** to your use
  - Full visibility and control over sockets, cores
  - Required for compliance & licensing (e.g., Oracle, Windows BYOL)

---

### Diagram Notes (From Notebook)

- Rack → Placement Group
- Cluster: EC2 EC2 EC2 close together
- Spread: EC2s on separate hardware
- Partition: Hardware isolation in sections

