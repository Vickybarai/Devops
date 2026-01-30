# EC2 Pricing & Purchasing Options

AWS provides multiple EC2 purchasing models to optimize **cost, flexibility, and availability**.  
Choosing the correct option is a **business + architectural decision**, not just a technical one.

---

## 1. On-Demand Instances

### Definition
On-Demand instances allow you to pay for compute capacity **by the second**, with **no long-term commitment**.

### Payment Model
- Pay per second (minimum 60 seconds)
- No upfront payment
- Stop or terminate anytime

### Advantages
- Maximum flexibility
- No capacity planning required
- Immediate availability

### Disadvantages
- Highest cost compared to other options

### Common Use Cases
- Development and testing
- Proof of Concept (PoC)
- Short-lived workloads
- Unpredictable traffic

### Interview Point
> On-Demand prioritizes flexibility over cost optimization.

---

## 2. Savings Plans

### Definition
Savings Plans provide lower prices in exchange for a **commitment to a consistent amount of compute usage ($/hour)**.

### Commitment
- 1-year or 3-year term
- Commit to **spend**, not instance type

### Savings
- Up to **66–72%** lower than On-Demand
- Real-world average: ~60%

### Types of Savings Plans
#### 1. Compute Savings Plan
- Applies across:
  - Instance families
  - Regions
  - Operating systems
- Highest flexibility

#### 2. EC2 Instance Savings Plan
- Locked to instance family and region
- Higher discount than Compute SP

### Advantages
- High cost savings
- Automatic application
- Suitable for modern architectures

### Limitations
- Commitment required
- Over-commitment leads to unused spend

### Best Use Cases
- Microservices
- Container workloads
- Auto Scaling environments

---

## 3. Reserved Instances (RI)

### Definition
Reserved Instances provide discounted pricing by reserving capacity for a **specific instance configuration**.

### Commitment
- 1-year or 3-year term
- Payment options:
  - No Upfront
  - Partial Upfront
  - All Upfront

### Savings
- Up to **72–75%** discount
- Can reach ~80% in practice

### Constraints
- Fixed:
  - Region
  - Availability Zone (Zonal RI)
  - Instance family and size
- No refunds after purchase

### Types of Reserved Instances
#### Standard RI
- Maximum discount
- Minimal flexibility

#### Convertible RI
- Can change instance family
- Slightly lower discount

### Best Use Cases
- Databases
- ERP systems
- Steady, predictable workloads

---

## 4. Spot Instances

### Definition
Spot Instances use **unused AWS capacity** at deeply discounted prices.

### Cost Advantage
- Up to **90–92% cheaper** than On-Demand

### Key Risk
- Instances can be terminated anytime
- 2-minute interruption notice

### Suitable Workloads
- Batch processing
- Big data analytics
- CI/CD pipelines
- Machine learning training
- Load testing

### Not Recommended For
- Databases
- Stateful production applications

### Interview Point
> Spot Instances trade reliability for cost savings.

---

## 5. Capacity Reservations

### Definition
Capacity Reservations guarantee EC2 capacity in a **specific Region and Availability Zone**.

### Key Characteristics
- Guaranteed capacity availability
- Charged whether used or not
- Can be combined with:
  - Savings Plans
  - Reserved Instances

### Use Cases
- Business-critical systems
- Disaster recovery
- Peak traffic scenarios
- Regulated industries

### Interview Point
> Capacity Reservations ensure availability, not cost reduction.

---

## 6. Dedicated Instances

### Definition
Dedicated Instances run on **single-tenant hardware** dedicated to one AWS account.

### Features
- Physical isolation
- Billed per instance
- No hardware-level visibility

### Use Cases
- Compliance requirements
- Licensing constraints
- Moderate isolation needs

---

## 7. Dedicated Hosts

### Definition
Dedicated Hosts provide full control over the **entire physical server**.

### Capabilities
- Control over sockets and cores
- Supports BYOL (Bring Your Own License)
- Instance placement control

### Billing
- Charged per physical host

### Use Cases
- Enterprise compliance
- Oracle / SQL Server licensing
- Legacy enterprise workloads

---

## 8. EC2 Pricing Comparison Table

| Option | Cost | Flexibility | Reliability | Commitment |
|------|------|------------|------------|------------|
| On-Demand | High | Very High | High | None |
| Savings Plans | Medium | High | High | 1–3 Years |
| Reserved Instances | Low | Low | High | 1–3 Years |
| Spot Instances | Very Low | Medium | Low | None |
| Capacity Reservation | Medium | Low | Very High | Optional |
| Dedicated Instances | High | Medium | High | None |
| Dedicated Hosts | Very High | Low | Very High | Optional |

---

## 9. One-Line Interview Summary

AWS EC2 pricing options allow customers to balance **cost, flexibility, and availability** based on workload requirements.