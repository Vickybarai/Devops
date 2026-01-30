## 📌 Topic: CloudWatch Custom Metrics (Dashboard Setup)

### Why Custom Metrics?
- By default, CloudWatch provides:
  - CPU Utilization
  - Network In/Out
  - Disk Read/Write (EBS level)
- ❌ **Memory & Disk usage inside OS are NOT available**
- ✅ We use **CloudWatch Agent** to push these as **Custom Metrics**

---

## 🧱 Architecture Flow (High Level)

> EC2 Instance  
> → CloudWatch Agent  
> → Custom Namespace  
> → CloudWatch Metrics  
> → CloudWatch Dashboard

---

## 🔐 Step 1: Create & Attach IAM Role (Mandatory)

CloudWatch Agent needs permissions to push metrics.

---

### 1.1 Create IAM Role

- IAM → **Roles** → Create role
- Trusted Entity:
  - **AWS Service**
  - Use case: **EC2**
- Permissions:
  - `CloudWatchAgentServerPolicy` ✅ *(Recommended)*
  - *(AdministratorAccess only for labs)*
- Role Name: `Role-CW-Agent`
- Click **Create role**

---

### 1.2 Attach Role to EC2 Instance

- EC2 → Select your instance
- Actions → Security → **Modify IAM Role**
- Select `Role-CW-Agent`
- Click **Update IAM role**

✅ EC2 can now send metrics to CloudWatch

---

## 🖥️ Step 2: Install CloudWatch Agent on EC2 (Ubuntu)

---

### 2.1 Connect to EC2

```bash
ssh ubuntu@<EC2-PUBLIC-IP>

Switch to root (optional but recommended):

sudo -i
```

---

2.2 Update System & Install Dependencies
```bash
apt update -y
apt install -y curl unzip
```

---

2.3 Download CloudWatch Agent
```bash
curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
```

---

2.4 Install CloudWatch Agent
```bash
dpkg -i -E ./amazon-cloudwatch-agent.deb
```
✅ Agent binaries installed at:
```bash
/opt/aws/amazon-cloudwatch-agent/

```
---

⚙️ Step 3: Configure CloudWatch Agent (Custom JSON)

We define what metrics to collect.


---

3.1 Create Configuration File
```bash
vim cwagent-config.json

```
---

3.2 Paste Configuration (Memory + Disk)
```bash
{
  "agent": {
    "metrics_collection_interval": 60,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "namespace": "my-space",
    "metrics_collected": {
      "disk": {
        "measurement": [
          {
            "name": "used_percent",
            "rename": "DiskUsedPercent",
            "unit": "Percent"
          }
        ],
        "resources": [
          "/"
        ],
        "ignore_file_system_types": [
          "sysfs",
          "tmpfs"
        ]
      },
      "mem": {
        "measurement": [
          {
            "name": "mem_used_percent",
            "rename": "MemoryUsedPercent",
            "unit": "Percent"
          }
        ]
      }
    }
  }
}
```
Save & exit:

Esc → :wq → Enter


---

🔍 Configuration Explained (Important)

metrics_collection_interval: Push metrics every 60 seconds

namespace: Custom namespace → my-space

disk.used_percent: Root (/) disk usage

mem.mem_used_percent: OS memory usage

rename: Cleaner metric names for dashboard

ignore_file_system_types: Avoid fake/system filesystems



---

▶️ Step 4: Start & Verify CloudWatch Agent


---

4.1 Start Agent with Custom Config
```bash
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:./cwagent-config.json \
-s
```

---

4.2 Check Agent Status
```bash
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-m ec2 \
-a status
```
Expected status:

running

⏳ Wait 5–10 minutes for metrics to appear in CloudWatch.


---

📊 Step 5: Create CloudWatch Dashboard


---

5.1 Navigate to Metrics

AWS Console → CloudWatch

Metrics → All metrics

Click Browse

Scroll to Custom namespaces

Select: my-space



---

5.2 Select Metrics

Choose:

DiskUsedPercent

MemoryUsedPercent



---

5.3 Add to Dashboard

Actions → Add to dashboard

Create new dashboard:

Name: My-new-dash


Click Create

Click Add to dashboard

Save dashboard



---

✅ Final Verification

Dashboard shows:

📈 Memory utilization (%)

📈 Disk usage (%)


Metrics update every 60 seconds

Namespace visible under Custom metrics



---

🧠 Interview & Exam Takeaways

Memory & Disk metrics are custom, not default

CloudWatch Agent is required

IAM Role is mandatory (no access keys)

Custom Namespace helps isolate metrics

Used in:

Auto Scaling decisions

Alarms

Dashboards

Capacity planning




---

🧹 Cleanup (Optional)

1. Stop CloudWatch Agent
2. Detach IAM Role from EC2
3. Delete IAM Role
4. Delete CloudWatch Dashboard


