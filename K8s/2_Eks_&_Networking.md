
# 🚀 Amazon EKS (Elastic Kubernetes Service)
## 📌 1. Amazon EKS Overview

**Definition:**  
Amazon Elastic Kubernetes Service (EKS) is a fully managed Kubernetes service by AWS that handles all **control plane components** for you.

### High-Level Architecture

**Control Plane (Managed by AWS):**
- API Server
- ETCD (Cluster state store)
- Scheduler
- Controller Manager

**Worker Nodes (User-managed):**
- EC2 instances
- Node Groups
- Fargate

**Principle:**  
> You **never SSH into the control plane**; all interaction is via `kubectl` or API.

**Learning Tools:**  
- Minikube, Killercoda (for offline practice)

---

## 🛠 Tools Used

- **AWS Console** – Cluster and node creation
- **AWS CloudShell** – kubectl + AWS CLI (recommended)
- **Killercoda** – Practice Kubernetes labs

---

## 🟢 2. EKS Cluster Creation Step-by-Step

### Phase 1 Phase 1: Preparation

**IAM Roles:**

| Role Type | Required Policies |
|-----------|------------------|
| **Cluster Role** | `AmazonEKSClusterPolicy` |
| **Node Role** | `AmazonEKSWorkerNodePolicy` |
| | `AmazonEC2ContainerRegistryReadOnly` |
| | `AmazonEKS_CNI_Policy` |

**Networking Requirements:**
- VPC with **public & private subnets**
- Security Groups for cluster & nodes
- Internet Gateway & proper Route Tables

> **Tip:** Use default subnets and security groups if unsure; AWS EKS will configure basic networking automatically.

---

### Phase 2: Create Control Plane (STEP 1-3)

> Always start with the EKS Cluster. Worker nodes are added later.

#### Step-by-Step:

1. Open AWS Console → EKS → **Add cluster** → **Create**
2. Provide:
   - **Cluster Name:** `my-eks-cluster`
   - **Kubernetes Version:** Default (example: 1.34)
   - **IAM Role:** `eks-cluster-role` (Cluster Role with `AmazonEKSClusterPolicy`)
   - **VPC & Subnets:** Default VPC or existing (Public + Private, Minimum 2 AZs)
   - **Security Group:** Default
   - **Endpoint Access:** Public OR Public + Private (recommended)
3. Click **Create Cluster**

⏳ **Creation time:** 8–12 minutes

✅ **Control Plane is ready**  
❌ **No worker nodes yet**

> **Why IAM Role needed?**  
> Enables EKS to manage networking, security groups, and logging on your behalf.

---

### Phase 3: Access Cluster (STEP 5)

From your laptop, CloudShell, or EC2 instance:

#### Option A: AWS CloudShell (Recommended)

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

Option B: Killercoda

kubeconfig is usually preconfigured. Directly run:

```bash
kubectl get nodes
```

> `aws eks update-kubeconfig` is not required unless specified.

---

Phase 4: Create Node Group (Worker Nodes) (STEP 4)

> Pods always run on Worker Nodes, not on the control plane.

Steps:

1. EKS → Your Cluster → Compute → Add Node Group
2. Node group name: `eks-worker-nodes`
3. Node IAM Role: Attach these three mandatory policies:
   - `AmazonEKSWorkerNodePolicy`
   - `AmazonEKS_CNI_Policy`
   - `AmazonEC2ContainerRegistryReadOnly`

> Without these policies, nodes will not join the cluster.

Node Configuration:

- AMI: Amazon Linux 2
- Instance type: `t3.small`
- Scaling:
  - Desired: `2`
  - Min: `1`
  - Max: `3`
- Enable Node Auto-Repair and Auto-Update
- Select same subnets as cluster

Create Node Group

⏳ Time: 5–7 minutes

> Important Notes:
`AmazonEKSWorkerNodePolicy`
- `AmazonEKS_CNI_Policy`
- `AmazonEC2ContainerRegistryReadOnly`

> Without these policies, nodes will not join the cluster.

Node Configuration:

- AMI: Amazon Linux 2
- Instance type: `t3.medium`
- Scaling:
  - Desired: `2`
  - Min: `1`
  - Max: `3`
- Enable Node Auto-Repair and Auto-Update
- Select same subnets as cluster

Create Node Group

⏳ Time: 5–7 minutes

> Important Notes:
- Ensure nodes are in proper subnets for networking
- kube-proxy is installed automatically for service networking

---

🟢 3. Core kubectl Commands

```bash
kubectl get nodes                    # List all nodes
kubectl get pods                     # List all pods
kubectl get pods -o wide             # View pods with node and IP info
kubectl describe pod <pod-name>      # Detailed pod information
kubectl logs <pod-name>              # View pod logs
kubectl exec -it my-pod -- bash      # Enter pod terminal
kubectl delete pod my-pod            # Delete a pod
```

> `kubectl` always communicates with the API Server, never directly with nodes.

---

## 🟢 4. Kubernetes Objects

| Object | Purpose |
|--------|---------|
| **Pod** | Smallest deployable unit; runs one or more containers; ephemeral |
| **Deployment** | Manages pods and rolling updates; enables rollbacks |
| **ReplicaSet** | Ensures a specific number of pod replicas are running |
| **Service** | Provides stable networking & discovery for ephemeral pods |
| **Namespace** | Logical separation of resources |
| **StatefulSet** | For stateful applications with stable identity + storage |
| **DaemonSet** | Ensures one pod per node (logging, monitoring agents) |
| **ConfigMap** | Stores configuration data (externalize configuration) |
| **Secret** | Stores sensitive information/credentials |
| **PV / PVC** | Persistent storage for pods; independent of Pod lifecycle |

---

### Pod Details

**Characteristics:**
- Smallest deployable unit in Kubernetes
- **Ephemeral:** replaced if deleted
- Wraps one or more containers
- Containers share network namespace & volumes
- Gets its own IP

**Networking:**
- **Intra-pod:** `localhost` or container port
- **Inter-pod:** `PodIP:Port` (Pod IPs are temporary)

---

### Service Types

Services provide stable IP/DNS to access ephemeral pods.

| Type | Purpose | Command |
|------|---------|---------|
| **ClusterIP** | Internal cluster access (default) | `kubectl expose pod my-pod --port 80 --target-port 80` |
| **NodePort** | Node IP + static port (30000-32767); mainly for testing/debugging | `kubectl expose pod my-pod --port 80 --type NodePort --name my-np-svc` |
| **LoadBalancer** | Public access via cloud LB (AWS ELB/NLB); requires Security Group rules for HTTP/TCP 80 | `kubectl expose pod my-pod --port 80 --type LoadBalancer --name my-lb-svc` |

> **Note:** `port` = service port, `targetPort` = pod/container port
---

🟢 5. Networking Basics

Intra-Pod Communication
- Same Pod
- Same IP
- Use `localhost`

Inter-Pod Communication
- Different Pods
- Different IPs
- Use `PodIP:Port`
- Pod IPs are temporary

Why Services Are Required

Pod IPs change. Services provide:
- Stable IP
- DNS
- Load balancing

---

🧪 Sample Test Commands

```bash
# Create and expose a pod
kubectl run my-pod --image=httpd
kubectl expose pod my-pod --port 80 --type NodePort --name my-np-svc

# Verify
kubectl get pods -o wide
kubectl get svc
curl <pod-ip>  # Test connectivity
```

---

✅ 6. Summary Workflow

1. Prepare IAM roles & networking
2. Create Control Plane (EKS Cluster)
3. Access cluster via kubectl (`aws eks update-kubeconfig`)
4. Create Node Group (Worker Nodes)
5. Deploy Pods & Services
6. Kubernetes automatically handles scaling, networking, and health

---

🎯 Interview Summary

> "In Amazon EKS, AWS manages the Kubernetes control plane. We create the EKS cluster first, assign IAM roles for permissions, then add EC2-based worker nodes. Access is configured using `aws eks update-kubeconfig`, and applications are exposed using Kubernetes Services."

```