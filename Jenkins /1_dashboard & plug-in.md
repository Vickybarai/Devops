
# Jenkins: Introduction to Jobs and Plugins

## 1. What is Jenkins?
Jenkins is an **open-source automation tool** used to automate the software development process. Its primary goal is to streamline the lifecycle from development to deployment.

**Recap: Software Development Life Cycle (SDLC)**
Before understanding Jenkins, we must recall the stages of SDLC:
1.  **Requirement Gathering & Analysis**
2.  **Planning & Design**
3.  **Development (Coding)**
4.  **Testing**
5.  **Deployment & Delivery**
6.  **Maintenance**

## 2. The Manual Process vs. CI/CD
Currently, developers follow a manual workflow to deploy applications:
1.  **Code:** Developers write code on their local machines.
2.  **Push:** Changes are pushed to a Version Control System (GitHub, GitLab, Bitbucket).
3.  **Pull:** Code is pulled from the remote repository to a server (e.g., EC2).
4.  **Build:** The build process runs, which includes:
    *   **Compilation:** Converting high-level code to machine code.
    *   **Execution:** Running the application.
    *   **Archiving:** Creating an artifact (e.g., `.jar` file).
5.  **Test:** Running automated tests (using tools like Selenium, SonarQube, Postman).
6.  **Deploy:** Pushing the artifact to a server or container (EKS, Docker, S3).

**The Problem:**
Developers must run repetitive commands for every single code change:
*   `git pull`
*   `mvn clean package`
*   `docker build`
*   `kubectl apply`

This consumes significant developer time and reduces productivity.

**The Solution: CI/CD**
Jenkins automates this entire process to save developer time.
*   **Continuous Integration (CI):** Combining hundreds of files and modules into a single application automatically (e.g., via Maven).
*   **Continuous Build:** Automating compilation, execution, and archiving.
*   **Continuous Testing:** Running tests immediately after every build.
*   **Continuous Deployment/Delivery:** Automating the release to environments like S3 or EKS.

---

## 3. Jenkins Dashboard Overview
Since Jenkins is a **Java-based application**, **Java** is a mandatory prerequisite for installation.

**Key Areas of the Dashboard:**
*   **Left Panel:**
    *   **New Item:** Used to create new jobs/projects.
    *   **Manage Jenkins:** System configuration, security settings, and plugin management.
    *   **My Views:** Personalized views.
*   **Top Bar:**
    *   **Jenkins Logo:** Click to return to the main dashboard.
    *   **Search Bar:** Search for jobs or configurations.
    *   **User/Account:** Manage profile and logout.
*   **Right Panel:**
    *   **Job History:** Lists all projects and their status (Success/Failure).

---

## 4. Creating Your First Job (Freestyle Project)
In Jenkins, a task or project is called a **Job**.

**Steps to Create a Job:**
1.  Click **New Item** on the dashboard.
2.  Enter an **Item name** (e.g., `first-job`).
3.  Select **Freestyle project** and click **OK**.

**Configuring the Job:**
*   **Description:** Optional text to describe the job.
*   **Build Steps:**
    *   In Jenkins, "Build" refers to **running the job** (not just compiling code).
    *   Click **Add build step** -> Select **Execute shell**.
    *   Enter the commands to run.
    *   *Example:* `echo "Git Pull Success"`

**Running the Job:**
*   Click **Build Now** (Play button icon).
*   **Build History:** Appears in the sidebar, showing the status of the run.
*   **Console Output:** Click on the build number -> **Console Output** to view the logs.
    *   *Output example:*
        ```text
        Started by user admin
        Running as SYSTEM
        Building in workspace /var/jenkins_home/workspace/first-job
        [first-job] $ /bin/sh -xe /tmp/jenkins123456.sh
        + echo Git Pull Success
        Git Pull Success
        Finished: SUCCESS
        ```

---

## 5. Introduction to Jenkins Plugins
**What are Plugins?**
Plugins are extensions or add-ons that provide additional features to Jenkins. Jenkins is popular largely because of its vast library of plugins (over 1,000 available).

**Why use Plugins?**
To simplify complex tasks. For example, manually writing shell scripts to handle Git logic (checking if a repo exists to decide between `git clone` or `git pull`) is complex. A Git plugin handles this logic automatically.

**Plugin Website:**
You can explore plugins at: [plugins.jenkins.io](https://plugins.jenkins.io)

**Prerequisites for Plugins:**
Before installing a plugin for a specific tool (e.g., Git, Maven, Docker), the **actual tool must be installed on the OS**.
*   *Example:* To use the Git plugin, you must run `sudo apt install git` on the server first.

---

## 6. Managing Plugins in Jenkins
**How to Install Plugins:**
1.  Go to **Manage Jenkins** -> **Plugins**.
2.  Click the **Available** tab. This acts like a "Play Store" for Jenkins.
3.  Search for the required plugin (e.g., **Git Plugin**).
4.  Check the box and click **Install without restart** (or **Download now and install after restart**).
5.  **Dependencies:** Jenkins automatically installs dependencies required by the plugin (e.g., Git Client, Script Security).

**Restarting Jenkins:**
*   After installing plugins, Jenkins usually requires a restart.
*   **Safe Restart:** Go to `<Jenkins-URL>/safeRestart`.
*   **Team Communication:** If working in a team, always notify members before restarting the Jenkins server, as it will interrupt running jobs.

---

## 7. Using Plugins in a Job (Source Code Management)
Once the Git plugin is installed, creating a job becomes easier.

**Steps:**
1.  Create a **New Item** (e.g., `cool-job`).
2.  Select **Freestyle project**.
3.  Scroll down to **Source Code Management**.
    *   *Previously:* This section might have been missing or empty.
    *   *Now:* You will see a **Git** option.
4.  Select **Git**.
5.  **Repository URL:** Enter your GitHub/GitLab repository URL.
6.  **Credentials:** If the repo is private, you will need to add credentials (SSH keys or Username/Password) via the "Add" button next to the credentials dropdown.

By using the plugin, Jenkins handles the `git clone` and `git pull` logic automatically during the build process.
```
