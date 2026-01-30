

AWS Lambda & EventBridge: Serverless Automation

Automate AWS tasks using Lambda and EventBridge, such as stopping EC2 instances on a schedule.


---

📌 Overview

AWS Lambda: Serverless compute service that runs code without provisioning or managing servers.

Amazon EventBridge: Event-driven orchestration service that can trigger Lambda functions based on schedules or events.

Use Case: Automatically stop EC2 instances at a specific time to save costs.



---

1. AWS Lambda – Key Concepts

Feature	Details

Serverless	No servers to manage; AWS handles OS, patching, scaling.
Supported Languages	Python, Node.js, Java, and more.
Execution Duration	Maximum 15 minutes (900 seconds).
Memory Allocation	128 MB – 10 GB (adjustable per function).
Event Payload Limit	6 MB.
Triggers	EventBridge, S3, DynamoDB, API Gateway, etc.
Cost Model	Pay per request and execution duration.



---

2. Project: Automate Stopping EC2 Instances

Part 1: Create IAM Role for Lambda

1. Navigate to IAM → Roles → Create role.


2. Trusted Entity Type: AWS Service → Lambda


3. Attach Permissions:

AmazonEC2FullAccess (to stop/start instances)

AWSLambdaBasicExecutionRole (to write logs to CloudWatch)



4. Role Name: Lambda-Stop-EC2 → Create role.




---

Part 2: Create Lambda Function

1. Go to AWS Lambda → Functions → Create function.


2. Author from scratch


3. Basic Information:

Function Name: StopMyEc2

Runtime: Python 3.12

Architecture: x86_64



4. Permissions:

Use an existing role → Lambda-Stop-EC2



5. Click Create function




---

Part 3: Deploy Code & Configure

1. Scroll to Code editor → Paste Python boto3 code to stop EC2 instances (replace Instance ID and Region).


2. Click Deploy.


3. Configure Timeout:

Configuration → General configuration → Edit

Timeout: 2 min 30 sec → Save




Example Python Code:

import boto3

ec2 = boto3.client('ec2', region_name='us-east-1')

def lambda_handler(event, context):
    instance_id = 'i-0123456789abcdef0'  # Replace with your instance ID
    ec2.stop_instances(InstanceIds=[instance_id])
    return f"Stopped EC2 instance: {instance_id}"


---

Part 4: Test Lambda Function

1. Select Test tab → Create test event


2. Event Name: StopTestEvent


3. Event JSON: {}


4. Click Save → Test


5. Verify: EC2 instance should now be in Stopped state.




---

3. Automate with Amazon EventBridge

Step 1: Create Schedule

1. Go to EventBridge Console → Schedules → Create Schedule


2. Schedule Pattern: One-time or Recurring


3. Date/Time Example: 2026-02-01 12:00 PM


4. Schedule Name: Stop-EC2-daily


5. State: Enabled




---

Step 2: Configure Target

1. Target Type: AWS Service


2. Target: Lambda Invoke


3. Function: StopMyEc2


4. Permission: Use existing role or create automatically


5. Input: {} (empty JSON)



Click Next → Create Schedule


---

✅ Verification

Check the EventBridge next invocation time

Ensure Lambda runs at scheduled time and stops the EC2 instance

Logs available in CloudWatch Logs under Lambda function



---

🚀 Benefits

Cost-saving automation by stopping unused EC2 instances

Fully serverless → No infrastructure management required

Easy schedule management via EventBridge

Logs and execution history automatically tracked in CloudWatch


