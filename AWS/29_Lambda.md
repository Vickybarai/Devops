
AWS Lambda: Serverless EC2 Automation

📌 Overview

AWS Lambda is a serverless compute service that lets you run code without managing servers. Lambda automatically scales and executes your code in response to events.

This guide demonstrates automating EC2 Stop/Start operations using Lambda and EventBridge.


---

🎯 Goal

Stop and start EC2 instances automatically

Avoid manual intervention

Reduce AWS cost by scheduling instance downtime



---

⚡ Key Concepts & Limits

Serverless: No server provisioning or OS maintenance

Languages Supported: Python, Node.js, Java, etc.

Execution Duration: Max 15 minutes per invocation

Memory Allocation: 128 MB – 10 GB

Payload/Event Size: Max 6 MB

Triggers: EventBridge, S3, DynamoDB, API Gateway

Cost: Pay per request and execution duration



---

🔁 Architecture Workflow

EventBridge Schedule
       ↓
AWS Lambda Function
       ↓
EC2 Instance (Stop/Start)
       ↓
CloudWatch Logs (Execution Logs)


---

Part 1: Create IAM Role for Lambda

Lambda requires permissions to control EC2 and write logs to CloudWatch.

1. Navigate to IAM → Roles → Create Role


2. Trusted entity: AWS Service → Lambda


3. Attach Policies:

AmazonEC2FullAccess → To start/stop instances

AWSLambdaBasicExecutionRole → To write logs to CloudWatch



4. Role name: lambda-Stop-EC2


5. Click Create Role




---

Part 2: Create the Lambda Function

1. Navigate to AWS Lambda → Functions → Create Function


2. Select Author from scratch


3. Configure:

Function Name: StopMyEC2

Runtime: Python 3.12

Architecture: x86_64

Permissions: Use existing role → lambda-Stop-EC2



4. Click Create Function




---

Part 3: Deploy and Configure Code

1. Stop EC2 Instance

import boto3

def lambda_handler(event, context):
    region = 'us-west-2'  # Replace with your region
    instance_id = 'i-08cb8b3a4af41c6bf'  # Replace with your instance ID

    ec2 = boto3.client('ec2', region_name=region)
    
    try:
        ec2.stop_instances(InstanceIds=[instance_id])
        print(f"Stopping instance {instance_id} in region {region}")
        return {
            'statusCode': 200,
            'body': f"Successfully initiated stop for instance {instance_id}"
        }
    except Exception as e:
        print(f"Error stopping instance {instance_id}: {str(e)}")
        return {
            'statusCode': 500,
            'body': f"Failed to stop instance {instance_id}: {str(e)}"
        }

2. Start EC2 Instance

import boto3

def lambda_handler(event, context):
    region = 'us-west-2'  # Replace with your region
    instance_id = 'i-08cb8b3a4af41c6bf'  # Replace with your instance ID

    ec2 = boto3.client('ec2', region_name=region)
    response = ec2.start_instances(InstanceIds=[instance_id])
    current_state = response['StartingInstances'][0]['CurrentState']['Name']
    
    return {
        'statusCode': 200,
        'body': f'Instance {instance_id} is now {current_state}'
    }


---

3. Configure Timeout

Lambda → Configuration → General Configuration → Edit

Set Timeout: 2–3 minutes (to avoid execution errors)

Click Save



---

Part 4: Testing the Function

1. Click Test tab


2. Event Name: StopTestEvent


3. Event JSON: {} (default)


4. Click Save → Test


5. Verify EC2 Dashboard → instance should be Stopped




---

Part 5: Automate with Amazon EventBridge

1. Create Schedule

1. Open EventBridge → Schedules → Create schedule


2. Schedule Pattern: Daily / Recurring / One-time


3. Name: Stop-EC2-daily


4. State: Enabled



2. Set Target

Target Type: AWS Service → Lambda Invoke

Function: StopMyEC2

Permissions: Use existing role or allow EventBridge to create a new one

Input: {} (empty JSON)


3. Save Schedule

Click Next → Create schedule

Lambda will now automatically stop the EC2 instance as per schedule



---

✅ Verification

Check EventBridge schedule and Lambda invocation logs

Confirm EC2 instance status changes automatically



---

⚡ Benefits

Zero server management

Automated cost savings

Full integration with AWS ecosystem

Easy to extend for multiple instances or start/stop workflows


