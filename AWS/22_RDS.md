#  Shipping Custom NGINX Access Logs to CloudWatch using CloudWatch Agent  

---

## 🧠 Use Case
- Centralized log monitoring
- Real-time troubleshooting
- Security & access auditing
- Production-grade observability

---

## 🏗️ Architecture Overview

NGINX (access.log) ↓ CloudWatch Agent ↓ CloudWatch Log Group ↓ Log Streams (per EC2 instance)

---

## 🔐 Step 1: Prerequisites & IAM Role

CloudWatch Agent requires permissions to push logs.

### 1.1 Create / Select IAM Role
- Go to **IAM → Roles**
- Create or select an existing role
- Trusted entity: **AWS Service**
- Use case: **EC2**
- Attach policy:
  - `CloudWatchAgentServerPolicy` ✅
- Save role

### 1.2 Attach IAM Role to EC2
- Go to **EC2 Dashboard**
- Select EC2 instance
- Actions → Security → **Modify IAM role**
- Select the role
- Click **Update IAM role**

✅ EC2 can now send logs to CloudWatch

---

## 🖥️ Step 2: Connect to EC2 & Install CloudWatch Agent

### 2.1 Connect to EC2 (Ubuntu)

```bash
sudo -i

2.2 Update System & Install Dependencies

apt update -y
apt install -y curl unzip

2.3 Download CloudWatch Agent

curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

2.4 Install CloudWatch Agent

dpkg -i -E ./amazon-cloudwatch-agent.deb


---

🌐 Step 3: Install NGINX (Critical Step)

⚠️ Important:
NGINX log files do not exist until NGINX is installed and running.

3.1 Install NGINX

apt install -y nginx

3.2 Verify Log Files

cd /var/log/nginx/
ls

Expected output:

access.log
error.log


---

⚙️ Step 4: Configure CloudWatch Agent for Logs

4.1 Create / Edit Configuration File

vim cwagent-config.json

4.2 Paste Log Configuration JSON

{
  "agent": {
    "metrics_collection_interval": 60,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "nginx-access-log-group",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}

Save and exit:

Esc → :wq → Enter


---

▶️ Step 5: Start Agent & Load Configuration

5.1 Start CloudWatch Agent

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:./cwagent-config.json \
-s

5.2 Verify Agent Status

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-m ec2 \
-a status

Expected:

status: running


---

🔎 Step 6: Generate Traffic & Verify Logs

6.1 Generate NGINX Access Logs

Copy EC2 Public IP

Paste into browser:

http://<EC2-PUBLIC-IP>

Refresh page multiple times


6.2 Verify in CloudWatch

Go to CloudWatch → Logs → Log groups

Open:

nginx-access-log-group

Select log stream (Instance ID)

You should see NGINX access logs streaming live



---

🧹 Step 7: Cleanup (Optional)

7.1 Stop CloudWatch Agent

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-m ec2 \
-a stop

7.2 Delete Resources

CloudWatch → Logs → Delete nginx-access-log-group

EC2 Dashboard → Terminate instance

(Optional) Delete IAM Role



---

✅ Key Takeaways

NGINX must be installed before log shipping

CloudWatch Agent supports custom log files

IAM Role is mandatory (no access keys)

Log Streams are created per EC2 instance

Production-ready logging setup



---

📘 Common Interview Questions

Why CloudWatch Agent instead of default logs?

Difference between metrics vs logs?

What happens if log file path is wrong?

Can multiple instances push to same log group?

