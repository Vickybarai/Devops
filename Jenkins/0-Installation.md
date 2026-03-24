plugin use :
- **Git Plugin**
- **Pipeline Plugin**

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
*   For the current LTS version of Jenkins, we will use **Java 21 (OpenJDK 21)**.

**Step-by-Step Installation:**

1.  **Install Java:**
    ```bash
    sudo apt update
    sudo apt install fontconfig openjdk-21-jre -y
    java -version
    ```

2.  **Add Jenkins Repository:**
    *   Add the Jenkins GPG key and repository to the system sources list.
    ```bash
    sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    ```

3.  **Update and Install Jenkins:**
    ```bash
    sudo apt update
    sudo apt install jenkins -y
    ```

4.  **Start and Enable Jenkins:**
    ```bash
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    ```

<!-- 5.  **Configure Instance Firewall (UFW):**
    *   By default, Ubuntu's firewall (UFW) might block external connections. You must explicitly allow port 8080.
    ```bash
    sudo ufw allow 8080
    sudo ufw status
    ``` -->

6.  **Configure Security Group (AWS):**
    *   Go to your EC2 Console -> Security Groups.
    *   Edit **Inbound Rules**.
    *   Add a rule:
        *   **Type:** Custom TCP
        *   **Port Range:** 8080
        *   **Source:** `0.0.0.0/0` (Allows access from anywhere) OR your specific IP address.

7.  **Access Jenkins:**
    *   Open your browser and go to: `http://<YOUR-EC2-PUBLIC-IP>:8080`
    *   *Note: If you still cannot connect, see the Troubleshooting section below.*

8.  **Unlock Jenkins:**
    *   Jenkins is locked by default for security.
    *   Retrieve the initial admin password from:
        ```bash
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
        ```

9.  **Setup Wizard:**
    *   **Plugins:** You can choose to install "Suggested Plugins" or select "None" to install them manually later.
    *   **Create Admin User:** Set up your first admin account.

**Jenkins Directory Structure:**
*   The main configuration and files are located at: `/var/lib/jenkins/`

---

## 6. Troubleshooting: "Unable to Access via Public IP"
If you have followed the steps above but still see "This site can't be reached" or a connection timeout:

1.  **Check if Jenkins is running locally:**
    Run this command inside your EC2 terminal. If this returns HTML code, Jenkins is running, and the issue is network/firewall related.
    ```bash
    curl localhost:8080
    ```

2.  **Verify Jenkins Listening Address:**
    Sometimes Jenkins binds only to `127.0.0.1` (localhost). To make it accessible via the Public IP, it must listen on `0.0.0.0`.
    *   Edit the configuration file:
        ```bash
        sudo nano /etc/default/jenkins
        ```
    *   Find the line `JENKINS_ARGS` and add/modify the httpListenAddress:
        ```bash
        JENKINS_ARGS="--webroot=/var/cache/jenkins/war --httpPort=$HTTP_PORT --httpListenAddress=0.0.0.0"
        ```
    *   Save and exit (Ctrl+O, Enter, Ctrl+X).
    *   Restart Jenkins:
        ```bash
        sudo systemctl restart jenkins
        ```

3.  **Check AWS Security Group again:**
    Ensure you are editing the Security Group **attached to your EC2 instance**, not a different one. You can check this in the EC2 console under the "Security" tab of your instance.

---

## 7. Q&A & Technical Clarifications
*   **Instance Sizing:** A `t2.micro` or `t3.small` might freeze because Jenkins is resource-heavy. It is recommended to use a `t2.medium` or `t3.medium` for practice.
*   **SSH Tools:** In companies, you often won't have direct console access. You will use tools like **MobaXterm** or **Putty** to connect via SSH.
*   **Documentation:** Always use official documentation for installation to ensure you get the latest stable versions, as repositories often lag behind.
```