
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

===
___
### **Prerequisites**
*   A Linux server (Ubuntu/Debian).
*   SSH access to the server.
*   `sudo` privileges (you can run commands as admin).

---

### **Step 1: Install Java and PostgreSQL**
First, we install the two main requirements: **Java** (to run SonarQube) and **PostgreSQL** (the database to store the data).

Run this command:
```bash
sudo apt update
sudo apt install openjdk-17-jdk postgresql -y
```
*   **Note:** This will take a moment. Once done, start the database service:
    ```bash
    sudo systemctl start postgresql
    ```

---

### **Step 2: Configure the Database**
Now we need to create a specific database and a user for SonarQube. We do this by entering the Postgres command line.

1.  **Enter the Postgres SQL shell** as the superuser:
    ```bash
    sudo -u postgres psql
    ```
    *(The prompt will change to `postgres=#`)*

2.  **Run the following commands one by one** inside the shell. You can copy and paste them.
    *   This creates a user named `linux` with password `redhat`.
    *   This creates a database named `sonarqube`.
    *   This grants full access to that user.
    ```sql
    CREATE USER linux PASSWORD 'redhat';
    CREATE DATABASE sonarqube;
    GRANT ALL PRIVILEGES ON DATABASE sonarqube TO linux;
    \c sonarqube;
    GRANT ALL PRIVILEGES ON SCHEMA public TO linux;
    \q
    ```
    *(The last command `\q` will exit the database shell and bring you back to the normal Linux command line).*

---

### **Step 3: Tune Linux System Settings**
SonarQube is a "heavy" application. Linux has default limits on files and memory that are too low. If you skip this, SonarQube will crash or fail to start.

Copy and paste these commands:
```bash
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
```
*   **What this does:** It increases the number of files the system can open and the memory mapping limits to prevent "Out of Memory" errors.

---

### **Step 4: Download and Install SonarQube**
We will download SonarQube, extract it, and move it to a standard software directory (`/opt/`) to keep the server organized.

1.  **Download the zip file:**
    ```bash
    wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.5.0.107428.zip
    ```
2.  **Install unzip tool** (to open the zip file) and extract the files:
    ```bash
    sudo apt install unzip -y
    unzip sonarqube-25.5.0.107428.zip
    ```
3.  **Move the folder** to `/opt/sonar`:
    ```bash
    sudo mv sonarqube-25.5.0.107428 /opt/sonar
    ```
    *   **Why?** It is much easier to remember `/opt/sonar` than the long version number folder.

---

### **Step 5: Configure SonarQube to Connect to Database**
Now we must tell SonarQube where the database is located.

1.  **Navigate to the configuration folder:**
    ```bash
    cd /opt/sonar/conf
    ```
    *(Full path is `/opt/sonar/conf/`)*

2.  **Open the configuration file:**
    ```bash
    vim sonar.properties
    ```
    *(This opens a text editor inside the terminal).*

3.  **Edit the file:**
    *   Use the arrow keys to scroll down.
    *   Look for the lines starting with `# sonar.jdbc.username`, `# sonar.jdbc.password`, and `# sonar.jdbc.url`.
    *   **Uncomment them** by deleting the `#` at the beginning of the line.
    *   Change the values to match the database we created in Step 2.
    
    It should look exactly like this:
    ```properties
    sonar.jdbc.username=linux
    sonar.jdbc.password=redhat
    sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
    ```

    **How to save and exit in Vim:**
    1.  Press `Esc` key.
    2.  Type `:wq` (colon, w, q).
    3.  Press `Enter`.

---

### **Step 6: Set Permissions (Crucial Security Step)**
For security and stability, we should not run SonarQube as `root` or `ubuntu`. We create a dedicated user.

1.  **Create the user named `sonar`:**
    ```bash
    sudo useradd sonar -m
    ```

2.  **Give this user ownership** of the SonarQube folder:
    ```bash
    sudo chown sonar:sonar -R /opt/sonar
    ```
    *   **Why?** The `sonar` user needs permission to read, write, and execute files inside `/opt/sonar`.

---

### **Step 7: Start SonarQube**
Now we switch to the `sonar` user and start the application.

1.  **Switch to the `sonar` user:**
    ```bash
    su sonar
    ```

2.  **Navigate to the scripts folder:**
    ```bash
    cd /opt/sonar/bin/linux-x86-64
    ```
    *(Full path is `/opt/sonar/bin/linux-x86-64`)*

3.  **Start SonarQube:**
    ```bash
    ./sonar.sh start
    ```

4.  **Check if it is running:**
    ```bash
    ./sonar.sh status
    ```
    *   You should see a message saying `SonarQube is running` (or similar).

---

### **Step 8: Access SonarQube Dashboard**
1.  Open your web browser.
2.  Go to: `http://<YOUR-SERVER-PUBLIC-IP>:9000`
    *   *Note:* Ensure Port 9000 is open in your AWS Security Group or Firewall.
3.  **Default Login:**
    *   **Username:** `admin`
    *   **Password:** `admin`
4.  It will ask you to update the password immediately. Set a new password and continue.