

1. Introduction to Kubernetes (K8s)

What is Kubernetes?

Kubernetes (K8s) is an open-source container orchestration platform used to automate deployment, scaling, and lifecycle management of containerized applications.

History

Originally developed by Google

Open-sourced in 2014

Now governed by CNCF (Cloud Native Computing Foundation)


Key Characteristics

Manages containerized workloads & services

Uses declarative configuration (desired state)

Supports automation and self-healing

Portable across on-premise, hybrid, and cloud

Enterprise-grade ecosystem support



---

2. Why Kubernetes?

The Problem (Without Kubernetes)

Manual container deployment on individual machines

No automated scaling

No automatic recovery from failures

High risk during application updates

Load balancing must be configured manually


The Solution (What Kubernetes Provides)

Feature	Description

Orchestration	Manages containers across multiple machines
Auto Scaling	Adjusts workloads based on CPU / memory demand
Self-Healing	Restarts failed containers and reschedules pods
Load Balancing	Distributes traffic evenly across pods
Rolling Updates	Zero-downtime deployments with rollback



---

3. Kubernetes Architecture Overview

Cluster Model

A Kubernetes Cluster is a group of machines working together to run containerized applications.

Two Primary Roles

1. Control Plane (Master Node)

The decision-making layer

Manages the cluster state

Schedules workloads

Does not run user applications (in production)


2. Worker Nodes

The execution layer

Runs application workloads (pods)

Executes instructions from the control plane



---

4. Control Plane Components (Master Node)

The Control Plane maintains the desired state of the cluster.




A. API Server (The Hub)

Role

Central communication hub of Kubernetes

All cluster operations pass through it


Responsibilities

Authentication & authorization

Validates requests (kubectl, REST APIs)

Updates cluster state in ETCD


📌 Important
Users and components never talk directly to each other — only via the API Server.




B. ETCD (The Database)

Role

Distributed, strongly consistent key-value store


Stores

Cluster configuration

Pod and node metadata

Secrets & ConfigMaps

Desired & current state


📌 ETCD is the source of truth for the entire cluster




C. Scheduler (The Planner)

Role

Assigns Pods to appropriate Worker Nodes


How Scheduling Works Scheduler evaluates:

CPU & memory availability

Node health

Policies, taints, tolerations

Affinity / anti-affinity rules


📌 Scheduler does not start containers — it only selects nodes.



D. Controller Manager (The Supervisor)

Role

Runs control loops to maintain desired state


Core Responsibility

Continuously compares:

Desired State (from ETCD)

Actual State (cluster reality)



Examples of Controllers

ReplicaSet Controller

Node Controller

Endpoint Controller


📌 If state drifts, controllers automatically correct it


---

5. Worker Node Components (Execution Layer)

Worker nodes run the actual workloads.



A. Kubelet (The Agent)

Role

Node-level agent running on every worker


Responsibilities

Watches API Server for assigned Pods

Starts containers via runtime

Performs health checks

Reports status back to API Server


📌 Kubelet follows a pull-based model (it watches, not waits)




B. Kube-Proxy (The Networker)

Role

Manages networking rules on each node


Responsibilities

Enables Service-to-Pod communication

Implements load balancing

Configures iptables / IPVS rules


📌 Without kube-proxy, services cannot route traffic




C. Container Runtime

Role

Executes container operations


Responsibilities

Pull images

Start / stop containers

Enforce resource isolation


Examples

containerd

CRI-O

Docker (legacy)





D. Pod (The Smallest Unit)

Definition A Pod is the smallest deployable object in Kubernetes.

Characteristics

Wraps one or more containers

Containers share:

Network namespace

Storage volumes


Ephemeral (Pods are replaced, not repaired)


📌 Kubernetes manages Pods, not containers directly


---

6. End-to-End Kubernetes Working Flow

Step-by-Step Execution

User → kubectl command
        ↓
API Server (validates request)
        ↓
ETCD (stores desired state)
        ↓
Controller Manager (detects mismatch)
        ↓
Scheduler (selects worker node)
        ↓
API Server updates assignment
        ↓
Kubelet on worker node detects pod
        ↓
Container Runtime starts container
        ↓
Kube-Proxy enables networking
        ↓
Application becomes accessible


