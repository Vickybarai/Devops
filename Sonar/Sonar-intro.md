# Continuous Testing & SonarQube

## 1. What is Continuous Testing?
In the DevOps lifecycle, once the code is written and built (compiled/packaged), it is risky to deploy it directly to production.

**Continuous Testing** means testing the application automatically **every time a change is made** (e.g., every commit or build), before it is deployed to the end-users. This ensures that bugs and errors are caught early in the development cycle.

---

## 2. Introduction to SonarQube
**SonarQube** is an open-source platform developed by SonarSource used for **Continuous Inspection of Code Quality**.

*   **Purpose:** It performs automatic reviews of code to detect bugs, vulnerabilities, and code smells.
*   **Language Support:** It supports over 25 programming languages, including Java, Python, C#, .NET, and Ruby.
*   **Default Port:** `9000`.

### Key Features
1.  **Code Quality:** Checks if the code is readable, maintainable, and understandable.
2.  **Bugs:** Detects logical errors in the code.
3.  **Vulnerabilities:** Detects security threats (e.g., hardcoded passwords, SQL injection risks).
4.  **Code Smells:** Identifies bad coding practices (e.g., overly complex functions, duplicated code).
5.  **Duplications:** Finds copied/pasted code blocks.

---

## 3. SonarQube Architecture
SonarQube consists of three main components. To run SonarQube, all three are required.

### 1. SonarQube Server
This is the central application (the brain). It contains:
*   **Web Server:** Hosts the UI that users see.
*   **Search Engine:** Indexes and searches through code issues (often built on Elasticsearch).
*   **Compute Engine:** Processes the code against rules.

### 2. Database
The Server needs a database to store data. Why?
*   It stores **Rules** (conditions to check code against).
*   It stores **Metrics** and **Issues** (bugs found in projects).
*   *Note:* For performance, this database is usually hosted separately, though for practice, it can be on the same machine.

### 3. Scanner
*   **What is it?** A small program that runs on your local machine or the build server (like Jenkins).
*   **What does it do?** It analyzes your project source code and sends the results to the SonarQube Server via HTTP/HTTPS.
*   **Example:** Just like `kubectl` sends commands to Kubernetes, the Scanner sends code analysis to SonarQube.

---

## 4. SonarQube Editions
There are different versions available depending on your needs:

1.  **Community Edition:**
    *   **Cost:** Free.
    *   **Features:** Supports 21+ languages, basic code quality checks.
    *   **Best for:** Learning, personal projects, and small teams.
2.  **Developer Edition:**
    *   **Cost:** Paid.
    *   **Features:** Includes features from Community + branch analysis & pull request decoration.
3.  **Enterprise Edition:**
    *   **Cost:** Paid.
    *   **Features:** Includes Developer features + governance, compliance, and premium support.
4.  **Data Center Edition:**
    *   **Cost:** Most expensive.
    *   **Features:** High availability and advanced support for large-scale deployments.

---

## 5. Practical Guide: Installing SonarQube on Linux
The instructor demonstrated setting up SonarQube on an AWS EC2 instance.

### Prerequisites
*   **Java:** SonarQube is Java-based. You must install **OpenJDK 17** (the latest supported version).
*   **Database:** SonarQube requires a database (PostgreSQL is recommended).
*   **Hardware:** Minimum 2GB RAM, but 4GB is recommended for smooth performance.

### Step 1: Launch an Instance
*   Launch an EC2 instance (e.g., Ubuntu, t3.small or t3.medium).
*   Allow port **9000** in the Security Group (Inbound Rules).

### Step 2: Install Database (PostgreSQL)
Since SonarQube needs a place to store rules and reports:
1.  Install PostgreSQL: `sudo apt install postgresql`
2.  Log in to Postgres and create a database (e.g., `sonardb`).
3.  Create a user and grant permissions.
4.  *Key SQL Command:* `CREATE DATABASE sonardb;`

### Step 3: Install SonarQube
1.  Download the SonarQube ZIP file (SonarQube Server) from the official website.
2.  Extract the files into a directory (e.g., `/opt/sonarqube`).
3.  **Important:** You will see a file named `sonar.sh` in the `bin` folder. This is the script used to start the server.

### Step 4: Configure SonarQube (`sonar.properties`)
You need to tell SonarQube where the database is located.
1.  Navigate to the `conf` folder.
2.  Edit the file `sonar.properties`.
3.  Update the following settings:
    *   **sonar.jdbc.username:** The Postgres user you created.
    *   **sonar.jdbc.password:** The password for that user.
    *   **sonar.jdbc.url:** The connection string (e.g., `jdbc:postgresql://localhost:5432/sonardb`).

### Step 5: Start SonarQube
Run the startup script from the `bin` directory:
```bash
./bin/linux-x86-64/sonar.sh start
```
*   **Note:** It takes a few minutes to start up. You can check the logs to see if it says "SonarQube is up".

### Step 6: Access the Dashboard
1.  Open your browser.
2.  Go to `http://<YOUR-PUBLIC-IP>:9000`.
3.  **Default Login:**
    *   Username: `admin`
    *   Password: `admin` (You will be prompted to change this on first login).

---

## 6. How Scanning Works (The Process)
Once the server is running, how do we check code?

1.  **Configure Project:** In the SonarQube dashboard, create a new project (e.g., "My Java App").
2.  **Generate Token:** Create a security token for this project.
3.  **Run Scanner:** On your local machine or Jenkins pipeline, run the SonarQube Scanner command pointing to your project source code.
    *   *Example Command:* `mvn sonar:sonar -Dsonar.projectKey=my-app`
4.  **Analysis:** The scanner sends the code to the Server. The Server compares it against the rules in the Database.
5.  **Report:** The Dashboard updates with a "Quality Gate" status (Passed/Failed) and lists all Bugs, Vulnerabilities, and Code Smells.
