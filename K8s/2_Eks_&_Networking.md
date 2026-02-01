## 📌 What is Amazon EKS?

Amazon EKS (Elastic Kubernetes Service) is a managed Kubernetes service where AWS manages the Control Plane (API Server, Scheduler, etcd), and you manage Worker Nodes and Applications.

> **You never manage or SSH into the Kubernetes master nodes in EKS.**

---

## 🧠 High-Level Architecture

**Control Plane (Managed by AWS)**
- API Server
- Scheduler
- Controller Manager
- etcd

**Worker Nodes (Managed by You)**
- EC2 instances
- Run Pods and containers

---

## 🛠 Tools Used

- **AWS Console** – Cluster and node creation
- **AWS CloudShell** – kubectl + AWS CLI (recommended)
- **Killercoda** – Practice Kubernetes labs

---

## 🟢 STEP 1: Create EKS Cluster (Control Plane)

> Always start with the EKS Cluster. Worker nodes are added later.

### Steps

1. Open AWS Console → EKS
2. Click **Add cluster** → **Create**
3. Enter:
   - **Cluster name:** `my-eks-cluster`
   - **Kubernetes version:** Default (example: 1.34)

AWS now asks for permissions → IAM role is required.

---

## 🟢 STEP 2: Create IAM Role for EKS Cluster

> This role allows EKS to manage AWS resources on your behalf.

### Steps

1. Go to IAM → Roles → **Create role**
2. **Trusted entity:** AWS Service
3. **Use case:** EKS
4. Select: **EKS – Cluster**
5. Attach policy:
   - `AmazonEKSClusterPolicy`
6. **Role name:** `eks-cluster-role`

> **Why needed?**  
> Enables EKS to manage networking, security groups, and logging.

---

## 🟢 STEP 3: Complete EKS Cluster Configuration

Go back to EKS cluster creation page.

### Configuration

- **IAM Role:** `eks-cluster-role`
- **VPC:** Default VPC (for beginners)
- **Subnets:**
  - Select Public + Private
  - Minimum 2 AZs
- **Security Group:** Default
- **Endpoint Access:**
  - Public OR Public + Private (recommended)

Click **Create Cluster**

⏳ **Creation time:** 8–12 minutes

✅ **Control Plane is ready**  
❌ **No worker nodes yet**

---

## 🟢 STEP 4: Create Node Group (Worker Nodes)

> Pods always run on Worker Nodes, not on the control plane.

### Steps

1. EKS → Your Cluster → **Compute**
2. Click **Add Node Group**
3. **Node group name:** `eks-worker-nodes`

---

### 🔐 Node IAM Role (Mandatory)

Attach these three policies:

- `AmazonEKSWorkerNodePolicy`
- `AmazonEKS_CNI_Policy`
- `AmazonEC2ContainerRegistryReadOnly`

> **Without these policies, nodes will not join the cluster.**

---

### ⚙ Node Configuration

- **AMI:** Amazon Linux 2
- **Instance type:** `t3.medium`
- **Scaling:**
  - Desired: `2`
  - Min: `1`
  - Max: `3`
- Enable **Node Auto-Repair**
- Select same subnets as cluster

**Create Node Group**  
⏳ **Time:** 5–7 minutes

---

## 🟢 STEP 5: Access the Cluster (kubectl Setup)

### Option A: AWS CloudShell (Recommended)

CloudShell already has AWS CLI + kubectl.

```bash
aws eks update-kubeconfig --name my-eks-cluster --region ap-south-1
```

What this command does:
- Fetches cluster details
- Updates kubeconfig
- Authenticates kubectl using IAM

Verify:

```bash
kubectl get nodes
```

---

Option B: Killercoda

kubeconfig is usually preconfigured. Directly run:

```bash
kubectl get nodes
```

> `aws eks update-kubeconfig` is not required unless specified.

---

🟢 STEP 6: Core kubectl Commands

```bash
kubectl get nodes
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

> `kubectl` always communicates with the API Server, never directly with nodes.

---

🟢 STEP 7: Kubernetes Objects

Pod
- Smallest deployable unit
- One or more containers
- Gets its own IP
- Ephemeral

---

Service

Exposes Pods and provides stable networking.

Types:
- ClusterIP – Internal access only
- NodePort – NodeIP:30000–32767
- LoadBalancer – AWS ELB/NLB

```bash
kubectl expose pod my-pod --port 80 --type NodePort --name my-np-svc
kubectl expose pod my-pod --port 80 --type LoadBalancer --name my-lb-svc
```

---

Deployment
- Manages ReplicaSets
- Rolling updates
- Rollbacks

---

ReplicaSet / ReplicationController
- Ensures desired number of Pods are running

---

StatefulSet
- Stable identity + storage
- Used for databases

---

DaemonSet
- One Pod per node
- Logging, monitoring agents

---

ConfigMap & Secret
- Externalize configuration
- Secrets store sensitive data

---

PV & PVC
- Persistent storage
- Independent of Pod lifecycle

---

🟢 STEP 8: Networking Basics

Intra-Pod Communication
- Same Pod
- Same IP
- Use `localhost`

Inter-Pod Communication
- Different Pods
- Different IPs
- Use `PodIP:Port`
- Pod IPs are temporary

---

Why Services Are Required

Pod IPs change. Services provide:
- Stable IP
- DNS
- Load balancing

---

🧪 Sample Test Commands

```bash
kubectl run my-pod --image=httpd
kubectl get pods -o wide
kubectl get svc
```

---

🎯 Interview Summary

> "In Amazon EKS, AWS manages the Kubernetes control plane. We create the EKS cluster first, assign IAM roles for permissions, then add EC2-based worker nodes. Access is configured using `aws eks update-kubeconfig`, and applications are exposed using Kubernetes Services."

```