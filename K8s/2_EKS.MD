1. Amazon EKS Overview

Definition: Amazon Elastic Kubernetes Service (EKS) is a fully managed Kubernetes service by AWS that handles all control plane components for you.

Control Plane (Managed by AWS):

API Server

ETCD (Cluster state store)

Scheduler

Controller Manager


Worker Nodes (User-managed):

EC2 instances

Node Groups

Fargate


Principle: You never SSH into the control plane; interaction is via kubectl or API.

Learning Tools: Minikube, Killercoda for offline practice.


---

2. EKS Cluster Creation Step-by-Step

Phase 1: Preparation

IAM Roles:

Cluster Role: AmazonEKSClusterPolicy

Node Role:

AmazonEKSWorkerNodePolicy

AmazonEC2ContainerRegistryReadOnly

AmazonEKS_CNI_Policy



Networking Requirements:

VPC with public & private subnets

Security Groups for cluster & nodes

Internet Gateway & proper Route Tables


> Tip: Use default subnets and security groups if unsure; AWS EKS will configure basic networking automatically.



Phase 2: Create Control Plane

1. Navigate to AWS EKS Console → Create Cluster


2. Provide:

Cluster Name

Kubernetes Version (default recommended)

IAM Role (Cluster Role)

VPC & Subnets (existing/default)



3. AWS provisions control plane components automatically


4. Expected Time: ~10 minutes



Phase 3: Access Cluster

From laptop, CloudShell, or EC2 instance:

aws eks update-kubeconfig --name <cluster-name> --region <region>
kubectl get nodes -o wide

> Configures kubectl to communicate with your EKS cluster.



Phase 4: Create Node Group (Worker Nodes)

1. Select Node Role and instance type (default: t3.medium)


2. Configure scaling (min, desired, max)


3. Enable auto-repair and auto-update


4. Nodes automatically join cluster



> Important Notes:

Node Role must include EC2 Worknode, CNI, and ECR read-only policies

Ensure proper subnets for networking

kube-proxy is installed automatically for service networking





---

3. Kubernetes Objects

Object	Purpose

Pod	Runs one or more containers
Deployment	Manages pods and rolling updates
ReplicaSet	Ensures a specific number of pod replicas
Service	Provides stable networking & discovery
Namespace	Logical separation of resources
StatefulSet	For stateful applications
DaemonSet	One pod per node
ConfigMap	Stores configuration data
Secret	Stores sensitive information/credentials
PV / PVC	Persistent storage for pods



---

4. Pods & Commands

Characteristics:

Smallest deployable unit

Ephemeral: replaced if deleted

Wraps one or more containers

Containers share network namespace & volumes


Networking:

Intra-pod: localhost or container port

Inter-pod: podIP:port


Common Commands:

kubectl run my-pod --image=httpd          # Create a pod
kubectl get pods -o wide                  # View pods with node and IP info
kubectl exec -it my-pod -- bash           # Enter pod terminal
kubectl delete pod my-pod                 # Delete a pod
curl <pod-ip>                             # Test connectivity


---

5. Kubernetes Services & Networking

Definition: Services provide stable IP/DNS to access ephemeral pods.

Type	Purpose	Command

ClusterIP	Internal cluster access (default)	kubectl expose pod my-pod --port 80 --target-port 80
NodePort	Node IP + static port (30000-32767)	kubectl expose pod my-pod --port 80 --type NodePort --name my-np-svc
LoadBalancer	Public access via cloud LB	kubectl expose pod my-pod --port 80 --type LoadBalancer --name my-lb-svc


> Notes:

NodePort is mainly for testing/debugging

LoadBalancer requires Security Group rules for public access (HTTP/TCP 80)

port = service port, targetPort = pod/container port





---

> ✅ Summary Workflow:

1. Prepare IAM roles & networking


2. Create Control Plane (EKS Cluster)


3. Access cluster via kubectl


4. Create Node Group (Worker Nodes)


5. Deploy Pods & Services


6. Kubernetes automatically handles scaling, networking, and health



