
# Jenkins: Master-Slave Architecture & Distributed Builds

## 1. The Problem with Single-Server Jenkins
In the previous session, we learned how to create Jenkins jobs. However, when these jobs run, they execute commands on the server's operating system, consuming CPU and Memory.

**Issues with a Single Server Setup:**
1.  **Resource Exhaustion:**
    *   If you run a heavy job (e.g., `mvn clean package`), it can take 1-3 minutes. During this time, it consumes resources.
    *   If you try to run 3 jobs simultaneously on a server with capacity for only 2, the server becomes over-utilized. This can cause Jenkins to crash or restart.
2.  **Impact on Other Jobs:**
    *   If one faulty job overloads the server, *all* other running jobs will fail or slow down, even if they were working fine initially.
3.  **Cost Inefficiency:**
    *   To handle simultaneous jobs, you might upgrade to a high-spec server (e.g., 4 Core CPU, 16GB RAM).
    *   However, if you only run one heavy job daily, the expensive server sits idle most of the time, wasting money.

**The Solution:**
To solve these issues, we use **Master-Slave (Distributed Build) Architecture**.

---

## 2. Master-Slave Architecture
Instead of running everything on one machine, we distribute the workload.

*   **Master (Controller):**
    *   This is the main Jenkins server.
    *   It handles scheduling, managing users, and providing the Dashboard/UI.
    *   It acts as the "Control Center." It sends commands but does not execute the heavy build tasks itself.
*   **Slave (Agent / Node):**
    *   These are separate machines that connect to the Master.
    *   They receive commands from the Master and execute the actual build jobs.
    *   **Communication:** The Master communicates with Agents via **SSH**.
    *   **Resources:** Jobs running on an Agent use that Agent's CPU and RAM, protecting the Master from crashing.

**High Availability (HA):**
*   Just like in Kubernetes, if the Master server crashes, all builds stop.
*   For production, you can set up **Multiple Master Nodes** (High Availability Jenkins) behind a Load Balancer. If one Master fails, another takes over.

---

## 3. Implementing Jenkins Agents (Nodes)

### Prerequisites
1.  **Java on Agent:** Since Jenkins is Java-based, every Agent node must have **Java installed**.
    *   *Best Practice:* Use the same Java version on the Agent as the Master (e.g., OpenJDK 17) to avoid compatibility issues.
2.  **SSH Access:** The Master must be able to SSH into the Agent.

### Step 1: Install Plugin
On the **Jenkins Master**:
1.  Go to **Manage Jenkins** -> **Plugins**.
2.  Go to **Available** plugins.
3.  Search for and install **"SSH Build Agents"** (or "Pipeline Nodes SSH Build Agents").
4.  **Note:** Restart Jenkins if required (use `/safeRestart`).

### Step 2: Configure the Node
1.  Go to **Manage Jenkins** -> **Nodes**.
2.  Click **New Node**.
3.  **Node Name:** e.g., `node-one`.
4.  Type: **Permanent Agent**.
5.  **Description:** Optional details about the node.

**Configuration Details:**
*   **Number of Executors:**
    *   This defines how many jobs can run simultaneously on this node.
    *   *Best Practice:* Match this to the number of CPU cores.
    *   If you set it higher than CPU cores, jobs will run in parallel but become slower due to context switching.
*   **Remote Root Directory:**
    *   The path on the Agent where Jenkins will store workspace files.
    *   *Example:* `/home/ubuntu` (The home directory of the SSH user).
*   **Labels:**
    *   Tags used to route specific jobs to this node (e.g., `build-server`, `test-server`).
*   **Usage:**
    *   "Use this node as much as possible": Runs any job here.
    *   "Only build jobs with label matching...": Only runs jobs specifically tagged for this node.
*   **Launch Method:** Select **Launch agents via SSH**.
    *   **Host:** Use the **Private IP** of the Agent instance.
        *   *Why?* Public IPs change when instances stop/start. Private IPs remain constant within the VPC.
    *   **Credentials:** Add the SSH Username (e.g., `ubuntu`) and the **Private Key** (PEM content).
    *   **Host Key Verification Strategy:** Select **Non-verifying**.
        *   *Reason:* Jenkins cannot interactively type "yes" when connecting via SSH for the first time.
*   **Availability:** Select **Keep this agent online as much as possible**.

---

## 4. Assigning Jobs to Nodes
Once the Agent is online, you can configure jobs to run on it.

1.  Open your **Freestyle Project** configuration.
2.  Look for a new section (available after plugin installation): **"Restrict where this project can be run"**.
3.  Check the box.
4.  **Label Expression:** Type the label you assigned to the node (e.g., `node-one` or `build-server`).
5.  **Save** and **Build**.

**Verification:**
*   Check the **Console Output**.
*   You will see: `Building remotely on node-one...`
*   The workspace path will reflect the Remote Root Directory configured on the node.

---

## 5. Introduction to Pipelines (Preview)
Currently, we are creating individual jobs:
1.  Job A: Pull Code.
2.  Job B: Build.
3.  Job C: Test.
4.  Job D: Deploy.

**The Problem:**
*   We have to trigger these jobs manually one by one.
*   If Job B fails, we have to check logs manually.
*   It is difficult to visualize the entire flow.

**The Solution: Jenkins Pipeline**
*   We will use a **Jenkinsfile** to define the entire process (Build -> Test -> Deploy) in a single script.
*   This automates the flow: if a stage fails, the pipeline stops, and we know exactly where.

---

## 6. Homework
To prepare for the Pipeline session, perform the following manual deployments to understand the process flow. **Do this without using ChatGPT initially** to build your logic.

**Task: Deploy "Easy Code" application 4 times manually.**

1.  **Deployment 1: EC2 + S3 + RDS**
    *   Deploy Frontend, Backend, and Database using these AWS services.
2.  **Deployment 2: Docker**
    *   Containerize the application and run it.
3.  **Deployment 3: (Implied Kubernetes/Container Orchestration)**
    *   Deploy using Kubernetes or advanced container management.
4.  **Deployment 4: Repeat**
    *   Delete everything and deploy again until you can do it without looking at notes.

**Goal:**
Understand the manual effort (commands, configuration, time) involved so you appreciate how Jenkins Pipelines automate it. If you rely on AI now, you won't understand the "magic" behind the automation later.
```