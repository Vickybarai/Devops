# 🚀 Mastering Git & GitHub
## 📑 Table of Contents

- [1. Core Concepts](#1-core-concepts)
- [2. Installation & Setup](#2-installation--setup)
- [3. The Git Lifecycle (Visual)](#3-the-git-lifecycle-visual)
- [4. Daily Operations (Commands)](#4-daily-operations-commands)
- [5. Professional Governance & Security](#5-professional-governance--security)
- [6. Branching Strategies](#6-branching-strategies)
- [7. Undoing Mistakes](#7-undoing-mistakes)
- [8. Best Practices Checklist](#8-best-practices-checklist)

---

## 1. Core Concepts

### What is Git?

**Git** is a distributed version control system. It tracks changes in your code (source code) during software development.

*   **Distributed:** Every developer on your team has a full copy of the project history on their machine.

*   **Snapshot-based:** Git saves a picture of what your files look like at a specific moment, rather than just file differences.

### What is GitHub?

**GitHub** is a hosting service for Git repositories. It acts as the "central hub" where teams push their code to collaborate, review, and deploy.

### Why is this critical for DevOps?
| Problem | Git/GitHub Solution |
| :--- | :--- |
| **Code Overwriting** | Version history allows you to travel back in time. |
| **Team Conflicts** | Branching allows multiple people to work safely. |
| **"Who broke this?"** | The Blame view and Commit Log provide an audit trail. |
| **Deployment Failures** | Tags and Releases allow you to track exactly what code is running. |

---

## 2. Installation & Setup

### 📥 Install Git
*   **Windows:** [Download Git Here](https://git-scm.com/download/win)
*   **Mac:** `git` is usually pre-installed. If not, use Homebrew: `brew install git`.

**Verify installation:**
```bash
git --version
```

### ⚙️ Initial Configuration (One-Time)
Set your identity so commits are attributed to you correctly.

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

**Check your settings:**
```bash
git config --list
```

---

## 3. The Git Lifecycle (Visual)

Understanding how code moves from your screen to the server is the most important concept.

![Git Lifecycle](https://git-scm.com/book/en/v2/images/lifecycle.png)
*(Image Credit: Pro Git Book)*

<!-- <p align="center">
  <img src="https://git-scm.com/book/en/v2/images/lifecycle.png" width="500">
</p> -->


### The 4 Stages
1.  **Working Directory:** The actual files on your computer where you edit code.
2.  **Staging Area (Index):** A preparation area where you group files to be part of the next commit.
3.  **Local Repository (.git):** The database on your computer storing your commit history.
4.  **Remote Repository (GitHub):** The server storing the project's shared history.

---

## 4. Daily Operations (Commands)

### 🔰 Starting a Project
If you are starting fresh:
```bash
git init
```
If you are downloading an existing project from GitHub:
```bash
git clone <repository-url>
```

### 📝 Saving Work (The Basic Loop)
1.  **Check Status:** See what files have changed.
    ```bash
    git status
    ```
2.  **Stage Files:** Add specific files (or all) to the staging area.
    ```bash
    git add filename.txt
    # OR add everything
    git add .
    ```
3.  **Commit:** Save the snapshot to your local history with a message.
    ```bash
    git commit -m "feat: add login page"
    ```

### 🚀 Sharing Work (Syncing)
1.  **Connect to Remote:** (Link your local folder to GitHub).
    ```bash
    git remote add origin <repository-url>
    ```
2.  **Push:** Send your local commits to GitHub.
    ```bash
    git push -u origin main
    ```
3.  **Pull:** Download changes from GitHub to your local machine.
    ```bash
    git pull origin main
    ```

### 🌿 Branching
Branching allows you to work on features without breaking the main code.

```bash
# Create a new branch and switch to it
git checkout -b feature/new-login

# Switch back to main
git checkout main

# Merge the feature into main
git merge feature/new-login
```

---

## 5. Professional Governance & Security

> **⚠️ CRITICAL RULE:** The repository is **NOT** a backup folder or a hard drive. It is a code audit trail.

### 🚫 What To NEVER Commit (Security Violations)
Committing these items is a major security risk and professional failure.

| Category | Forbidden Items | Action |
| :--- | :--- | :--- |
| **Secrets** | API Keys, AWS Passwords, Private Keys, `.env` files | Use Environment Variables or Secret Managers. |
| **Binaries** | `.exe`, `.zip`, `.jar`, compiled code | Use Artifactory/S3 storage. |
| **Dependencies** | `node_modules/`, `.venv/`, `vendor/` | Use `package.json` or `requirements.txt`. |
| **IDE Files** | `.vscode/`, `.idea/` (unless shared) | Add to `.gitignore`. |
| **Infra State** | `terraform.tfstate`, `.terraform/` | Use Remote Backends (S3/Azurerm). |

### 🛡️ The `.gitignore` File
Create a file named `.gitignore` in the root of your project. This tells Git to ignore specific files.

**Example `.gitignore`:**
```text
# Dependencies
node_modules/
.venv/

# Secrets
.env
*.pem
*.key

# Operating Systems
.DS_Store
Thumbs.db

# Terraform / DevOps
.terraform/
*.tfstate
*.tfplan
crash.log
```

---

## 6. Branching Strategies

In a professional environment, you rarely work directly on `main`.

### The Feature Branch Workflow
This is the industry standard for most teams.

![Feature Branch Workflow](https://www.atlassian.com/git/images/tutorials/comparing-workflows/feature-workflow-01.svg)

1.  **Main Branch:** Always production-ready code.
2.  **Feature Branch:** (`feature/login-page`) Where you write code.
3.  **Pull Request (PR):** You do not merge directly. You open a PR asking for a Code Review.
4.  **Merge:** After approval, the branch is merged into Main.

### Naming Conventions
Use clear prefixes:
*   `feat/` for new features (e.g., `feat/user-dashboard`)
*   `fix/` for bug fixes (e.g., `fix/login-crash`)
*   `hotfix/` for emergency production fixes

---

## 7. Undoing Mistakes

Everyone makes mistakes. Git is forgiving if you know these commands.

### Scenario A: "I edited a file, but I want to undo the changes."
*(Discard local changes)*
```bash
git restore filename.txt
```

### Scenario B: "I staged a file, but I want to unstage it."
*(Remove from staging, keep changes)*
```bash
git restore --staged filename.txt
```

### Scenario C: "I committed, but the message was wrong."
*(Change last commit message)*
```bash
git commit --amend -m "New correct message"
```

### Scenario D: "I want to delete the last 2 commits completely."
*(⚠️ Dangerous: Use only on local branches)*
```bash
git reset --hard HEAD~2
```

---

## 8. Best Practices Checklist

Before you push code to GitHub, verify you follow these rules:

### ✅ Code Quality
- [ ] My code builds without errors.
- [ ] I have run the tests locally.
- [ ] I have written meaningful commit messages (e.g., `fix: null pointer on login` instead of `update`).

### ✅ Security
- [ ] I have checked for hardcoded passwords/API keys.
- [ ] I have updated `.gitignore` to exclude sensitive files.
- [ ] I am not committing large binary files (>100MB).

### ✅ Collaboration
- [ ] I am pushing to a feature branch, not `main`.
- [ ] I have created a Pull Request for review.
- [ ] My PR description explains **WHAT** changed and **WHY**.

---

## 📚 Quick Reference Cheat Sheet

```bash
# Setup
git config --global user.name "Name"
git init
git clone <url>

# Daily
git status
git add .
git commit -m "msg"
git push
git pull

# Branching
git branch -a                 # List all branches
git checkout -b new-branch    # Create & switch
git switch main               # Switch branch (newer syntax)

# Troubleshooting
git log --oneline --graph     # Visual history
git restore file.txt          # Undo file changes
git reset --hard HEAD~1       # Delete last commit
```

---
**💡 Pro Tip:** Always pull before you start working, and pull again before you push to avoid conflicts. Happy coding!