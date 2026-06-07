
# 🚀 Mastering Amazon EKS (Elastic Kubernetes Service)

## 📚 Table of Contents
1. [Overview](#-1-overview)
2. [High-Level Architecture](#-high-level-architecture)
3. [Deployment Models](#-2-eks-deployment-models)
4. [IAM Roles Setup](#-3-iam-roles)
5. [Traditional Cluster Creation](#-4-traditional-eks-cluster-creation)
6. [Managed Node Groups](#-5-create-managed-node-group)
7. [EKS Auto Mode](#-6-eks-auto-mode-workflow)
8. [Configuration & Access](#-7-configure-kubectl)
9. [Kubernetes Operations](#-8-core-kubernetes-commands)
10. [Troubleshooting](#-11-troubleshooting)
11. [Summary](#-interview-summary)

---

## 📌 1. Overview

### What is Amazon EKS?
Amazon Elastic Kubernetes Service (EKS) is a **fully managed** Kubernetes service. AWS handles the heavy lifting of the Kubernetes Control Plane, allowing you to focus on your applications.

### Responsibility Split
| Component | Managed By | Details |
| :--- | :--- | :--- |
| **Control Plane** | **AWS** | API Server, ETCD, Scheduler, Controller Manager. No SSH access allowed. |
| **Worker Nodes** | **User** | EC2 Instances (Managed/Self-Managed), Fargate, or Auto Mode Nodes. |

### Interaction Tools
You interact with the EKS Control Plane via:
- `kubectl` (CLI)
- AWS CLI
- EKS API
- AWS Console / CloudShell

---

## 🏗 High-Level Architecture

```text
   User (You)
      │
      │ kubectl / AWS CLI
      ▼
─────────────────────────────────────
│  EKS Control Plane (Managed by AWS) │
│                                     │
│  ├── API Server                     │
│  ├── ETCD (Cluster Data)            │
│  ├── Scheduler                      │
│  └── Controller Manager             │
─────────────────────────────────────
      │
      ▼
─────────────────────────────────────
│  Worker Nodes (Managed by You)      │
│                                     │
│  ├── Node 1 (Pod-1, Pod-2)          │
│  ├── Node 2 (Pod-3, Pod-4)          │
│  └── Node 3 (Pod-5)                 │
─────────────────────────────────────
```

---

## 🛠 Tools Used
- **AWS Console:** For cluster creation and management.
- **AWS CLI / CloudShell:** For infrastructure commands.
- **kubectl:** The standard command-line tool for Kubernetes.
- **Killercoda:** Recommended environment for practice.

---

## 📌 2. EKS Deployment Models

AWS offers two primary approaches to creating clusters:

### Option 1: Traditional EKS (Recommended for Learning)
You manually define the cluster and the node groups.
- **Flow:** `Cluster` → `Node Group` → `EC2 Instances`
- **Management:** You manage Cluster, Node Groups, and Scaling.
- **Best For:** Interviews, deep learning, understanding K8s internals.

### Option 2: EKS Auto Mode
AWS automates the provisioning of nodes, storage, and networking.
- **Flow:** `Cluster` → `AWS Automatically Creates Nodes`
- **Management:** AWS manages infrastructure; you deploy applications.
- **Best For:** Production automation, reducing operational overhead.
- **Note:** Hides many internal details, not ideal for beginners.

---

## 📌 3. IAM Roles

Before creating a cluster, you must set up two specific IAM roles.

### A. Cluster Role (`eks-cluster-role`)
Used by the Kubernetes control plane to make calls to other AWS services on your behalf.

**Policies to Attach:**
- `AmazonEKSClusterPolicy`
- `AmazonEKSComputePolicy`
- `AmazonEKSNetworkingPolicy`
- `AmazonEKSLoadBalancingPolicy`
- `AmazonEKSBlockStoragePolicy`

### B. Node Role (`eks-node-role`)
Used by the worker nodes (Kubelet and CNI plugin) to make calls to AWS APIs.

**Policies to Attach:**
- `AmazonEKSWorkerNodePolicy`
- `AmazonEKS_CNI_Policy`
- `AmazonEC2ContainerRegistryReadOnly`
- `AmazonElasticContainerRegistryPublicReadOnly`

---

## 📌 4. Traditional EKS Cluster Creation

> **⚠️ IMPORTANT:** Select **"Custom Configuration"**. Do **NOT** select "Quick Configuration" if you want to learn the architecture and manage Node Groups manually.

### Step 1: Navigate to EKS
1. Open AWS Console.
2. Go to **EKS** service.
3. Click **Create Cluster**.

### Step 2: Configure Metadata
- **Name:** `my-eks-cluster`
- **Kubernetes Version:** Select the latest stable version.
- **Cluster Service Role:** Select `eks-cluster-role`.

### Step 3: Networking
- **VPC:** Select `Default VPC`.
- **Subnets:** Select at least **2 Availability Zones** (Public + Private subnets).
- **Security Group:** `Default`.
- **Cluster Endpoint Access:** `Public and Private` (Recommended for learning).

### Step 4: Create
1. Click **Create**.
2. Wait **10–15 minutes**.
3. Status must change to **Active**.

---

## 📌 5. Create Managed Node Group

Once the cluster is active, you need compute capacity.

### Steps
1. Go to your Cluster → **Compute** tab.
2. Click **Add Node Group**.

### Configuration
- **Name:** `eks-worker-nodes`
- **Node IAM Role:** Select `eks-node-role`.

### Compute Settings (Free Tier Friendly)
- **Instance Type:** `t3.micro`
  - *Note:* Avoid `t3.medium` if on Free Tier to prevent `InstanceLaunchFailures`.
- **Scaling:**
  - Desired Size: `1`
  - Min Size: `1`
  - Max Size: `2`

### Finalize
1. Click **Create**.
2. Wait **5–10 minutes**.

---

## 📌 6. EKS Auto Mode Workflow

If you choose **"Quick Configuration"** during cluster creation, you are using EKS Auto Mode.

**How it works:**
1. You select the Cluster Role and Node Role immediately.
2. AWS automatically provisions nodes without you creating a Node Group manually.

**Why does AWS ask for a Node Role twice?**
- **Auto Mode:** Uses the role provided during creation to manage nodes automatically.
- **Managed Node Groups:** If you switch to manual management later, you define a specific Node Group role.
These are distinct systems. It is normal for the prompts to look similar.

---

## 📌 7. Configure kubectl

To interact with your cluster from the terminal, update your kubeconfig.

**Using AWS CloudShell:**

```bash
aws eks update-kubeconfig \
  --name my-eks-cluster \
  --region ap-south-1
```

**Verify Connection:**
```bash
kubectl get nodes
```
*Expected Output:* Nodes listed with status `Ready`.

---

## 📌 8. Core Kubernetes Commands

### Cluster Information
```bash
kubectl get nodes          # List all worker nodes
kubectl get pods           # List all pods in default namespace
kubectl get pods -o wide   # List pods with IP and Node info
```

### Debugging
```bash
kubectl describe pod <pod-name>   # Detailed events/status of a pod
kubectl logs <pod-name>           # Print logs of a container
```

### Operations
```bash
kubectl delete pod <pod-name>                     # Delete a pod
kubectl exec -it <pod-name> -- /bin/bash          # Access shell inside pod
```

---

## 📌 9. Deploy First Pod

**Deploy an Nginx web server:**
```bash
kubectl run nginx --image=nginx
```

**Check status:**
```bash
kubectl get pods
```

---

## 📌 10. Services (Networking)

### 1. ClusterIP (Internal)
Accessible only within the cluster.
```bash
kubectl expose pod nginx --port=80
```

### 2. NodePort (External via Node IP)
Exposes the service on each Node’s IP at a static port.
```bash
kubectl expose pod nginx --port=80 --type=NodePort
```

### 3. LoadBalancer (External via AWS ELB)
Provisions an AWS Load Balancer to route traffic to the service.
```bash
kubectl expose pod nginx --port=80 --type=LoadBalancer
```

---

## 📌 11. Troubleshooting

### Issue: No Nodes Found (`kubectl get nodes` returns nothing)
**Possible Causes:**
- Node Group creation failed.
- IAM Role missing permissions.
- Networking issues (Subnets).

### Issue: `NodeCreationFailure`
**Cause 1: Wrong Instance Type**
- **Error:** The specified instance type is not eligible for Free Tier.
- **Fix:** Use `t3.micro` instead of `t3.medium`.

**Cause 2: Missing IAM Policies**
- **Fix:** Ensure `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, and `AmazonEC2ContainerRegistryReadOnly` are attached to the Node Role.

**Cause 3: Private Subnet without NAT Gateway**
- **Error:** Nodes cannot reach EKS public APIs to bootstrap.
- **Fix:** Use Public Subnets for learning, or configure a NAT Gateway for private subnets.

---

## 📌 12. Complete Workflow Summary

```text
1. Create IAM Roles (Cluster & Node)
            ↓
2. Create EKS Cluster (Custom Config)
            ↓
3. Wait for Status: Active
            ↓
4. Create Managed Node Group (t3.micro)
            ↓
5. Wait for Status: Ready
            ↓
6. Update kubeconfig (aws eks update-kubeconfig...)
            ↓
7. Verify Nodes (kubectl get nodes)
            ↓
8. Deploy Application (kubectl run nginx...)
            ↓
9. Expose Service (kubectl expose... --type=LoadBalancer)
            ↓
10. Access Application
```

---

## 🎯 Interview Summary

Amazon EKS is a managed Kubernetes service where **AWS manages the Control Plane** (API Server, ETCD, Scheduler, Controller Manager). Users manage **Worker Nodes** which can be EC2 instances (Managed Node Groups) or serverless (Fargate/Auto Mode). Access is configured via `kubectl` and IAM authentication, and applications are exposed using standard Kubernetes Services like **ClusterIP**, **NodePort**, and **LoadBalancer** (which integrates with AWS ELB/NLB).
