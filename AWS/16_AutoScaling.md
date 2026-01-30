Scaling & Storage Performance – Concepts Deep Dive

This section explains how systems scale and how storage performance is measured, both of which are core AWS + DevOps interview topics and critical for real-world architecture decisions.


---

Topic: Scaling (Concepts & Types)

1. What is Scaling?

Scaling is the ability of a system to increase or decrease resources in response to workload demand while maintaining:

Performance

Availability

Cost efficiency


A well-designed system scales smoothly under load and shrinks during low usage to avoid waste.


---

2. Types of Scaling

A. Manual Scaling vs Auto Scaling

Manual Scaling

Capacity changes are performed by a human.

Engineer manually adds or removes servers/resources.


Pros

Full control

Simple to understand


Cons

Slow reaction to traffic spikes

Error-prone

Not suitable for production-scale systems


Use Case

Testing environments

Small or non-critical workloads



---

Auto Scaling

Capacity adjusts automatically based on:

Metrics (CPU, memory, requests)

Schedules

Forecasts



Pros

Faster response to load

Cost-efficient

High availability


Cons

Requires correct policy tuning


Use Case

Production systems

Web apps, APIs, microservices



---

B. Horizontal vs Vertical Scaling

Horizontal Scaling (Scale Out / Scale In)

Add or remove instances/nodes

Example: 2 EC2 → 6 EC2 during traffic spike


Advantages

Improves fault tolerance

Enables parallel processing

Supports long-term growth

No single point of failure


Requirements

Stateless application design

Load balancer

Shared or distributed storage


Best For

Cloud-native applications

Microservices

High availability systems



---

Vertical Scaling (Scale Up / Scale Down)

Increase resources of one machine

Example: t3.medium → t3.large


Advantages

Simple to implement

No architecture changes needed


Limitations

Hardware ceiling

Downtime may be required

Single point of failure


Best For

Monolithic apps

Databases needing short-term boosts



---

Topic: Auto Scaling Methods

1. Static Scaling (Baseline Capacity)

Define min / desired / max capacity

Capacity rarely changes

Ensures a minimum availability floor


Use Case

Always-on baseline traffic

Core services that must stay running



---

2. Dynamic Scaling

Reactive scaling

Responds to real-time metrics such as:

CPU utilization

Request count

Queue depth



Common Policies

Target Tracking

Step Scaling

Simple Scaling


Use Case

Unpredictable traffic

Event-driven workloads



---

3. Predictive Scaling

Proactive scaling

Uses historical data + ML

Scales before traffic arrives


Best For

Seasonal traffic

Cyclical workloads

Business-hour peaks



---

4. Scheduled Scaling

Time-based scaling using a clock or calendar

Example:

Scale out: Weekdays 9–11 AM

Scale in: Nights / weekends



Best For

Predictable workloads

Batch jobs

Office-hour applications



---

Topic: Dynamic Scaling Policy Types

1. Target Tracking Scaling

Maintains a metric at a fixed target

Example: Keep CPU at 50%


Behavior

Automatically adds/removes capacity

Simplest and most recommended approach



---

2. Step Scaling

Multiple thresholds with graduated actions


Example:

CPU 70% → +1 instance

CPU 85% → +2 instances


Use Case

Fine-grained control over scaling behavior



---

3. Simple Scaling

One alarm triggers one fixed action

Older approach (mostly legacy)


Limitation

Less flexible

Cooldown delays



---

Topic: Storage Performance Terminology

Understanding storage performance is critical for databases, analytics, and high-traffic applications.


---

1. IOPS (Input/Output Operations Per Second)

Number of read/write operations per second

Focuses on operation count, not data size


Key Insight

High IOPS = good for small, random I/O

Example: Databases, OLTP systems



---

2. Latency

Time taken to complete one I/O request

Measured in milliseconds (ms)


Key Insight

Lower latency = faster response

Even with same IOPS, lower latency improves user experience



---

3. Throughput

Amount of data transferred per second

Measured in MB/s or GB/s


Relationship Formula

Throughput ≈ IOPS × Block Size

Key Insight

Large data transfers benefit more from throughput than IOPS



---

4. Block Size & Data Chunks

Block Size = data per I/O operation


Small Block Size

More I/O operations

Higher IOPS

Lower latency per operation


Use Case

Databases

Transactional systems



---

Large Block Size

Fewer I/O operations

Higher throughput (MB/s)

Each I/O takes longer


Use Case

File transfers

Media streaming

Analytics



---

Architectural Decision Tip (Interview Gold)

High IOPS + Low Latency → Databases

High Throughput → Big data & backups

Horizontal Scaling → Cloud-native apps

Vertical Scaling → Quick fixes & monoliths

Auto Scaling + ALB → Production-ready architecture



