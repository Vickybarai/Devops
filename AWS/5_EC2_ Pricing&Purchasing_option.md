 EC2 Pricing & Purchasing Options (Deep Dive)

AWS provides multiple EC2 purchasing models to balance cost, flexibility, and availability. Choosing the right option is a business decision, not just a technical one.


---

1. On-Demand Instances

Definition

On-Demand instances allow you to pay for compute capacity by the second, with no long-term commitment.

Payment Model

Billed per second (minimum 60 seconds)

No upfront payment

Stop anytime, pay only for usage


Advantages

Maximum flexibility

Ideal for unpredictable workloads

No planning or forecasting required

Fast provisioning


Disadvantages

Most expensive EC2 option

Not cost-efficient for steady workloads


Common Use Cases

Development & testing

Short-lived workloads

Proof of Concept (PoC)

Initial product launch


Interview Insight

> On-Demand = flexibility over cost optimization




---

2. Savings Plans

Definition

Savings Plans offer discounted prices in exchange for a commitment to a consistent amount of compute usage (measured in $/hour).

Commitment Model

1-year or 3-year term

Commit to spend, not instance type


Savings

Up to 66–72% cheaper than On-Demand

Practical real-world saving: ~60%


Types of Savings Plans

1. Compute Savings Plan

Works across:

Instance families

Regions

OS


Most flexible option



2. EC2 Instance Savings Plan

Locked to instance family & region

Higher discount than Compute Savings Plan




Advantages

High cost savings

High flexibility (especially Compute SP)

Automatically applied


Limitations

Commitment required

Over-commitment leads to wasted spend


Best Fit For

Long-running workloads

Microservices

Containerized & auto-scaling environments


Interview Insight

> Savings Plans = modern replacement for Reserved Instances




---

3. Reserved Instances (RI)

Definition

Reserved Instances provide significant discounts by reserving capacity for a specific configuration.

Commitment

1-year or 3-year lock-in

Payment options:

No Upfront

Partial Upfront

All Upfront



Savings

Up to 72–75% officially

Practically seen up to 80%


Constraints (Very Important)

Fixed:

Region

Availability Zone (for Zonal RIs)

Instance family & size


No refunds

Limited flexibility


Types of Reserved Instances

1. Standard RI

Highest discount

Least flexible



2. Convertible RI

Can change instance family

Slightly lower discount




Use Cases

Steady, predictable workloads

Databases

ERP systems

Legacy monolithic applications


Interview Trap

> RIs are capacity + pricing reservations, not just discounts.




---

4. Spot Instances

Definition

Spot Instances use unused AWS capacity at extremely low prices.

Pricing Model

Variable pricing (market-driven)

Up to 90–92% cheaper than On-Demand


Key Risk

AWS can terminate instances anytime

Only 2-minute interruption notice


Fault-Tolerance Requirement

Workload must handle interruption.

Ideal Use Cases

Batch processing

Big data analytics

CI/CD jobs

Load testing

Machine learning training

Image/video rendering


Not Suitable For

Databases

Stateful apps

Production critical systems


Interview Insight

> Spot Instances trade reliability for cost




---

5. Capacity Reservations

Definition

Capacity Reservations guarantee EC2 capacity in a specific Region and AZ, regardless of demand.

Core Benefit

Guaranteed instance availability

Useful during peak traffic or AWS shortages


Key Characteristics

No instance launch required immediately

You pay whether you use it or not

Can be combined with:

Savings Plans

Reserved Instances



Use Cases

Business-critical applications

Disaster recovery planning

Regulated industries

Seasonal traffic spikes


Interview Insight

> Capacity Reservation = availability guarantee, not cost savings




---

6. Dedicated Instances

Definition

Dedicated Instances run on hardware dedicated to a single AWS customer, but hardware may be shared with other instances from the same account.

Key Features

Single-tenant isolation

No hardware-level visibility

Billed per instance


Use Cases

Regulatory compliance

Moderate isolation needs

Legacy licensing models


Limitation

Less control than Dedicated Hosts

More expensive than shared tenancy



---

7. Dedicated Hosts

Definition

Dedicated Hosts give you control over the entire physical server.

Key Capabilities

Visibility into sockets, cores, and host IDs

Full control of instance placement

Supports BYOL (Bring Your Own License)


Billing Model

Billed per physical host

More expensive than all other options


Ideal Use Cases

Strict compliance requirements

Oracle / Windows / SQL Server licensing

Enterprise legacy workloads


Interview Insight

> Dedicated Host = maximum control + compliance




---

8. Quick Comparison Table (Interview Gold)

Option	Cost	Flexibility	Reliability	Commitment

On-Demand	High	Very High	High	None
Savings Plan	Medium	High	High	1–3 Years
Reserved Instance	Low	Low	High	1–3 Years
Spot	Very Low	Medium	Low	None
Capacity Reservation	Medium	Low	Very High	Optional
Dedicated Instance	High	Medium	High	None
Dedicated Host	Very High	Low	Very High	Optional



---

9. One-Line Interview Summary

> AWS EC2 pricing models allow customers to trade off cost, flexibility, and availability, ranging from fully flexible On-Demand to deeply discounted but interruptible Spot Instances.


