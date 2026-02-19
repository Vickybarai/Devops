
# 1. Introduction to Kubernetes (K8s)

## Definition

Kubernetes (K8s) is an open-source container orchestration platform that automates the deployment, scaling, and lifecycle management of containerized workloads and services.

## History

- Originally developed by Google based on their internal system (Borg)
- Open-sourced in 2014
- Now maintained by the Cloud Native Computing Foundation (CNCF)

## Key Characteristics

- Manages containerized applications and services at scale
- Uses declarative configuration (you define what you want, not how to do it)
- Highly portable and extensible across cloud, hybrid, and on-prem environments
- Widely adopted and supported by all major cloud providers

---

# 2. Why Kubernetes? (Problem vs Solution)

## The Problem (Without Kubernetes)

- Containers deployed manually on individual machines
- No automated scaling during traffic spikes
- No self-healing if containers or nodes fail
- Manual updates cause downtime and risk
- Networking and service discovery are complex

## The Solution (What Kubernetes Provides)

| Capability | Explanation |
|------------|-------------|
| **Orchestration** | Schedules and manages hundreds or thousands of containers across nodes |
| **Auto Scaling** | Dynamically adjusts workloads based on CPU/memory demand |
| **Self-Healing** | Automatically restarts failed containers and reschedules pods |
| **Load Balancing** | Distributes traffic evenly across healthy pods |
| **Rolling Updates** | Deploys updates with zero downtime and rollback support |

---

# 3. Kubernetes Architecture Overview

## Cluster Model

Kubernetes operates using a cluster-based architecture.

- **Cluster:** A logical group of machines working together
- **Node:** A single machine (virtual or physical) inside the cluster

## Two Main Roles in a Cluster

### Control Plane (Master Node)

- Acts as the brain of Kubernetes
- Makes global decisions about the cluster
- Manages the desired state and scheduling
- Generally does not run user workloads

### Worker Nodes

- Act as the execution layer
- Run application workloads (Pods)
- Maintain and report workload health

---

## 1. Control Plane Components (Master Node)

### A. API Server (The Hub)

The API Server is the central management component of Kubernetes.

- It is the **only entry point** into the cluster
- All tools (kubectl, CI/CD systems, dashboards) communicate with K8s via the API Server

**Responsibilities:**
- Authentication & Authorization
- Request validation
- Updating cluster state in ETCD
- Exposing REST APIs for all cluster operations

> **If the API Server is down, the cluster cannot be controlled.**

---

### B. ETCD (The Database)

ETCD is a distributed, strongly consistent key-value store.

- Stores the entire cluster state
- Acts as the single source of truth

**Stores information such as:**
- Nodes and their status
- Pods and deployments
- ConfigMaps and Secrets
- Network and service metadata

> **Kubernetes reliability depends heavily on ETCD consistency.**

---

### C. Scheduler (The Planner)

The Scheduler decides where a pod should run.

- Watches for newly created pods without a node assignment
- Evaluates all available worker nodes

**Scheduling decisions are based on:**
- CPU and memory availability
- Node health
- Affinity / anti-affinity rules
- Taints and tolerations

> **Scheduler does NOT start pods. It only assigns them to nodes via the API Server.**

---

### D. Controller Manager (The Supervisor)

The Controller Manager runs multiple control loops.

- Continuously compares:
  - **Desired State** (stored in ETCD)
  - **Current State** (what is actually running)

When differences appear:
- Corrective actions are triggered automatically

**Common Controllers:**
- Replication Controller
- Node Controller
- Endpoint Controller

> **This component is responsible for Kubernetes self-healing behavior.**

---

## 2. Worker Node Components (Execution Layer)

### A. Kubelet (The Agent)

Each worker node runs a Kubelet, which is the node-level agent.

**Responsibilities:**
- Watches the API Server for assigned Pods
- Starts containers using the container runtime
- Continuously monitors container health
- Reports status back to the API Server

> **Kubelet ensures the node matches the desired state defined by the control plane.**

---

### B. Kube-Proxy (The Networker)

Kube-proxy manages networking rules on worker nodes.

**Functions:**
- Enables service-to-pod communication
- Implements load balancing
- Manages iptables or IPVS rules

> **Without kube-proxy, services cannot route traffic to pods.**

---

### C. Container Runtime

The Container Runtime is the component that actually runs containers.

**Responsibilities:**
- Pulls container images
- Creates and deletes containers
- Enforces resource isolation

**Common Runtimes:**
- containerd
- CRI-O
- Docker (via CRI)

---

### D. Pod (Smallest Deployable Unit)

A Pod is the smallest unit Kubernetes can deploy.

- Wraps one or more containers
- Containers in a pod:
  - Share the same network namespace
  - Can share storage volumes

**Key Characteristics:**
- Pods are ephemeral
- If a pod dies, it is replaced, not repaired

---

# Kubernetes Workflow (Simple & Easy to Understand)

This section explains how Kubernetes works internally, step by step, in very simple terms.

Think of Kubernetes as a manager that constantly checks whether your application is running exactly the way you asked.

---

## Step 1: User Defines Desired State

The workflow always starts with the user.

When you run a command like:

```bash
kubectl apply -f deployment.yaml
```

You are telling Kubernetes:

> "I want this application running with these settings (image, replicas, resources)."

This configuration is called the Desired State.

---

Step 2: API Server Receives the Request

The request is sent to the API Server

API Server verifies:
- Who you are (authentication)
- Whether you are allowed (authorization)
- Whether the YAML is valid

Once validated, the request is accepted.

---

Step 3: Desired State Stored in ETCD

API Server saves the configuration in ETCD

ETCD becomes the single source of truth

At this point, Kubernetes knows what should exist, but nothing is running yet.

---

Step 4: Controller Manager Takes Action

Controller Manager constantly compares:
- Desired State (from ETCD)
- Current State (what is actually running)

If it finds something missing (for example, 3 replicas requested but 0 running):
- It creates Pod objects via the API Server

---

Step 5: Scheduler Selects a Worker Node

Newly created Pods do not have a node assigned

Scheduler looks at all available worker nodes

It selects the best node based on:
- CPU and memory availability
- Node health
- Scheduling rules

The Scheduler then updates the API Server:

> "This Pod should run on this node."

---

Step 6: Kubelet Starts the Pod

Each worker node runs a Kubelet

Kubelet continuously watches the API Server

When it sees a Pod assigned to its node:
- It instructs the Container Runtime to pull the image
- Starts the container
- Ensures the Pod is running as defined

---

Step 7: Networking via Kube-proxy

Kube-proxy configures network rules on the node

Enables:
- Pod-to-pod communication
- Service-to-pod traffic
- Load balancing

Now the application becomes reachable.

---

Step 8: Continuous Monitoring & Self-Healing

Kubernetes never stops checking.

- If a container crashes → Kubelet restarts it
- If a Pod dies → Controller creates a new one
- If a Node fails → Pods are rescheduled
- If traffic increases → Auto-scaling can add Pods

This loop runs continuously to maintain stability.

---

Simple One-Line Workflow Summary

> User defines desired state → Control Plane decides → Worker Node executes → Kubernetes keeps fixing continuously

---

Kubernetes operates on a control-loop model:

> You declare the desired state, Kubernetes continuously works to maintain it.

This design makes Kubernetes:
- Highly resilient
- Self-healing
- Scalable

```