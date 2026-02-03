

## 0. Big Picture First (Mental Model)

```bash

Cluster
└── Namespace
├── Controller (Deployment / RS / RC / DS / STS)
│      └── Pods
│           └── Containers
└── Service (connects to Pods via labels)

```


### Beginner Mental Mapping

| Kubernetes Concept | Real-World Analogy |
|-------------------|-------------------|
| **Cluster** | The full Kubernetes system (like an entire company) |
| **Namespace** | Logical separation (departments inside the company) |
| **Controller** | Manager who ensures rules are followed ("I need 3 pods always running") |
| **Pod** | Actual execution unit (like an employee doing work) |
| **Container** | Application process (nginx, java app, node app) |
| **Service** | Reception desk → stable address that routes users to correct Pods |

> **Key Principle:** Kubernetes works on desired state — you declare what you want, controllers make it happen.

---

## 1. Namespace — Logical Environment Boundary

### What is it?

A Namespace is a logical isolation layer inside a Kubernetes cluster.

**Real-world analogy:** One cluster is like one office building; Namespaces are different departments or floors.

Each namespace has its own set of objects:
- Pods
- Services
- Deployments

Same names can exist in different namespaces without conflict.

### Why does it exist?

**Without namespaces:**
- All teams deploy into same space
- Name conflicts happen (app-service already exists)
- No isolation between environments

**Namespaces solve:**
- Environment separation (dev / test / prod)
- Access control (RBAC)
- Resource organization

### When should you use it?

- Multiple environments in one cluster
- Multiple teams sharing cluster
- Almost always in real production

### Commands

```bash
kubectl create ns prod
kubectl get ns
kubectl delete ns prod
```

YAML

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: prod
```

Verification

```bash
kubectl get ns
```

---

2. Pod — Smallest Deployable Unit

What is it?

A Pod is the smallest unit Kubernetes can create, schedule, and manage.

A Pod:
- Wraps one or more containers
- Gets one IP address
- Runs on one node only

> Kubernetes never talks to containers directly — it always manages Pods.

Why does Pod exist?

Containers alone cannot:
- Restart automatically
- Be scheduled on nodes
- Share networking cleanly

Pod acts as:
- A management wrapper
- A networking boundary
- A scheduling unit

When should you use a Pod?

Use for:
- Learning Kubernetes
- Testing images
- Debugging

Not for production directly

Production uses: `Deployment → ReplicaSet → Pod`

Commands

```bash
kubectl run pod1n --image=nginx
kubectl get pods -o wide
kubectl exec -it pod1n -- bash
kubectl logs pod1n
```

YAML

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: my-app
spec:
  containers:
  - name: my-c
    image: httpd
    ports:
    - containerPort: 80
```

Verification

```bash
kubectl describe pod my-pod
kubectl get pod my-pod -o wide
```

Pod Networking

Communication	How it Works	
Same Pod	`localhost`	
Pod → Pod	`PodIP:Port`	
Best Practice	Service DNS	

> Pod IPs are temporary — never rely on them.

---

3. Service — Stable Networking Layer

What is it?

A Service is a stable network abstraction that:
- Exposes Pods
- Load-balances traffic
- Provides stable IP + DNS

Why Service is mandatory?

Pods:
- Die and recreate
- IP changes every time

Service:
- Never changes
- Always points to correct Pods

When to use?

Always, whenever traffic needs to reach Pods.

Service Types

Type	Use Case	
ClusterIP	Internal communication	
NodePort	External (testing)	
LoadBalancer	Production access	

Commands

```bash
kubectl expose pod pod1n --port=80 --type=NodePort --name=my-svc
kubectl get svc
```

YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-svc
spec:
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
```

Verification

```bash
kubectl describe svc my-svc
```

---

4. ReplicationController (RC)

What is it?

Ensures fixed number of Pods are always running.

Why introduced?

If a Pod crashes, RC immediately creates a new one.

Current Status

> RC is legacy. Use ReplicaSet or Deployment instead.

When to use?

- Old clusters
- Interview theory

YAML

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: my-rc
spec:
  replicas: 3
  selector:
    app: cbz-app
  template:
    metadata:
      labels:
        app: cbz-app
    spec:
      containers:
      - name: my-c
        image: httpd
```

Verification

```bash
kubectl get rc
kubectl get pods -l app=cbz-app
```

---

5. ReplicaSet (RS)

What is it?

ReplicaSet is the modern replacement of RC.

Why better than RC?

- Supports set-based selectors
- More flexible

Real-world usage

> ReplicaSets are not created directly. They are managed by Deployments.

YAML

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-rs
spec:
  replicas: 6
  selector:
    matchLabels:
      app: rs-app
  template:
    metadata:
      labels:
        app: rs-app
    spec:
      containers:
      - name: my-c
        image: httpd
```

Verification

```bash
kubectl get rs
```

---

6. Deployment — Most Important Resource

What is it?

Deployment manages:
- ReplicaSets
- Rolling updates
- Rollbacks

Why Deployment exists?

Directly updating Pods causes downtime. Deployment ensures:
- Zero downtime
- Version control

When to use?

> All stateless production applications

YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: 123-app
  template:
    metadata:
      labels:
        app: 123-app
    spec:
      containers:
      - name: my-c
        image: httpd
```

Commands

```bash
kubectl rollout status deployment/my-deployment
kubectl rollout undo deployment/my-deployment
kubectl scale deployment my-deployment --replicas=5
```

---

7. DaemonSet

What is it?

Ensures one Pod runs on every node.

Why needed?

Some services must run on all nodes, like:
- Log collectors
- Monitoring agents

When to use?

Node-level services

YAML

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-ds
spec:
  selector:
    matchLabels:
      app: ds-app
  template:
    metadata:
      labels:
        app: ds-app
    spec:
      containers:
      - name: my-c
        image: httpd
```

---

8. StatefulSet

What is it?

Designed for stateful applications.

Why not Deployment?

Databases need:
- Fixed identity
- Stable storage
- Ordered startup

Key Features

Feature	StatefulSet	
Pod Names	sts-0, sts-1	
Storage	Persistent	
Order	Sequential	

YAML

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-sts
spec:
  serviceName: "my-svc"
  replicas: 3
  selector:
    matchLabels:
      app: sts-app
  template:
    metadata:
      labels:
        app: sts-app
    spec:
      containers:
      - name: my-c
        image: mysql
```

---

Universal Verification Checklist

```bash
kubectl apply -f file.yaml
kubectl get all
kubectl get pods -o wide
kubectl describe <resource>
kubectl get svc
```

---

> Core Principle: If you understand WHY each resource exists, Kubernetes becomes logical — not memorization.

```