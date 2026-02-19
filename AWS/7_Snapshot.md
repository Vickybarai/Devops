#  Amazon EBS Snapshots

Amazon EBS Snapshots are **point-in-time backups** of your EBS volumes. They are a core tool for **data protection, disaster recovery, and replication** in AWS.

---

## 1. Definition & Basics

- **Snapshot**: A backup capturing the exact state of an EBS volume at a specific point in time.
- **Storage Location**: Stored **internally in Amazon S3** (managed by AWS; not directly visible in your S3 buckets).
- **Usage**:
  - Restore data
  - Create new volumes
  - Create AMIs for EC2 launch in same or different regions
- **Key Feature**: Incremental snapshots
  - Only **changed blocks** are stored after the first snapshot
  - Saves storage costs and reduces backup time
- **Interview Tip**: "Snapshots are incremental by default, but the first snapshot is always full."

---

## 2. Manual Snapshot Creation (Workflow)

### Step-by-Step:

1. Navigate: **EC2 → Volumes**
2. Select the target **Volume**
3. Actions → **Create Snapshot**
4. Enter:
   - Name
   - Description (optional but recommended for DR clarity)
5. Result:
   - Snapshot ID generated (`snap-xxxxxxxxxxxx`)
   - Listed under **Snapshots** for tracking

### Best Practices:
- Always **tag snapshots** with application, environment, and owner
- Schedule manual snapshots **before major updates or patches**

---

## 3. Copy Snapshot (Cross-Region)

### Purpose:
- Enable **Disaster Recovery (DR)**
- Move snapshot to **another AWS region**

### Steps:

1. EC2 → **Snapshots**
2. Select Snapshot → Actions → **Copy Snapshot**
3. Target Region → Choose destination
4. Optional: **Encrypt Snapshot**
5. Result:
   - Snapshot becomes available in target region
   - Can be used to launch new volumes or AMIs

### Best Practices:
- Use **cross-region copy** for critical workloads
- Encrypt sensitive data
- Tag snapshots for DR automation

---

## 4. Launch Instance in Another Region (via AMI)

### Workflow:

1. Snapshot → Actions → **Create Image (AMI)**
2. Fill AMI Details:
   - Name
   - Storage (Root Volume size)
3. AMI Created → Available in same region
4. Copy AMI to target region (if required)
5. Launch EC2 instance using AMI in the desired region

### Interview One-Liner:
> "Snapshots → AMI → EC2 launch is the recommended AWS way to migrate instances across regions."

---

# Part 17: Automation – Amazon Data Lifecycle Manager (DLM)

Amazon **DLM** automates **snapshot creation, retention, and deletion**, reducing human error and operational overhead.

---

## 1. Lifecycle Policy Concept

- Automates **backup creation and retention**
- Targets **specific EBS volumes** using **tags**
- Ensures compliance with company backup policies
- Supports **cross-region DR automation**

---

## 2. Creating a Lifecycle Policy

### Workflow:

1. Navigate: **EC2 → Lifecycle Manager**
2. Click: **Create Policy**
3. Policy Type: **EBS Snapshot Policy**
4. Select Target Volume:
   - Identify by **tags** (e.g., App=MyApp, Env=Prod)
5. Define Policy Fields:

| Field | Description |
|-------|-------------|
| **Schedule** | Frequency of snapshot creation (e.g., every 1 day, every 12 hours) |
| **Retention Period** | How long to keep backups (e.g., 7–14 days) |
| **Copy Tags** | Optional: Copy tags from volume → snapshot for easy identification |
| **Cross-Region Copy** | Optional: Automates replication for DR |

### Outcome:
- Snapshots automatically created
- Old snapshots automatically deleted based on retention
- Cross-region copies available if enabled

---

## 3. Deleting / Disabling Automation

### Workflow:

1. Navigate: **EC2 → Lifecycle Manager**
2. Select your Policy
3. Actions → **Delete Policy** → Confirm

### Best Practices:
- Periodically review DLM policies
- Ensure critical snapshots are not accidentally deleted
- Maintain **audit trail** via tagging and CloudTrail

---

## 4. Key Points & Interview Notes

- Snapshots are **incremental**
- AMIs are **built from snapshots** for EC2 deployment
- DLM automates **snapshot lifecycle** → saves operational effort
- Always **encrypt and tag** snapshots for DR and compliance
- Cross-region copies are essential for **business continuity**