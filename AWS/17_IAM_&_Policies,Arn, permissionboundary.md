Based on the uploaded images, here is the complete and  IAM (Identity & Access Management)
Definition:
 * IAM is a global service that manages access to your AWS resources. It controls who is authenticated (proven identity) & authorized (what permission they have) to use your account.
Main Four Components of IAM:
 * User: Individual or Service that interacts with AWS.
 * Group: A collection of users. Policies are attached to the group, and all users in that group inherit those permissions.
 * Role: An identity that can be assumed by a user or an AWS Service to get temporary permission.
 * Policy: A document that defines permissions.
Topic: Steps to Create Users
Step 1: IAM \rightarrow Users \rightarrow Create Users
 * User name: demo (Check box).
 * User type: IAM user.
   * Provide access to user to AWS management console: [\checkmark].
 * Console password: Custom password.
 * Next.
Step 2: Set permissions for user
 * Add user to group: Attach policy by adding user to a group that already has permissions.
 * Copy permissions: Copy permissions from an existing user.
 * Attach policies directly: Attach a policy directly to user.
   * There are 1408 types of permissions.
   * Select: Amazon EC2 Full access policy.
   * Next.
Step 3 & 4: Review & Create
 * Review \rightarrow Create.
 * Download Credentials file .csv.
   * This file contains the user's login name & link to login page.
 * Note: Password shown once during step, so first download .csv file.
IAM Limits (Per Account):
 * 5,000 IAM users per AWS account.
 * 300 IAM groups per account.
 * 1,000 IAM roles per region.
 * Policies:
   * 20 managed policies (per user/role).
   * 10 attached to group (per group) policies.
Topic: IAM Policies & ARN
Policy Definition:
 * A policy is a JSON document that defines a set of permissions.
Types of Policies:
 * Identity-based policies: That is attached to IAM identity (group or user or role).
 * Custom Policies: Create specific permissions like read, write more by own / yourself.
 * AWS Managed policies: Policies created and managed by AWS.
 * Inline Policies:
   * Policies that are directly embedded into user, group or role.
   * This are automatically deleted if the principal they are attached to is deleted.
 * Permission Boundaries: (Advance feature) An advanced policy that set the maximum permissions an identity can have.
 * Resource-based Policies:
   * Policies attached to resource, like an S3 bucket, to define who can access it.
 * Session Policy: It is temporary access to a role (while assuming role).
 * Organization Policy (SCP): Service Control Policy.
 * ACL Policies.
Topic: Creating a Policy (Lab Steps)
Step 1: Creating Policy
 * IAM \rightarrow Policies \rightarrow Create Policies.
   * i) Policies editor: [\checkmark] (Visual).
   * ii) EC2: (Policies creating for which services).
   * iii) Create Policy:
     * Effect: \rightarrow Allow or Deny [\checkmark].
     * Visual editor fields: (Action Allow).
     * 1) Services permission: \rightarrow (Total 197 list). Describe \rightarrow Read, Write, Limit (Select EC2 start & terminate).
     * 2) Resources: \rightarrow All / Specific - in this.
     * \rightarrow Next.
     * 3) Name: my policy \rightarrow Create.
 * (Check by name of our policies).
Step 2: Select (Your Policies) \rightarrow Action \rightarrow Attach
 * Select User: (To have this permission) \rightarrow Attach Policy.
Verification Scenario:
 * Demo user with EC2 Full Access.
 * Policy with (Start/Terminate Deny Access).
 * Check demo user can access EC2 or Start EC2?
   * Result: This policy override user permission. User cannot start or terminate EC2 but he has other EC2 access. (Deny wins).
Ways to Grant Permission to Single User:
 * Attaching a managed policy: The most common approach is to attach an existing AWS-managed policy or a custom policy directly to user. This is an efficient way to give a user a standard set of permissions.
 * Creating an inline policy.
Topic: Inline Policies & Roles
Inline Policy:
 * An inline policy is a custom policy that is embedded directly into a user.
 * Purpose: This is used when you need to give a user a very specific, unique permission that you don't plan to reuse.
 * Visibility: This policy is only visible & applicable to user it is attached to.
 * Lifespan: If you delete the user, the inline policy is also automatically deleted. This ensure a clean removal of all permission tied to that user.
ARN (Amazon Resource Name):
 * The ARN is a unique identifier for every resource in AWS.
 * Fields: arn : aws : {service} : {region} : {account-id} : {resource-type} / {resource-path}.
 * Ex: arn:aws:s3:::my-bucket/my-folder/my-file.txt
Role:
 * A Role is a temporary set of permission that you can grant to a trusted entity, which can be an IAM user or AWS Service.
 * Use Case: You would use a role to give an EC2 instance temporary permission to write to an S3 bucket. This is more secure than giving the instance permanent credentials.
 * Difference from a User: A user has long term credentials (password). A role provide temporary credentials & does not have a password.
Permission Boundary:
 * (Higher priority). A permission boundary is an advanced IAM feature that sets maximum permissions an IAM entity (user or role) can have.
 * Use Case: Its acts as a 'guardrail' to ensure that even if an administrator with broad permission tried to give a user more permission than they should have, the user will never exceed limits set by permission boundary.
