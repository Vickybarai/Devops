

## 1. Create ReplicationController and Service using Command

### ReplicationController (RC)

ReplicationController is a legacy Kubernetes controller whose main responsibility is to ensure a specified number of pod replicas are always running. If a pod crashes, the RC immediately creates a new pod to maintain availability.

#### Command to Create ReplicationController

```bash
kubectl run rc-demo --image=nginx --replicas=3 --restart=Always
```

Explanation (Line-by-line logic):

Component	Description	
`kubectl run`	CLI command to create Kubernetes resources	
`rc-demo`	Name of the ReplicationController	
`--image=nginx`	Container image used to create pods	
`--replicas=3`	Desired state: 3 pods must always run	
`--restart=Always`	Ensures controller-based behavior	

> Kubernetes stores this desired state in etcd, and the controller continuously reconciles actual state with desired state.

Verify ReplicationController

```bash
kubectl get rc
kubectl get pods
```

---

Service Creation (to expose RC pods)

A Service provides a stable network identity (IP + DNS) and load-balancing for pods created by RC.

Command to Create Service

```bash
kubectl expose rc rc-demo --type=NodePort --port=80
```

Explanation:

Component	Description	
`expose rc rc-demo`	Exposes pods managed by RC	
`--type=NodePort`	Makes application accessible externally	
`--port=80`	Service port mapped to container port	

Verify Service

```bash
kubectl get svc
```

---

2. Difference Between ReplicationController and ReplicaSet

Aspect	ReplicationController	ReplicaSet	
Status	Older and legacy controller used in early Kubernetes versions	Newer, recommended replacement for ReplicationController	
Selectors	Supports only equality-based selectors (`key=value`)	Supports set-based selectors (`In`, `NotIn`, `Exists`)	
Pod Management	Cannot manage pods created outside its selector strictly	More expressive and flexible pod selection	
Usage	Mostly used for learning and backward compatibility	Used internally by Deployments in production	
Rolling Updates	No rolling update support by default	Enables rolling updates via Deployment	
Scaling Strategies	Limited scaling and update strategies	Advanced scaling and update mechanisms	
Architecture	Directly manages pods	Manages pods more reliably via selector logic	

---

3. Difference Between ReplicationController and Deployment

Aspect	ReplicationController	Deployment	
Status	Legacy object, rarely used in modern clusters	Industry-standard object for application deployment	
Management	Manages pod replicas directly	Manages ReplicaSets, which then manage pods	
Rollback	No rollback functionality	Supports rollbacks to previous versions	
Updates	Manual update process required	Automated rolling updates supported	
History	No deployment history maintained	Maintains revision history	
Use Case	Suitable only for basic availability	Suitable for CI/CD and production workloads	
Scaling	Scaling is manual and basic	Advanced auto-scaling integration supported	

---

4. Difference Between ReplicaSet and Deployment

Aspect	ReplicaSet	Deployment	
Purpose	Ensures a fixed number of identical pods are running	Provides full application lifecycle management	
Scope	Handles only replica maintenance	Handles rollout, rollback, scaling, and updates	
Creation	Created rarely by users directly	Created directly by users in real-world scenarios	
Versioning	No versioning or rollout strategy	Supports rolling, recreate, and blue-green patterns	
Level	Low-level controller	High-level orchestration object	

---

5. Difference Between ReplicaSet and StatefulSet

Aspect	ReplicaSet	StatefulSet	
Application Type	Designed for stateless applications	Designed for stateful applications	
Pod Identity	Pod identity is interchangeable	Each pod has a unique identity	
Naming	Pod names have random suffixes	Pod names are sequential (`app-0`, `app-1`)	
Ordering	Pods can be created or deleted in any order	Pods follow strict creation and deletion order	
Storage	No persistent storage guarantee	Persistent storage attached per pod	
Scaling Behavior	Scaling does not preserve pod state	Scaling preserves pod state and identity	
Use Cases	Used for web servers, APIs, microservices	Used for databases, queues, distributed systems	
Analogy	Pods are treated as cattle	Pods are treated as pets	
Network Identity	No stable network identity	Stable DNS per pod guaranteed	

```