# SonarQube Installation 

## Prerequisites
*   **OS:** Ubuntu or Debian Linux.
*   **User:** A user with `sudo` privileges (you can use `ubuntu` or `root`).
*   **Access:** SSH access to the server.
*   **Resources:** Minimum 2GB RAM, but **4GB RAM** is recommended for smooth performance.

---

## Step 1: Install Java and PostgreSQL
First, we install the two main requirements: **Java** (to run SonarQube) and **PostgreSQL** (the database to store the data).

1.  **Update the package list and install the software:**
    ```bash
    sudo apt update
    sudo apt install openjdk-17-jdk postgresql -y
    ```
    *   This will take a moment to download and install.

2.  **Start the PostgreSQL service:**
    ```bash
    sudo systemctl start postgresql
    ```

---

## Step 2: Configure the Database
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

## Step 3: Tune Linux System Settings
SonarQube is a "heavy" application. Linux has default limits on files and memory that are too low. If you skip this, SonarQube will crash or fail to start. We must increase these limits.

Copy and paste these commands:
```bash
sysctl -w vm.max_map_count=524288
ulimit -n 131072
ulimit -u 8192
sysctl -w fs.file-max=131072
```
*   **What this does:** It increases the number of files the system can open and the memory mapping limits to prevent "Out of Memory" errors.

---

## Step 4: Download and Install SonarQube
We will download SonarQube, extract it, and move it to a standard software directory (`/opt/`) to keep the server organized.

1.  **Download the zip file:**
    ```bash
    wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.5.0.107428.zip
    ```

2.  **Install unzip** (if not installed) and **extract** the files:
    sudo apt install unzip -y
    ```bash
    unzip sonarqube-25.5.0.107428.zip
    ```

3.  **Move the folder** to `/opt/sonar`:
    ```bash
    sudo mv sonarqube-25.5.0.107428 /opt/sonar
    ```
    *   **Why?** It is much easier to remember `/opt/sonar` than the long version number folder.

---

## Step 5: Configure SonarQube to Connect to Database
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
    3. Press `Enter`.

---

## Step 6: Set Permissions (Crucial Security Step)
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

## Step 7: Start SonarQube
Now we switch to the `sonar` user and start the application.

1.  **Switch to the `sonar` user:**
    ```bash
    su sonar
    ```

2.  **Navigate to the scripts folder:**
    ```bash
        cd /opt/sonar/bin/linux-x86-64
    ```

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

## 8. Access SonarQube Dashboard
1.  Open your web browser.
2.  Go to: `http://<YOUR-SERVER-PUBLIC-IP>:9000`
    *   *Note:* Ensure Port 9090 is open in your AWS Security Group or Firewall.
3.  **Default Login:**
    *   **Username:** `admin`
    *   **Password:** `admin`
4.  It will ask you to update the password immediately. Set a new password and continue.

---

## Summary of Paths
To help you navigate, remember these key locations:
*   **Installation:** `/opt/sonar`
*   **Config File:** `/opt/sonar/conf/sonar.properties`
*   **Startup Script:** `/opt/sonar/bin/linux-x86-64/sonar.sh`

---

## How Scanning Works (The Process)
Once the server is running, how do we check code?

1.  **Configure Project:** In the SonarQube dashboard, create a new project (e.g., "My Java App").
2.  **Generate Token:** Create a security token for this project.
3.  **Run Scanner:** On your local machine or Jenkins pipeline, run the SonarQube Scanner command pointing to your project source code.
    *   *Example Command:* `mvn sonar:sonar -Dsonar.projectKey=my-app`
4.  **Analysis:** The scanner sends the code to the Server. The Server compares it against the rules in the Database.
5.  **Report:** The Dashboard updates with a "Quality Gate" status (Passed/Failed) and lists all Bugs, Vulnerabilities, and Code Smells.

---

## Troubleshooting
*   **Issue:** SonarQube won't start or crashes immediately.
    *   **Fix:** Did you run the `sysctl` commands from Step 3?
*   **Issue:** You can't access the dashboard.
    *   **Fix:** Check AWS Security Group (Port 9000) and ensure SonarQube is running (`./sonar.sh status`).
*   **Issue:** Project not found in SonarQube.
    *   **Fix:** The `sonar.projectKey` in your script must match the Project Key in the SonarQube Dashboard exactly.
*   **Issue:** Pipeline passes but SonarQube fails ("Quality Gate Failed").
    *   **Meaning:** Your code has bugs. Fix the code and re-run.

Let me know if this clears up the confusion!