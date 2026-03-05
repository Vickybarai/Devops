# Jenkins Distributed Builds (Master-Agent Architecture)

## 1. Why Do We Need Multiple Servers?
**The Problem with a Single Jenkins Server:**

When you run a Jenkins job (like building code or running tests), it executes commands on the server's operating system. This uses the server's CPU and RAM.

1.  **Resource Exhaustion:**
    *   Imagine your Jenkins server has 2GB RAM and can handle 2 jobs at a time.
    *   If you try to run 3 or 4 jobs simultaneously, the server gets **over-utilized**.
    *   **Result:** The server might crash, restart, or become extremely slow.
    *   **Worst Case:** If *one* faulty job consumes all the memory, *all* other jobs (even the good ones) will fail.

2.  **Cost Inefficiency:**
    *   To handle multiple jobs, you might buy a massive server (e.g., 16GB RAM, 4 Cores).
    *   However, if you only run one heavy job per day, that expensive server sits idle for 23 hours. You are wasting money.

**The Solution:**
Instead of one big server doing everything, we use a **Distributed Build Architecture**. We separate the "Manager" from the "Workers."

---

## 2. Master-Agent Architecture
We divide the responsibilities into two roles:

*   **Master (Controller):**
    *   **Role:** The "Boss" or "Manager."
    *   **Function:** It handles the scheduling, stores configurations, manages users, and shows the Dashboard (UI).
    *   **Key Point:** It *commands* the work but generally does **not** execute the heavy build tasks itself.
*   **Agent (Slave / Node):**
    *   **Role:** The "Worker."
    *   **Function:** It receives commands from the Master and executes them. It uses its *own* CPU and RAM to run the jobs.
    *   **Connection:** The Master talks to the Agent via **SSH**.
    *   **Benefit:** If a heavy build crashes an Agent, the Master remains safe and can schedule other jobs on different Agents.

*(Note: In Kubernetes, we call these "Master Nodes" and "Worker Nodes." It is the same concept.)*

---

## 3. How to Implement Jenkins Agents

### Step 1: Prepare the Agent Machine
Before connecting a machine to Jenkins, it must meet one main requirement:
*   **Java:** Since Jenkins is written in Java, the Agent machine must have **Java installed**.
    *   *Best Practice:* Install the **same version** of Java on the Agent as the Master (e.g., OpenJDK 17) to avoid errors.

### Step 2: Install the Plugin
On your Jenkins Master:
1.  Go to **Manage Jenkins** > **Plugins**.
2.  Go to the **Available** tab.
3.  Search for **"SSH Build Agents"** (or "Pipeline Nodes SSH Build Agents").
4.  Install it and restart Jenkins if needed.

### Step 3: Configure the Node
1.  Go to **Manage Jenkins** > **Nodes**.
2.  Click **New Node**.
3.  Give it a **Name** (e.g., `agent-1`) and select **Permanent Agent**.

**Key Configuration Fields Explained:**

*   **Number of Executors:**
    *   This decides how many jobs can run on this agent at the same time.
    *   *Rule of Thumb:* Set this equal to the number of **CPU Cores**.
    *   *Why?* If you have 2 cores but set 4 executors, the jobs will fight for resources and run slower.
*   **Remote Root Directory:**
    *   The folder path on the Agent where Jenkins will save code and build files.
    *   *Example:* `/home/ubuntu` (The home folder of the user you will SSH with).
*   **Labels:**
    *   These are "tags" for the agent (e.g., `docker-build`, `test-server`).
    *   You can tell specific jobs to only run on agents with specific labels.
*   **Launch Method:** Select **Launch agents via SSH**.
    *   **Host:** Enter the **Private IP** of the Agent.
        *   *Why Private IP?* Public IPs change when you stop/start an AWS instance. Private IPs stay the same, preventing connection breaks.
    *   **Credentials:** Add the **Username** (e.g., `ubuntu`) and the **SSH Private Key** (paste the content of your `.pem` file).
    *   **Host Key Verification Strategy:** Select **Non-verifying**.
        *   *Reason:* The first time you connect via SSH, it asks "Are you sure? (yes/no)". Since Jenkins is a script, it cannot type "yes." We disable this check to allow the connection.

---

## 4. Assigning a Job to an Agent
Once your Agent is online, you can tell Jenkins to run specific jobs on it.

1.  Open your **Freestyle Project** configuration.
2.  Scroll down to the **General** section.
3.  Check the box **"Restrict where this project can be run"**.
4.  In the **Label Expression** box, type the name of the Agent (or the Label you assigned, e.g., `agent-1`).
5.  Click **Save**.

**Result:**
When you click **Build Now**, Jenkins will copy the job files to the Agent, execute the commands there, and bring the logs back to the Master. You will see `Building remotely on agent-1` in the console output.

---

## 5. Looking Ahead: Jenkins Pipelines
Currently, we are creating separate jobs for every step:
*   Job 1: Pull Code.
*   Job 2: Build.
*   Job 3: Test.
*   Job 4: Deploy.

**The Problem:** You have to trigger these manually one by one. If one fails, troubleshooting is difficult.

**The Solution:** **Jenkins Pipelines**.
In the next topic, we will learn how to write a script (called a `Jenkinsfile`) that automates the entire flow from start to finish in a single view.

---

## 6. Homework: Logic Building Exercise
**Goal:** Understand the manual effort so you appreciate the automation later.

**Task:** Deploy the "Easy Code" application 4 times manually. Do not use ChatGPT until you have tried and failed yourself.

1.  **Attempt 1:** Deploy on EC2, S3, and RDS.
2.  **Attempt 2:** Deploy using Docker.
3.  **Attempt 3:** Delete everything and deploy again (try to do it faster).
4.  **Attempt 4:** Deploy again without looking at your notes.

**Instructor's Note:** "If you rely on ChatGPT now, you won't understand the 'magic' behind the automation. Build your brain muscles by struggling through the manual process first!"