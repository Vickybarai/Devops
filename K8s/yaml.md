

# Kubernetes YAML Manifest Writing Guide

This document contains detailed lecture notes and explanations for writing Kubernetes YAML files (Manifests). It covers the core concepts of API versions, basic objects like Pods and Services, Controllers (RC, RS, Deployment, StatefulSet, DaemonSet), Storage (PV/PVC), and Health Probes.

## Table of Contents
1.  [Understanding API Versions](#understanding-api-versions)
2.  [Basic Pods](#basic-pods)
3.  [Services](#services)
4.  [Controllers](#controllers)
    *   [Replication Controller](#replication-controller)
    *   [Replica Set](#replica-set)
    *   [Deployment](#deployment)
    *   [Stateful Set](#stateful-set)
    *   [Daemon Set](#daemon-set)
5.  [Storage (PV & PVC)](#storage-pv--pvc)
6.  [Health Probes](#health-probes)

---

## Understanding API Versions

Kubernetes identifies objects via libraries. The version of the library used is called the **API Version**.

*   **Basic Version (`v1`):** Used for core objects like Pods and Services.
*   **Advanced Version (`apps/v1`):** Used for controllers like Deployments, ReplicaSets, and StatefulSets.
*   **Specialized Versions:** Different versions exist for Storage, Networking, and Autoscaling.

### Finding API Versions
To find the correct API version, Kind, and whether a resource is namespace-specific, use the command:
```bash
kubectl get api-resources
```
*   **NAME:** Shortname of the resource.
*   **APIVERSION:** The version to use in YAML.
*   **NAMESPACED:** Indicates if the object must be created inside a namespace (true) or cluster-wide (false).

---

## Basic Pods

A Pod is the smallest deployable unit. It wraps containers.

*   **File Naming:** You can name the file anything, but it must end with `.yaml` or `.yml` (e.g., `pod.yaml`).
*   **Command Analogy:** Writing a YAML file is equivalent to writing a CLI command (e.g., `docker run -d -p 80:80 nginx`). Every field in YAML corresponds to a flag in the command.

### Pod YAML Structure
```yaml
apiVersion: v1          # Basic version for Pod
kind: Pod               # Type of object
metadata:
  name: my-pod          # Mandatory: Name of the pod
  labels:               # Optional but recommended for identification
    app: myapp
spec:
  containers:           # 's' because multiple containers can exist in one pod
    - name: my-container    # Mandatory if multiple containers, optional if single
      image: nginx          # Image to run
      ports:
        - containerPort: 80 # Port inside the container
```

**Key Points:**
*   **Metadata:** Must contain a `name`.
*   **Spec (Specification):** Defines what the object does. For a Pod, it creates containers.
*   **Containers:** A list (denoted by `-`).
*   **Keywords:** Be careful with keywords like `ports` (list) vs `containerPort` (integer).

---

## Services

A Service exposes an application (Pod) to the network.

### Service YAML Structure
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  ports:                 # List because a service can expose multiple ports
    - port: 80           # Port on the Service (LoadBalancer/NodePort/ClusterIP)
      targetPort: 80     # Port on the Container (Pod)
  selector:              # How to find the Pods to expose
    app: myapp           # Uses Labels, NOT Names
```

**Key Points:**
*   **Port Mapping:** Similar to firewall port forwarding. `port` is the entry point, `targetPort` is the destination on the container.
*   **Selector:** Services identify Pods using **Labels**, not Pod names.
    *   *Why?* Multiple pods can have different names but the same label (e.g., `app: myapp`). The service will route traffic to all of them.
*   **Multiple Ports:** You can expose a service on multiple ports (e.g., 80 for HTTP, 443 for HTTPS) mapping to different target ports.

---

## Controllers

Controllers manage the state of pods (e.g., ensuring a specific number of replicas are running).

### Replication Controller (RC)
*   **API Version:** `v1`
*   **Function:** Manages replicas (similar to Auto Scaling Groups).
*   **Selector Type:** Equality Based.

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: my-rc
  labels:
    app: myapp
spec:
  replicas: 3             # How many pods we want
  selector:
    app: myapp            # Links RC to Pods using labels
  template:               # Pod Template (Like Launch Config)
    metadata:
      labels:
        app: myapp        # Labels MUST match the selector
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
```

### Replica Set (RS)
*   **API Version:** `apps/v1`
*   **Function:** Manages replicas.
*   **Selector Type:** Set Based (Can select via `matchLabels` or `matchExpressions`).

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-replicaset
spec:
  replicas: 3
  selector:
    matchLabels:          # Set based selection
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - image: nginx
          name: nginx
          ports:
            - containerPort: 80
```
*   **Difference from RC:** RS supports set-based selectors (e.g., `matchExpressions` with `In`, `NotIn` operators), making it more flexible.

### Deployment
*   **API Version:** `apps/v1`
*   **Function:** Manages ReplicaSets. Used for deploying stateless applications. Supports update strategies.
*   **Key Addition:** `strategy` (RollingUpdate, Recreate).

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: myapp
  template:               # Entire ReplicaSet spec goes here
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - image: nginx
          name: nginx
          ports:
            - containerPort: 80
```
*   **Namespace:** You can specify `namespace: <name>` in metadata to deploy in specific namespaces (e.g., `dev`, `prod`).

### Stateful Set (STS)
*   **API Version:** `apps/v1`
*   **Function:** Used for stateful applications (Databases).
*   **YAML Structure:** Almost identical to ReplicaSet/Deployment.
*   **Operational Differences:**
    *   **Pod Names:** Sequential (e.g., `web-0`, `web-1`, `web-2`).
    *   **Updates/Deletes:** Happen sequentially (one by one), not all at once.
    *   **Networking:** Requires stable networking to sync data.

### Daemon Set
*   **API Version:** `apps/v1`
*   **Function:** Ensures one copy of a Pod runs on **every node** in the cluster.
*   **Use Case:** Monitoring agents, logging agents.

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-daemonset
spec:
  selector:
    matchLabels:
      app: myagent
  template:
    metadata:
      labels:
        app: myagent
    spec:
      containers:
        - name: agent
          image: agent-image
```
*   **Replicas:** Not defined manually; it equals the number of nodes.

---

## Storage (PV & PVC)

Kubernetes storage (EBS, NFS, Local) is external to K8s. We need objects to represent and claim this storage.

*   **PV (Persistent Volume):** Represents the physical storage inside the cluster.
*   **PVC (Persistent Volume Claim):** A request for storage by a user (Pod).
*   **Storage Class:** Defines the type of storage (mediator between 3rd party storage and K8s).

### Prerequisites (for AWS EBS)
1.  Create an EBS Volume (Unattached).
2.  Ensure Volume is in the same Availability Zone as a Node.
3.  Install EBS CSI Driver on the cluster.
4.  IAM Roles attached to Nodes must have storage permissions (e.g., `AmazonEBSCSIDriverPolicy`).

### PV YAML (`pv.yaml`)
Represents the actual AWS EBS volume.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
  labels:
    type: local
spec:
  storageClassName: manual    # Must match PVC
  capacity:
    storage: 10G              # Size of the volume
  accessModes:
    - ReadWriteOnce           # RWO, ROX, RWX
  persistentVolumeReclaimPolicy: Retain # Retain, Recycle, Delete
  # For EBS specifically (or use CSI driver):
  awsElasticBlockStore:
    volumeID: <AWS_VOLUME_ID> # The actual ID from AWS console
    fsType: ext4
```
*   **Reclaim Policy:**
    *   `Retain`: Manual data deletion required.
    *   `Recycle`: Runs `rm -rf` (deprecated).
    *   `Delete`: Deletes the volume entirely.

### PVC YAML (`pvc.yaml`)
Interface to claim the PV.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  storageClassName: manual    # Must match PV
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10G            # How much storage is needed
```

### Mounting in Pod
To use the storage, we mount the PVC inside the Pod.

**Docker Analogy:**
1.  `docker volume create` (Equivalent to creating PV/PVC logic).
2.  `docker run -v my_vol:/mnt/data` (Equivalent to Pod YAML).

**Pod YAML Snippet:**
```yaml
spec:
  containers:
    - name: nginx
      image: nginx
      volumeMounts:            # Step 2: Mount inside container
        - mountPath: /usr/share/nginx/html
          name: my-storage
  volumes:                    # Step 1: Define the volume source
    - name: my-storage
      persistentVolumeClaim:
        claimName: my-pvc      # Reference to PVC
```
*   **Volumes:** Defined at the Pod spec level.
*   **VolumeMounts:** Defined inside the container spec.

---

## Health Probes

Kubernetes needs to know if your application is running. Probes are health checks (like `ping`).

### Types of Probes
1.  **Liveness Probe:** Checks if the **Container** is running.
    *   If fails: Kubernetes **restarts** the container.
    *   Purpose: To handle deadlocks or crashes.
2.  **Readiness Probe:** Checks if the **Application** inside is ready to serve traffic.
    *   If fails: Kubernetes stops sending traffic to the pod (Service removes it), but **does not** restart the container.
    *   Purpose: To handle startup delays or initialization.

### The "Deadlock" Scenario
If an app takes 30 seconds to start, but the Liveness probe checks every 5 seconds:
*   K8s sees the app as "down" and restarts it.
*   This repeats infinitely (Deadlock).

**Solution:** Use a **Readiness Probe** with a `initialDelaySeconds` or grace period (e.g., 40 seconds). Don't use Liveness to check startup success; use Readiness.

### Configuration (Conceptual)
Probes send packets (HTTP GET, TCP, or Command) to the container.
*   **Liveness:** `httpGet: /healthz` (restarts if fail).
*   **Readiness:** `httpGet: /ready` (stops traffic if fail).

**Service Behavior:**
If a Pod's **Readiness Probe** fails, the **Service** automatically removes that Pod's IP from its list of endpoints, ensuring no traffic is sent to an unready app.