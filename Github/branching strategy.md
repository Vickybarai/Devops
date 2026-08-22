# 📚 Production Git Flow Branching Strategy — Complete Practical Guide

> **A middle-level, hands-on guide** to understanding and implementing Git Flow in a production-like environment. Every concept is backed by practical steps so you don't just *see* diagrams — you *do* it.

---

## 📑 Table of Contents

1. [Why This Guide Exists](#-why-this-guide-exists)
2. [Prerequisites](#-prerequisites)
3. [Core Concept: Two Types of Branches](#-core-concept-two-types-of-branches)
   - [Long-Lived (Permanent) Branches](#-long-lived-permanent-branches)
   - [Short-Lived (Working) Branches](#-short-lived-working-branches)
4. [The Complete Flow — Visual Summary](#-the-complete-flow--visual-summary)
5. [Phase 1: Repository Setup from Scratch](#-phase-1-repository-setup-from-scratch)
   - [Step 1: Create the GitHub Repository](#step-1-create-the-github-repository)
   - [Step 2: Generate a Personal Access Token (PAT)](#step-2-generate-a-personal-access-token-pat)
   - [Step 3: Clone the Repository Locally](#step-3-clone-the-repository-locally)
   - [Step 4: Add Initial Application Code](#step-4-add-initial-application-code)
   - [Step 5: Commit and Push Initial Code](#step-5-commit-and-push-initial-code)
6. [Phase 2: Convert `main` to `prod`](#-phase-2-convert-main-to-prod)
   - [Step 6: Rename `main` to `prod` Locally](#step-6-rename-main-to-prod-locally)
   - [Step 7: Push `prod` to Remote](#step-7-push-prod-to-remote)
   - [Step 8: Change Default Branch on GitHub](#step-8-change-default-branch-on-github)
   - [Step 9: Delete the `main` Branch from Remote](#step-9-delete-the-main-branch-from-remote)
7. [Phase 3: Tagging & Creating Permanent Branches](#-phase-3-tagging--creating-permanent-branches)
   - [Step 10: Create a Version Tag (v1.0.0)](#step-10-create-a-version-tag-v100)
   - [Step 11: Create `dev`, `QA`, and `PPD` Branches](#step-11-create-dev-qa-and-ppd-branches)
8. [Phase 4: Feature Development Workflow](#-phase-4-feature-development-workflow)
   - [Step 12: Developers Create Feature Branches from `dev`](#step-12-developers-create-feature-branches-from-dev)
   - [Step 13: Developer A — Work on `feature/login`](#step-13-developer-a--work-on-featurelogin)
   - [Step 14: Create a Pull Request (PR) to `dev`](#step-14-create-a-pull-request-pr-to-dev)
   - [Step 15: Code Review Before Merging](#step-15-code-review-before-merging)
   - [Step 16: Merge PR → CI/CD Triggers → Dev Environment Deployment](#step-16-merge-pr--cicd-triggers--dev-environment-deployment)
9. [Phase 5: Dev → QA → PPD → Prod Promotion](#-phase-5-dev--qa--ppd--prod-promotion)
   - [Step 17: Integration Testing on Dev Environment](#step-17-integration-testing-on-dev-environment)
   - [Step 18: Raise PR from `dev` to `QA`](#step-18-raise-pr-from-dev-to-qa)
   - [Step 19: Functional Testing on QA Environment](#step-19-functional-testing-on-qa-environment)
   - [Step 20: Raise PR from `QA` to `PPD`](#step-20-raise-pr-from-qa-to-ppd)
   - [Step 21: Smoke Testing on PPD Environment](#step-21-smoke-testing-on-ppd-environment)
   - [Step 22: Final PR from `PPD` to `prod`](#step-22-final-pr-from-ppd-to-prod)
   - [Step 23: Release Creation & Production Deployment](#step-23-release-creation--production-deployment)
10. [Phase 6: Bug Fix Workflow](#-phase-6-bug-fix-workflow)
    - [Step 24: QA Finds a Bug — Create `bugfix` Branch from `dev`](#step-24-qa-finds-a-bug--create-bugfix-branch-from-dev)
    - [Step 25: Fix, Merge Back to `dev`, Redeploy to QA](#step-25-fix-merge-back-to-dev-redeploy-to-qa)
11. [Phase 7: Hotfix Workflow (Production Incident)](#-phase-7-hotfix-workflow-production-incident)
    - [Step 26: Production Incident — Create `hotfix` Branch from `prod`](#step-26-production-incident--create-hotfix-branch-from-prod)
    - [Step 27: Merge Hotfix to `prod` AND `dev`](#step-27-merge-hotfix-to-prod-and-dev)
12. [Branch Naming Conventions — Quick Reference](#-branch-naming-conventions--quick-reference)
13. [Critical Rules to Remember](#-critical-rules-to-remember)
14. [Environment Mapping Summary](#-environment-mapping-summary)
15. [Common Mistakes & Troubleshooting](#-common-mistakes--troubleshooting)

---

## 🎯 Why This Guide Exists

> *"With help of a diagram it's easy to understand — everyone will agree. But when you do it practically, that is where you understand in a much better way and you actually get to understand how things happen in production."*

Diagrams are great for *seeing* the flow. But until you actually:
- create branches,
- raise pull requests,
- rename default branches,
- create tags,
- simulate a bug fix and a hotfix,

...the knowledge stays theoretical. **This guide bridges that gap.** Follow every step on your own machine after reading.

---

## ✅ Prerequisites

| Item | Details |
|------|---------|
| **Git Bash** | Must be installed on your machine (we use Git Bash throughout) |
| **GitHub Account** | You need an active GitHub account |
| **Basic Git Knowledge** | You should know `git add`, `git commit`, `git push` at minimum |
| **A Private Repository** | We'll create one together in Step 1 |

---

## 🧩 Core Concept: Two Types of Branches

### 📌 Long-Lived (Permanent) Branches

These branches **exist forever** in your repository. They represent environments.

| Branch | Purpose | Environment |
|--------|---------|-------------|
| `prod` | Production-ready code only | Production Server |
| `dev` | Main integration branch for all development | Dev Server (Kubernetes Server 1) |
| `QA` | Code ready for QA/testing team validation | QA Server (Kubernetes Server 2) |
| `PPD` | Pre-production / UAT environment | PPD Server (Kubernetes Server 3) |

> **Key point:** When all 4 branches are first created, they all contain the **exact same stable code** (tagged v1.0.0).

### 📌 Short-Lived (Working) Branches

These branches are **temporary**. They are created for a specific task and **deleted after merging**.

| Branch Type | Created From | Merged Into | Purpose |
|-------------|-------------|-------------|---------|
| `feature/*` | `dev` | `dev` | Develop a new feature |
| `bugfix/*` | `dev` | `dev` | Fix a bug found by QA team |
| `hotfix/*` | `prod` | `prod` + `dev` | Fix a critical production incident |

---

## 🗺️ The Complete Flow — Visual Summary

```
                         ┌──────────────────────────────────────────────┐
                         │              PROD (Default Branch)           │
                         │         Deployed to Production Server         │
                         │              Release Tag Created              │
                         └─────────────▲──────────────────▲─────────────┘
                                       │                  │
                                  PR (reviewed)      Hotfix merge
                                       │                  │
                         ┌─────────────┴──────────┐       │
                         │         PPD Branch      │       │
                         │    Pre-Production Env   │       │
                         │     (Smoke Testing)     │       │
                         └─────────────▲──────────┘       │
                                       │                  │
                                  PR (reviewed)           │
                                       │                  │
                         ┌─────────────┴──────────┐       │
                         │         QA Branch       │       │
                         │     QA Environment      ├───────┘
                         │  (Functional Testing)   │  Hotfix also
                         └─────────────▲──────────┘  merges here
                                       │
                                  PR (reviewed)
                                       │
                         ┌─────────────┴──────────┐
                         │         DEV Branch      │◄──── bugfix/* merges here
                         │     Dev Environment     │
                         │  (Integration Testing)  │
                         └─────────────▲──────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
              PR (reviewed)      PR (reviewed)      PR (reviewed)
                    │                  │                  │
            ┌───────┴───────┐ ┌───────┴───────┐ ┌───────┴───────┐
            │ feature/login │ │feature/search │ │feature/payment│
            │  (Developer A)│ │ (Developer B) │ │ (Developer C) │
            └───────────────┘ └───────────────┘ └───────────────┘
```

---

## 🔧 Phase 1: Repository Setup from Scratch

### Step 1: Create the GitHub Repository

1. Go to GitHub → Click **"New Repository"**
2. Set the following:
   - **Repository name:** `e-commerce-app`
   - **Visibility:** `Private`
   - **License:** `MIT` (or as per your preference)
3. Click **"Create Repository"**
4. After creation, you will see **only one branch**: `main` (this is GitHub's default)
5. **Do NOT initialize with README** (we'll do everything from scratch)

> ⚠️ At this point, `main` is the default branch. We will change this to `prod` shortly.

---

### Step 2: Generate a Personal Access Token (PAT)

Since our repository is **private**, we need a PAT to authenticate from the local machine.

1. Go to your **GitHub Profile** → **Settings** (scroll to bottom of profile page)
2. Scroll down to **"Developer settings"**
3. Click **"Personal access tokens"** → **"Tokens (classic)"**
4. Click **"Generate new token"** → **"Generate new token (classic)"**
5. Configure:
   - **Note:** `my-token` (or any descriptive name)
   - **Expiration:** Set as needed
   - **Scopes/Permissions:** Grant most permissions **EXCEPT** `delete_repo`
     - > ⚠️ **Why NOT `delete_repo`?** If someone gets access to your token, they could delete the repository. If it's not present locally either, recovery becomes extremely difficult.
6. Click **"Generate token"**
7. **Copy the token immediately** — you won't see it again

---

### Step 3: Clone the Repository Locally

Open **Git Bash** and run:

```bash
git clone https://github.com/<your-username>/e-commerce-app.git
```

**If this is your first time cloning a private repo**, you may get an authentication error or a popup asking for credentials:
- Click on **"Token"** (or use token as password)
- Paste the **PAT** you generated in Step 2

```bash
# After successful clone, navigate into the repository
cd e-commerce-app
```

---

### Step 4: Add Initial Application Code

Create a `src` folder and an HTML file inside it to represent our e-commerce application:

```bash
mkdir src
touch src/index.html
```

Now add some basic HTML content:

```bash
cat > src/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>E-Commerce App</title>
</head>
<body>
    <h1>Welcome to E-Commerce App</h1>
    <p>Version 1.0.0 - Base Application</p>
</body>
</html>
EOF
```

---

### Step 5: Commit and Push Initial Code

```bash
# Stage all changes
git add .

# Commit with a meaningful message
git commit -m "Initial commit: base e-commerce application with index.html"

# Push to remote (main branch)
git push origin main
```

> ✅ At this point, your remote repository has the `main` branch with your initial code.

---

## 🔄 Phase 2: Convert `main` to `prod`

This is a critical step. We want `prod` (not `main`) to be our primary production branch.

### Step 6: Rename `main` to `prod` Locally

```bash
git branch -m main prod
```

Verify the rename:

```bash
git branch
# Output: * prod
```

> ⚠️ **Very important:** This rename has happened **ONLY locally**. The remote still has `main`. Do not forget this.

---

### Step 7: Push `prod` to Remote

```bash
git push origin prod
```

Now if you refresh your GitHub repository page, you'll see **two branches**:
- `main`
- `prod`

Both contain the **exact same code** at this point.

---

### Step 8: Change Default Branch on GitHub

> ⚠️ You **cannot delete** the default branch. So we must change it first.

1. Go to your repository on GitHub
2. Go to **Settings** → scroll to **"Default branch"** section
3. Click the switch icon → Select **`prod`**
4. Click **"Update"**
5. Confirm the change

Now `prod` is your default branch.

---

### Step 9: Delete the `main` Branch from Remote

Now that `prod` is the default branch, we can safely delete `main`:

```bash
git push origin --delete main
```

> **What happens if you try to delete `main` BEFORE changing the default?**
> You will get an error:
> ```
> remote: error: refusing to delete the current branch: refs/heads/main
> ```
> GitHub **blocks deletion of the default branch**. That's why Step 8 must come before Step 9.

Refresh your GitHub page — **only `prod` branch remains**, and it is set as default. ✅

---

## 🏷️ Phase 3: Tagging & Creating Permanent Branches

### Step 10: Create a Version Tag (v1.0.0)

First, let's check our commit history:

```bash
git log --oneline
# Output:
# a1b2c3d Initial commit: base e-commerce application with index.html
```

We want to mark this commit as our **stable v1.0.0** release:

```bash
# Create an annotated tag
git tag -a v1.0.0 -m "Release v1.0.0 - Stable base application"

# Push the tag to remote
git push origin v1.0.0
```

> **What does this signify?** At this point in time, our application is stable and at version 1.0.0. This is our baseline.

---

### Step 11: Create `dev`, `QA`, and `PPD` Branches

All three branches are created **from `prod`** (since that's where we are right now):

```bash
# Create and push dev branch
git checkout -b dev
git push origin dev

# Create and push QA branch
git checkout -b QA
git push origin QA

# Create and push PPD branch
git checkout -b PPD
git push origin PPD

# Switch back to dev for development work
git checkout dev
```

Refresh your GitHub page — you should now see **4 branches**:

| Branch | Status |
|--------|--------|
| `prod` | Default branch, tagged v1.0.0 ✅ |
| `dev` | Same code as prod ✅ |
| `QA` | Same code as prod ✅ |
| `PPD` | Same code as prod ✅ |

> 🧠 **Critical understanding:** All 4 branches are at the **same level** right now. They all have the same stable code tagged v1.0.0. Divergence begins when developers start creating feature branches.

---

## 💻 Phase 4: Feature Development Workflow

**Scenario:** The client wants 3 new features:
1. Login Feature
2. Search Feature
3. Payment Feature

Three developers are assigned:
- **Developer A** → Login Feature
- **Developer B** → Search Feature
- **Developer C** → Payment Feature

### Step 12: Developers Create Feature Branches from `dev`

> ⚠️ **Always create feature branches from `dev`** — never from `prod`, `QA`, or `PPD`.

Each developer on their local machine:

```bash
# Make sure you're on dev and it's up to date
git checkout dev
git pull origin dev
```

---

### Step 13: Developer A — Work on `feature/login`

```bash
# Create and switch to feature branch from dev
git checkout -b feature/login

# Create the login feature file
touch src/login.html

# Add login code
cat > src/login.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Login Page</title></head>
<body>
    <h2>Login</h2>
    <form>
        <input type="text" placeholder="Username">
        <input type="password" placeholder="Password">
        <button type="submit">Login</button>
    </form>
</body>
</html>
EOF

# Stage, commit, and push to FEATURE branch (NOT dev)
git add .
git commit -m "Add login feature page"
git push origin feature/login
```

> ⚠️ **Strict rule:** Developer A pushes code **ONLY to `feature/login`** — not to `dev`, not to any other branch.

Similarly, Developer B and Developer C would do:

```bash
# Developer B
git checkout dev && git pull origin dev
git checkout -b feature/search
touch src/search.html
# ... add search code ...
git add . && git commit -m "Add search feature page"
git push origin feature/search

# Developer C
git checkout dev && git pull origin dev
git checkout -b feature/payment
touch src/payment.html
# ... add payment code ...
git add . && git commit -m "Add payment feature page"
git push origin feature/payment
```

---

### Step 14: Create a Pull Request (PR) to `dev`

Code is **NEVER merged directly**. It goes through a **Pull Request**.

1. Go to your GitHub repository page
2. GitHub may automatically show a banner: *"feature/login had recent pushes"* — click **"Compare & pull request"**
3. If not, manually go to **"Pull requests"** tab → **"New pull request"**
4. Set:
   - **base:** `dev` ← this is where code will be merged INTO
   - **compare:** `feature/login` ← this is where code is coming FROM
5. Add a title: `"Add login feature"`
6. Add a description explaining what was done
7. Click **"Create pull request"**

> ⚠️ **Do NOT click "Merge" yet!** The PR must be reviewed first.

---

### Step 15: Code Review Before Merging

- Every PR must have **at least one reviewer** (a senior team member)
- GitHub supports **up to 15 reviewers** per PR
- The reviewer will:
  - Check code quality
  - Check for potential issues
  - Verify it follows project standards
  - Approve or request changes

> **No PR is completed without review.** This is a non-negotiable rule in production Git Flow.

---

### Step 16: Merge PR → CI/CD Triggers → Dev Environment Deployment

Once the PR is **approved**:

1. Click **"Merge pull request"**
2. Select merge strategy (merge commit, squash, or rebase — as per team preference)
3. Click **"Confirm merge"**
4. **Optionally delete** the `feature/login` branch after merge (recommended to keep things clean)

**What happens next (automated via CI/CD pipeline):**

```
PR Merged to dev
       │
       ▼
CI/CD Pipeline Triggered
       │
       ▼
Code Deployed to Dev Environment (Kubernetes Server 1)
       │
       ▼
Integration Testing Performed
```

Repeat Steps 14–16 for `feature/search` and `feature/payment` as well.

> 🧠 **Important note about parallel development:** If Developer B creates `feature/search` **while** Developer A's PR is still open (not yet merged), the `feature/search` branch was created from `dev` at a point **before** `feature/login` was merged. This means `feature/search` will be **behind** `dev` once `feature/login` is merged. Developer B should pull latest `dev` changes and resolve any conflicts before raising their PR.

---

## 🚀 Phase 5: Dev → QA → PPD → Prod Promotion

### Step 17: Integration Testing on Dev Environment

After all 3 features are merged to `dev` and deployed to the **Dev Environment (Kubernetes Server 1)**:

- **Integration testing** is performed
- Verify that login, search, and payment features work **together**
- Check for any integration issues

If everything passes ✅ → Proceed to Step 18

---

### Step 18: Raise PR from `dev` to `QA`

1. Go to GitHub → **Pull requests** → **"New pull request"**
2. Set:
   - **base:** `QA`
   - **compare:** `dev`
3. Title: `"Promote dev to QA - Login, Search, Payment features"`
4. Create the PR
5. **Senior member reviews** the PR
6. Once approved, **merge** it

**Automated result:**
```
PR Merged to QA
       │
       ▼
CI/CD Pipeline Triggered
       │
       ▼
Code Deployed to QA Environment (Kubernetes Server 2)
```

---

### Step 19: Functional Testing on QA Environment

The **QA/Testing team** now performs:
- **Functional testing** — does each feature work as expected?
- **Regression testing** — did new features break anything?
- Other testing types as defined by the project

**Two outcomes:**

#### Outcome A: Bugs Found ❌
→ Go to **Phase 6: Bug Fix Workflow** (Step 24)

#### Outcome B: All Tests Pass ✅
→ Continue to Step 20

---

### Step 20: Raise PR from `QA` to `PPD`

1. Go to GitHub → **Pull requests** → **"New pull request"**
2. Set:
   - **base:** `PPD`
   - **compare:** `QA`
3. Title: `"Promote QA to PPD"`
4. Create → Review → Merge

**Automated result:**
```
PR Merged to PPD
       │
       ▼
CI/CD Pipeline Triggered
       │
       ▼
Code Deployed to PPD Environment (Kubernetes Server 3)
```

---

### Step 21: Smoke Testing on PPD Environment

On the **Pre-Production environment**:
- **Smoke testing** is performed (basic sanity checks)
- Additional testing as required (performance, security, etc.)
- Stakeholder / UAT sign-off may happen here

If everything passes ✅ → Proceed to Step 22

---

### Step 22: Final PR from `PPD` to `prod`

> ⚠️ This is the **most critical PR** — it's going to production!

1. Go to GitHub → **Pull requests** → **"New pull request"**
2. Set:
   - **base:** `prod`
   - **compare:** `PPD`
3. Title: `"Release v1.1.0 - Login, Search, Payment features"`
4. Create → **Thorough review** by senior members → Merge

---

### Step 23: Release Creation & Production Deployment

Once merged to `prod`:

1. **Create a Release** on GitHub:
   - Go to repository → **Releases** → **"Draft a new release"**
   - **Tag:** `v1.1.0` (create new tag)
   - **Title:** `"Release v1.1.0"`
   - **Description:** List all features included
   - Click **"Publish release"**

2. **CI/CD deploys to Production Server**

3. **Users can now access** the application with new features

```
Release v1.1.0 Created & Tagged
       │
       ▼
CI/CD Pipeline Triggered
       │
       ▼
Code Deployed to Production Server
       │
       ▼
Users Access Application ✅
```

> **What is a Release?** A release is the **final package** of your application that is ready to be deployed. It's a tagged snapshot of the code at a point in time that represents a deployable version.

---

## 🐛 Phase 6: Bug Fix Workflow

**Scenario:** During QA testing (Step 19), the QA team found a **bug in the search feature**.

### Step 24: QA Finds a Bug — Create `bugfix` Branch from `dev`

> ⚠️⚠️⚠️ **CRITICAL RULE:** The bugfix branch is created from `dev` — **NOT from `QA`**.
>
> **Why?** Because `dev` is the **primary integration branch** where all development happens. If you create from `QA`, you won't have the latest development context and changes. `dev` always has the most complete development state.

```bash
# Make sure dev is up to date
git checkout dev
git pull origin dev

# Create bugfix branch FROM dev
git checkout -b bugfix/search

# Fix the bug
# ... modify search code to fix the issue ...

git add .
git commit -m "Fix search bug: results not loading on empty query"
git push origin bugfix/search
```

---

### Step 25: Fix, Merge Back to `dev`, Redeploy to QA

1. **Create PR:** `bugfix/search` → `dev`
2. **Review** the PR
3. **Merge** to `dev`
4. CI/CD **redeploys to Dev Environment** (Kubernetes Server 1)
5. Verify the fix works in Dev
6. **Create new PR:** `dev` → `QA`
7. **Review** → **Merge**
8. CI/CD **redeploys to QA Environment** (Kubernetes Server 2)
9. QA team **re-tests** the search feature

```
bugfix/search ──PR──► dev ──CI/CD──► Dev Env (verify fix)
                                    │
                              PR (reviewed)
                                    │
                                    ▼
                              QA ──CI/CD──► QA Env (QA re-tests)
```

If QA passes this time ✅ → Continue the normal flow (QA → PPD → Prod)

---

## 🔥 Phase 7: Hotfix Workflow (Production Incident)

**Scenario:** Users are actively using the application in production. Suddenly, a **critical incident** occurs — **payments are timing out**. This needs to be fixed **immediately**.

### Step 26: Production Incident — Create `hotfix` Branch from `prod`

> ⚠️ **CRITICAL RULE:** Hotfix branches are created from `prod` — **NOT from `dev`**.
>
> **Why?** Because the issue is in production code. We need to branch from the exact code that's running in production to fix it.

```bash
# Checkout prod and ensure it's up to date
git checkout prod
git pull origin prod

# Create hotfix branch FROM prod
git checkout -b hotfix/payment-timeout

# Fix the payment timeout issue
# ... modify payment code ...

git add .
git commit -m "Hotfix: resolve payment timeout issue in production"
git push origin hotfix/payment-timeout
```

> **Naming convention:** `hotfix/<brief-description-of-issue>`
> - `hotfix/` prefix immediately tells everyone this is a production incident fix
> - `payment-timeout` describes exactly what the issue is

---

### Step 27: Merge Hotfix to `prod` AND `dev`

This is the **only branch type** that merges to **two places**:

```
hotfix/payment-timeout
         │
         ├──PR (reviewed)──► prod ──CI/CD──► Production Deployed (fix live!)
         │
         └──PR (reviewed)──► dev   (so dev has the fix too)
```

**Step-by-step:**

**Part A: Merge to `prod` (URGENT — do this first)**

1. Create PR: `hotfix/payment-timeout` → `prod`
2. **Fast-track review** (this is urgent, but still needs review)
3. Merge to `prod`
4. CI/CD immediately deploys to **Production Server**
5. Optionally create a patch release tag: `v1.1.1`

**Part B: Merge to `dev` (IMPORTANT — don't skip this)**

> ⚠️ **Why merge to `dev`?** Because `dev` is the primary development branch. If we don't merge the hotfix back to `dev`, then when the next release goes through the normal flow (dev → QA → PPD → prod), the fix will be **lost** and the bug will **reappear** in production.

1. Create PR: `hotfix/payment-timeout` → `dev`
2. Review → Merge
3. Now `dev` also has the payment timeout fix

**After both merges, delete the hotfix branch:**

```bash
# Delete locally
git branch -d hotfix/payment-timeout

# Delete from remote
git push origin --delete hotfix/payment-timeout
```

---

## 📝 Branch Naming Conventions — Quick Reference

| Pattern | Example | Created From | When to Use |
|---------|---------|-------------|-------------|
| `feature/<name>` | `feature/login` | `dev` | Building a new feature |
| `feature/<name>` | `feature/search` | `dev` | Building a new feature |
| `feature/<name>` | `feature/payment` | `dev` | Building a new feature |
| `bugfix/<name>` | `bugfix/search` | `dev` | Fixing a bug found by QA |
| `hotfix/<name>` | `hotfix/payment-timeout` | `prod` | Fixing a critical production incident |

> **Why naming conventions matter:** Anyone on the team can look at the branch list and **immediately understand** what each branch is for — no explanations needed.

---

## ⚠️ Critical Rules to Remember

### Rule 1: Bug Fix vs. Hotfix — Know the Difference

| Aspect | `bugfix/*` | `hotfix/*` |
|--------|-----------|-----------|
| **Created from** | `dev` | `prod` |
| **Merged to** | `dev` only | `prod` AND `dev` |
| **Trigger** | Bug found by QA during testing | Critical incident in production |
| **Urgency** | Normal | High/Urgent |
| **Example** | Search results not loading | Payments timing out for users |

### Rule 2: Never Merge Directly — Always Use Pull Requests

```
❌ WRONG:   git checkout dev && git merge feature/login
✅ RIGHT:   Create PR on GitHub → Review → Merge via GitHub UI
```

Every merge (feature → dev, dev → QA, QA → PPD, PPD → prod) must go through a **reviewed pull request**.

### Rule 3: Every PR Needs a Reviewer

- Minimum 1 reviewer (senior team member)
- Maximum 15 reviewers supported by GitHub
- No PR should be merged without approval

### Rule 4: `dev` is the Integration Hub

- All feature branches are created from `dev`
- All bug fixes are created from `dev`
- All hotfixes are merged back to `dev`
- `dev` is the **single source of truth** for ongoing development

### Rule 5: `prod` is Sacred

- Only `PPD` merges into `prod` (through normal flow)
- Only `hotfix/*` merges into `prod` (through emergency flow)
- Nothing else touches `prod` directly

### Rule 6: Delete Short-Lived Branches After Merge

After a `feature/*`, `bugfix/*`, or `hotfix/*` branch is merged, **delete it**. Don't let them pile up.

---

## 🖥️ Environment Mapping Summary

| Branch | Environment | Server | Testing Done | Trigger |
|--------|------------|--------|-------------|---------|
| `dev` | Development | Kubernetes Server 1 | Integration Testing | Feature/bugfix merged to `dev` |
| `QA` | Quality Assurance | Kubernetes Server 2 | Functional Testing, Regression | PR merged from `dev` to `QA` |
| `PPD` | Pre-Production | Kubernetes Server 3 | Smoke Testing, UAT | PR merged from `QA` to `PPD` |
| `prod` | Production | Production Server | (Users testing in real-time) | PR merged from `PPD` to `prod` |

---

## 🛠️ Common Mistakes & Troubleshooting

### Mistake 1: Trying to delete `main` before changing default branch

```bash
git push origin --delete main
# ERROR: remote: error: refusing to delete the current branch: refs/heads/main
```

**Fix:** Change default branch to `prod` in GitHub Settings first, then delete.

### Mistake 2: Creating `bugfix` branch from `QA` instead of `dev`

```
❌ WRONG:   git checkout QA && git checkout -b bugfix/search
✅ RIGHT:   git checkout dev && git checkout -b bugfix/search
```

**Why it's wrong:** `QA` branch doesn't have all the development context. `dev` is the integration branch with the most complete state.

### Mistake 3: Forgetting to merge hotfix back to `dev`

If you skip this, the fix will be **lost** in the next release cycle and the production bug will **reappear**.

### Mistake 4: Creating feature branch while another PR is pending

If Developer B creates `feature/search` while Developer A's `feature/login` PR is still open (not merged), `feature/search` was based on `dev` **before** `feature/login` was merged. After `feature/login` is merged, `feature/search` will be behind. Developer B must:

```bash
git checkout feature/search
git fetch origin
git merge origin/dev
# Resolve any conflicts if needed
git push origin feature/search
```

### Mistake 5: Pushing feature code directly to `dev`

```
❌ WRONG:   git checkout dev && git add . && git commit -m "Add login" && git push origin dev
✅ RIGHT:   Work on feature/login branch → Push to feature/login → Create PR → Review → Merge
```

---

## 📋 Complete Command Cheat Sheet

```bash
# ==================== SETUP ====================
git clone https://github.com/<username>/e-commerce-app.git
cd e-commerce-app

# ==================== INITIAL CODE ====================
mkdir src
touch src/index.html
git add .
git commit -m "Initial commit: base e-commerce application"
git push origin main

# ==================== RENAME main TO prod ====================
git branch -m main prod
git push origin prod
# (Change default branch on GitHub UI first!)
git push origin --delete main

# ==================== TAGGING ====================
git tag -a v1.0.0 -m "Release v1.0.0 - Stable base application"
git push origin v1.0.0

# ==================== CREATE PERMANENT BRANCHES ====================
git checkout -b dev && git push origin dev
git checkout -b QA && git push origin QA
git checkout -b PPD && git push origin PPD
git checkout dev

# ==================== FEATURE DEVELOPMENT ====================
git checkout dev && git pull origin dev
git checkout -b feature/login
# ... write code ...
git add . && git commit -m "Add login feature"
git push origin feature/login
# (Create PR on GitHub: feature/login → dev)

# ==================== BUG FIX ====================
git checkout dev && git pull origin dev
git checkout -b bugfix/search
# ... fix bug ...
git add . && git commit -m "Fix search bug"
git push origin bugfix/search
# (Create PR on GitHub: bugfix/search → dev)

# ==================== HOTFIX ====================
git checkout prod && git pull origin prod
git checkout -b hotfix/payment-timeout
# ... fix issue ...
git add . && git commit -m "Hotfix: resolve payment timeout"
git push origin hotfix/payment-timeout
# (Create PR 1: hotfix/payment-timeout → prod) ← URGENT
# (Create PR 2: hotfix/payment-timeout → dev)  ← IMPORTANT

# ==================== CLEANUP ====================
git branch -d feature/login
git push origin --delete feature/login
```

---

## 🎯 Final Summary

| What | How |
|------|-----|
| New feature development | `feature/*` from `dev` → PR → merge to `dev` |
| Bug found by QA | `bugfix/*` from `dev` → PR → merge to `dev` → redeploy to QA |
| Production incident | `hotfix/*` from `prod` → PR → merge to `prod` AND `dev` |
| Code promotion | `dev` → `QA` → `PPD` → `prod` (each via reviewed PR) |
| Release | Created and tagged when merging to `prod` |
| Branch deletion | Always delete short-lived branches after merge |

---

> **💡 Final Advice:** *"After watching/reading this, make sure to implement it on your side as well so that you can actually understand it on a very good level. Because obviously when you do something practically, that's much better than simply understanding it through a diagram."*

**Now go set up your own `e-commerce-app` repository and practice every single step.** 🚀
