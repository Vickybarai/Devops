
AWS Route 53 – DNS & Traffic Routing Service


---

📌 Topic

Amazon Route 53


---

📖 Definition

Amazon Route 53 is a highly available and scalable Domain Name System (DNS) web service provided by AWS.

It translates human-readable domain names into machine-readable IP addresses.

Example

www.google.com  →  142.250.190.14


---

⚙️ Core Function

Acts as the “phone book of the internet”

Directs users to the correct application endpoint

Provides a single global entry point for applications



---

✅ Key Benefits

Global traffic management

Highly available & fault tolerant

Seamless integration with AWS services

Application Load Balancer

CloudFront

S3 (Static Website)


Supports advanced routing policies



---

🌐 Domain Name Breakdown


---

Example Domain

https://www.indeed.com


---

Domain Components

Component	Description

Protocol	https:// – Defines communication method
Subdomain	www – Third-level domain (optional prefix)
SLD	indeed – Second Level Domain (purchased name)
TLD	.com – Top Level Domain



---

Types of TLDs

Generic TLDs (gTLD)

.com – Commercial

.org – Organization

.gov – Government

.edu – Education

.net – Network / Technology


Country Code TLDs (ccTLD)

.in – India

.us – United States

.uk – United Kingdom



---

🗂 Hosted Zones


---

Definition

A Hosted Zone is a container that holds DNS records for a specific domain.

Example

mydomain.com


---

Types of Hosted Zones

Type	Purpose

Public Hosted Zone	Routes traffic from the public internet
Private Hosted Zone	Routes traffic within AWS VPC (private IPs)



---

📄 DNS Record Types


---

Record Type	Purpose	Example

A	Maps domain to IPv4 address	example.com → 192.0.2.1
AAAA	Maps domain to IPv6 address	example.com → IPv6
CNAME	Maps domain to another domain	blog.example.com → blog.example.net
Alias	AWS-only record mapping to AWS resources	myapp.com → ALB
NS	Name Server record	Defines authoritative servers
MX	Mail exchange record	Email routing
PTR	Reverse DNS lookup	IP → Domain
SOA	Zone administrative info	TTL, admin email
SRV	Service discovery	SIP, XMPP



---

🔹 Alias Record (Important)

AWS-specific

Free (no DNS query cost)

Can point to:

ALB

CloudFront

S3

API Gateway




---

🚦 Route 53 Routing Policies


---

Definition

Routing policies control how Route 53 responds to DNS queries when multiple resources are available.


---

Types of Routing Policies

1️⃣ Simple Routing

Single resource

No health check

Use case: One web server



---

2️⃣ Latency-Based Routing

Routes users to the lowest latency AWS region

Improves performance



---

3️⃣ Geo-Location Routing

Routes traffic based on user’s geographic location

Example:

Europe → eu-west-1

India → ap-south-1




---

4️⃣ Weighted Routing

Distributes traffic by percentage

Common for:

A/B testing

Canary deployments



Example

Old Server → 90%
New Server → 10%


---

🎯 Common Interview Points

Route 53 is a DNS service, not a load balancer

Alias record ≠ CNAME

Hosted Zone defines DNS authority

Supports advanced routing strategies

Highly available by default



---

📌 Real-World Use Case

Route users to nearest region

Perform blue-green deployments

Failover between regions

Manage global applications



