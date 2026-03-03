```markdown
# Introduction to Jenkins & CI/CD

## 1. Recap: Software Development Life Cycle (SDLC)
We started by discussing the Software Development Life Cycle. Companies do not operate by simply taking a client requirement and starting to code directly. There is a proper process and tracking involved.

**Stages of SDLC:**
1.  **Requirement Gathering & Analysis:** Understanding what needs to be built.
2.  **Planning & Design:** Coding never starts before this phase.
3.  **Coding & Implementation:** Writing the actual code (using frameworks like Spring Boot, Hibernate, .NET, etc.).
4.  **Testing:** Validating that the code works.
5.  **Deployment & Delivery:** Releasing the software.
6.  **Maintenance:** Ongoing support.

---

## 2. Understanding the "Build" Process
When we write code in a language like Java, Python, or .NET, it is in a **High-Level Language** that humans can read. However, hardware (CPU/Motherboard) only understands **Machine-Level Language** (Binary: 0s and 1s).

*   **Compilation:** The process of converting High-Level Language into Machine-Level Language so the Operating System can understand it.
    *   *Example (Java):* `javac app.java` (Compile), `java -jar app.jar` (Run).
*   **Packaging:** A project often contains hundreds of files. To make it portable and easy to share, we convert these multiple files into a single package (artifact).
    *   *Example:* Creating a `.jar` file or an `.apk` file.
*   **The Build:** The entire cycle of **Compiling -> Running -> Testing -> Packaging** is called the "Build" process.

---

## 3. The Need for DevOps & Automation
**The Problem:**
Currently, a developer has to manually run repetitive commands for every small change:
1.  **Git:** `git add`, `git commit`, `git push`, `git pull`.
2.  **Build:** `javac`, `java`, `tar` (for packaging).
3.  **Docker:** `docker build`, `docker run`.
4.  **Kubernetes:** `kubectl apply -f ...`
5.  **Terraform:** `terraform plan`, `terraform apply`.

If a developer changes just one line of code, they have to run all these commands again. This is a waste of time and reduces productivity.

**The Solution: DevOps & CI/CD**
DevOps aims to automate these repetitive tasks.
*   **Goal:** Reduce the time developers spend on deployment by 40-60%.
*   **CI/CD:** Continuous Integration and Continuous Deployment (or Delivery).
    *   **Continuous Integration:** Automating the build and test phases every time code is pushed.
    *   **Continuous Deployment:** Automating the release to the server.
    *   **Continuous Delivery:** Automating the handover of the artifact (e.g., storing in S3 or Nexus), ready to be deployed.

---

## 4. Introduction to Jenkins
**What is Jenkins?**
*   Jenkins is an open-source automation server used for CI/CD.
*   It is a **Java-based application** (web application).

**History:**
*   Founded in **2004** as the **"Hudson"** project by Sun Microsystems.
*   Renamed to **Jenkins** around 2011.
*   You may still see some library references to "Hudson" inside Jenkins.

**Jenkins Releases:**
1.  **Weekly Release:** Gets new features quickly but may contain bugs.
2.  **LTS (Long Term Support):** Released every 3 months. It is more stable as bugs are removed. **In companies, we always use LTS.**

---

## 5. Practical: Jenkins Installation on Ubuntu

**Prerequisites:**
*   Since Jenkins is Java-based, we must install Java first.
*   For the current LTS version of Jenkins, we will use **Java 17 (OpenJDK 17)**.

**Step-by-Step Installation:**

1.  **Install Java:**
    ```bash
    sudo apt update
    sudo apt install openjdk-17-jre
    ```

2.  **Add Jenkins Repository:**
    *   Add the Jenkins GPG key and repository to the system sources list (as per official documentation).

3.  **Update and Install Jenkins:**
    ```bash
    sudo apt update
    sudo apt install jenkins
    ```

4.  **Start and Enable Jenkins:**
    ```bash
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    ```

5.  **Configure Security Group (AWS):**
    *   Jenkins runs on port **8080** by default.
    *   Ensure your AWS Security Group allows Inbound traffic on port **8080**.

6.  **Access Jenkins:**
    *   Open your browser and go to: `http://<YOUR-EC2-PUBLIC-IP>:8080`

7.  **Unlock Jenkins:**
    *   Jenkins is locked by default for security.
    *   Retrieve the initial admin password from:
        `/var/lib/jenkins/secrets/initialAdminPassword`

8.  **Setup Wizard:**
    *   **Plugins:** You can choose to install "Suggested Plugins" or select "None" to install them manually later.
    *   **Create Admin User:** Set up your first admin account.

**Jenkins Directory Structure:**
*   The main configuration and files are located at: `/var/lib/jenkins/`

---

## 6. Q&A & Technical Clarifications
*   **Instance Sizing:** A `t2.micro` or `t3.small` might freeze because Jenkins is resource-heavy. It is recommended to use a `t2.medium` or `t3.medium` for practice.
*   **SSH Tools:** In companies, you often won't have direct console access. You will use tools like **MobaXterm** or **Putty** to connect via SSH.
*   **Documentation:** Always use official documentation for installation to ensure you get the latest stable versions, as repositories often lag behind.
```