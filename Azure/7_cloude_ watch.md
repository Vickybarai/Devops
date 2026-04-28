

# 🎓 Lecture Notes: Azure Monitoring & Recovery Services

## 1. Introduction: What is Monitoring?

### The Concept
Think back to school. There was a "Class Monitor" (Monitor) appointed by the teacher.
*   **Role:** The monitor watched the class while the teacher was not present.
*   **Reporting:** When the teacher returned, the monitor reported: "This student talked," "This student did not do homework," etc.
*   **Benefit:** The teacher got a full report of what happened in her absence.

In the cloud, we act as the "Teachers" (Admins). We cannot watch our servers (Virtual Machines) 24/7 manually.
*   **Azure Monitor** acts as the "Class Monitor."
*   **Job:** It watches resources (CPU, Memory, Network, Disk) continuously and reports back to us.

### AWS vs. Azure Comparison
*   **AWS:** Uses **CloudWatch** for monitoring.
*   **Azure:** Uses **Azure Monitor**.
*   **Similarities:** Both perform the exact same function—tracking resource health and logs.
*   **Difference:** Implementation (UI/CLI) differs, but the concept is 100% the same.

---

## 2. Azure Monitor: Metrics & Alerts

### What does Azure Monitor do?
It tracks:
*   **CPU Utilization:** How much processing power is being used?
*   **Network Traffic:** Packets In (Download) / Packets Out (Upload).
*   **Disk Usage:** Read/Write operations.
*   **Memory Usage:** RAM consumption.

### Why do we need Alerts?
**Scenario:** You host a shopping website. At night, traffic increases, and CPU hits 90%.
*   **Problem:** The website might crash or become slow.
*   **Manual Fix:** You wake up at 2 AM, check the dashboard, and scale up the server.
*   **Smart Fix (Auto-Scaling/Alerts):** Configure a rule that says, *"If CPU > 90%, notify me."*
    *   You can set up **Auto-Scaling** to add a new server automatically.
    *   When traffic drops in the morning, auto-scaling removes the extra server to save costs.
    *   **Monitor** logs all these events (Scale Up, Scale Down) so you can review the history when you log in at 10:00 AM.

### Step-by-Step Documentation: Setting up Alerts

**Prerequisites:**
1.  Create a **Resource Group** (e.g., `Resources`).
2.  Create a **Virtual Machine** (e.g., `VM1`).

#### Step 1: Access Metrics
*   Go to your Virtual Machine resource.
*   In the left menu, under **Monitoring**, click **Metrics**.
*   **Select Metric:** Choose what you want to measure (e.g., **CPU Percentage** or **Network In Total**).
*   **Visualization:** You will see a graph showing usage over time. You can "Pin" this to your dashboard for a quick view.

#### Step 2: Create an Alert Rule
*   In the Metrics blade, click **New Alert Rule** (or go to Alerts -> Create).
*   **Scope:** Ensure the correct Resource (VM) is selected.
*   **Condition:**
    *   **Signal:** Select `CPU Percentage`.
    *   **Operator:** `Greater than`.
    *   **Threshold Type:** Static Threshold.
    *   **Threshold Value:** Enter a value (e.g., **50%** or **80%**). *Note: 60-80% is standard for production alerts.*
    *   **Aggregation Type:** Average / Maximum / Minimum.
    *   **Period of time:** How long does the condition need to be met? (e.g., "Over the last 5 minutes").
*   **Actions:**
    *   Select **Create Action Group**.
    *   **Action Type:** Email/SMS/Push/Voice.
    *   **Details:** Add your email address.
    *   *Name:* Give the Action Group a meaningful name (e.g., `AdminEmails`).
*   **Alert Rule Details:**
    *   **Alert Rule Name:** e.g., `HighCPUAlert`.
    *   **Description:** "Notify when CPU goes above 50%".
*   Click **Create**.

**Troubleshooting Alerts:**
*   If the alert doesn't fire immediately, check the **Evaluation Period** (e.g., "Every 1 Minute" vs "Over last 5 Minutes"). If the CPU spikes for 1 second but drops, a "5-minute" rule might not trigger.
*   Azure Monitor sends emails via the **Action Group**.

---

## 3. Generating Load (Stress Testing)

To verify your alerts are working, you need to spike the CPU usage manually.

### Method A: Linux
Use the `stress` command or a loop script.
```bash
# Install stress tool
sudo apt-get install stress
# Run stress to load CPU
stress --cpu 2 --timeout 60s
```
*Or use a simple loop:*
```bash
yes > /dev/null &
```

### Method B: Windows
Since there is no direct `stress` command by default, we use a Batch file.
1.  Open **Notepad**.
2.  Write the following code to create an infinite loop:
    ```batch
    @echo off
    :start
    start
    goto start
    ```
3.  Save the file as `load.bat`.
4.  Run this file. It will open command prompts repeatedly, consuming CPU.
5.  Go to the Azure Metrics dashboard to see the CPU spike.

---

## 4. Azure Backup & Recovery Services Vault

### What is the Recovery Services Vault?
*   **AWS Equivalent:** AWS Backup / Snapshot.
*   **Definition:** It is a storage/management service specifically used to store **backups** of your Azure resources (VMs, SQL, Files).
*   **Key Feature:** It acts as a safety locker. Even if you accidentally delete a Resource Group or VM, the data remains safe in the Vault for a specific retention period.

### Why is it important? (Disaster Recovery)
**Scenario:** You are working on your laptop, and it crashes. You lose all data.
*   **Without Backup:** Data is gone forever.
*   **With Backup:** You restore the data from the backup drive.

In Azure, if a VM is deleted or corrupted, you can use the Recovery Services Vault to **Restore** the VM to a previous healthy state.

### Step-by-Step Documentation: Configuring Backup

#### Step 1: Create the Vault
1.  Search for **Recovery Services Vaults** in the Azure Portal.
2.  Click **Create**.
3.  **Basics:**
    *   **Resource Group:** Select existing.
    *   **Vault Name:** e.g., `BackupVault`.
    *   **Region:** Same as your VM (e.g., Central India).
    *   **Redundancy:** Locally Redundant / Geo-Redundant (select based on cost/security needs).
4.  Click **Create**.

#### Step 2: Configure Backup
1.  Go to the newly created Vault.
2.  Click **Backup**.
3.  **Backup Goal:** Select **Azure Virtual Machines** -> **Virtual Machines**.
4.  **Select VM:** Choose the VM you created (`VM1`) -> Click **Enable Backup**.

#### Step 3: Backup Policy
This is the most important part. You must define **When** to take backups and **How long** to keep them.
*   **Backup Schedule:** How often? (e.g., Daily).
*   **Time:** When should the backup start? (e.g., 8:00 PM or 2:30 AM).
*   **Instant Restore Snapshots (Optional):** Keeps snapshots for quick recovery (e.g., for 2 days).
*   **Retention Policy:** How long to keep the backup?
    *   Daily backups: Keep for X days.
    *   Weekly backups: Keep for Y weeks.
    *   Monthly backups: Keep for Z months.
    *   Yearly backups: Keep for N years.
*   **Soft Delete:** Enabled by default. Keeps deleted backup data for **14 days** for free. If you accidentally delete a backup or VM, you can recover it within 14 days.

**Critical Note on Time Gaps (RPO - Recovery Point Objective):**
*   **Scenario:** Backup is scheduled for **8:00 PM**.
*   **Crash:** You accidentally delete data at **11:30 PM**.
*   **Recovery:** When you restore from the backup, you will only get data up to **8:00 PM**.
*   **Result:** The data created between 8:00 PM and 11:30 PM is **LOST**.
*   **Solution:** To prevent this, increase backup frequency (e.g., every 4 hours or every hour), or use features like "Application Consistent Snapshots" if available for your DB/OS.

---

## 5. 🎯 Interview Preparation

### Q1: What is the difference between AWS CloudWatch and Azure Monitor?
*   **Answer:** Functionally, they are identical. Both collect logs, metrics, and allow you to set alarms. The main difference is in the terminology and UI implementation. CloudWatch is the AWS native service, while Azure Monitor is the Azure native service.

### Q2: What is an Action Group in Azure?
*   **Answer:** An Action Group is a collection of notification receivers (Email addresses, SMS numbers, Webhooks, ITSM tools). When an Alert fires, it triggers the Action Group to notify all configured members simultaneously.

### Q3: What is the difference between a Snapshot and a Backup in Azure?
*   **Answer:**
    *   **Snapshot:** An instant, point-in-time copy of a disk. It is usually manual and stored as a VHD file. Good for quick "undo" actions.
    *   **Backup:** A managed service (via Recovery Services Vault) that takes scheduled snapshots, manages retention policies (daily/weekly/yearly), and handles lifecycle management (deleting old backups automatically).

### Q4: What is "Soft Delete" in Azure Backup?
*   **Answer:** Soft Delete is a safety feature that keeps deleted backup data for an additional **14 days** after deletion. If an admin accidentally deletes a backup or a VM, the data is not permanently lost immediately and can be recovered within this 14-day window.

### Q5: How would you simulate high CPU usage on a Windows Server for testing alerts?
*   **Answer:** Since there is no native `stress` command, I would create a batch script with an infinite loop that opens multiple command prompts, spiking the CPU utilization.
    ```batch
    @echo off
    :start
    start
    goto start
    ```

### Q6: Explain the concept of "Retention Policy" in backups.
*   **Answer:** Retention policy defines how long the backup data is kept. Azure allows granular control—daily backups can be kept for 30 days, weekly for 12 weeks, monthly for 12 months, and yearly for 10 years. This balances cost vs. recoverability.