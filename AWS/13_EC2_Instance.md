
## Topic: EC2 Instance Types

### Interview Keyword (IQ):
- **Type**
- **Series**
- **Load Balancer**
- **EC2 Instance Type & Tenancy**

### Definition
**EC2 Instance Types** define the **hardware configuration** of an EC2 instance.  
They are grouped based on **use cases** and provide different combinations of:
- CPU
- Memory
- Storage
- Networking capacity

---

### Categories of EC2 Instance Types

#### 1. General Purpose
- Balanced compute, memory, and networking
- Suitable for most workloads
- Examples:
  - `t2`, `t3`, `t3a`

#### 2. Compute Optimized
- High-performance processors
- Best for compute-intensive tasks
- Use cases:
  - Scientific modeling
  - Batch processing
  - High-performance web servers

#### 3. Memory Optimized
- High memory-to-CPU ratio
- Designed for large in-memory datasets
- Use cases:
  - Databases
  - In-memory caching
  - Real-time analytics

#### 4. Accelerated Computing
- Uses hardware accelerators (GPU, FPGA)
- Use cases:
  - Machine Learning
  - AI
  - Video processing

#### 5. Storage Optimized
- High I/O performance
- Local instance storage
- Use cases:
  - Big data
  - Data warehousing
  - Log processing

---

## Topic: Instance Tenancy

### Definition
**Instance Tenancy** defines **how your EC2 instances are placed on physical hardware**.

---

### Diagram Notes (From Notebook)

- Rack → Placement Group
- Placement Group Types:
  1. **Cluster** – EC2, EC2, EC2 close together (same rack)
  2. **Spread** – Separate hardware (rent by same organization)
  3. **Partition** – Hardware divided into isolated partitions

---

### Types of Instance Tenancy

#### 1. Shared (Default)
- Instances share hardware with other AWS customers
- Cost-effective
- Default option

#### 2. Dedicated Instance
- Hardware dedicated to **one AWS customer**
- Multiple instances of the same customer can run
- Less control than Dedicated Host

#### 3. Dedicated Host
- A **physical server** dedicated only to you
- Full visibility & control over hardware
- Required for:
  - License compliance
  - Regulatory requirements

---




.