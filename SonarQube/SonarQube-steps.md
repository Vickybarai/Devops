## Integrating SonarQube into Jenkins Pipeline

### 1. Understanding the "Quality Gate"
Before configuring Jenkins, understand this key concept discussed in the lecture:

*   **What is it?** A policy you set in SonarQube (e.g., "Zero Bugs allowed").
*   **How it affects Jenkins:** If your code is bad (has bugs or security holes), SonarQube fails the Quality Gate.
*   **Result:** Your Jenkins Pipeline will show **RED (Failure)** and stop. It will not proceed to Deploy.

---

### 2. Prerequisites Checklist
Ensure you have the following ready before starting:

| Component | Details |
| :--- | :--- |
| **SonarQube Server** | Must be running. Access at `http://<YOUR-IP>:9000`. |
| **Database** | PostgreSQL must be running and configured with a user and database (e.g., `sonarqube`). |
| **Java** | Installed on the Jenkins Agent. |
| **GitHub Repo** | Your project code (e.g., `shubhamkalsait/cdec-b48-jenkins`). |
| **SonarQube Account** | You must log in as admin and generate a **Token**. |

---

### 3. Jenkins Setup for SonarQube

#### A. Install Plugins
1.  Go to **Manage Jenkins** > **Plugins** > **Available Plugins**.
2.  Search for **SonarQube Scanner** and **Sonar Quality Gate**. Install both without restart.

#### B. Configure Global Tool
1.  Go to **Manage Jenkins** > **Global Tool Configuration**.
2.  Scroll down to **SonarQube Scanner**.
3.  Click **Add SonarQube Scanner**.
    *   **Name:** Give it a name like `Sonar Server`.
    *   **SONARQUBE_HOME:** Point to the folder where you installed SonarQube (e.g., `/opt/sonar`).
    *   **JDK:** Select the version (e.g., JDK 17).
    *   **Click Save.**

#### C. Add Credentials (The "API Key" Error)
1.  Log in to SonQube (`http://<YOUR-IP>:9000`) as **admin**.
2.  Click your name (Top Right) > **My Account** > **Security**.
3.  **Generate Token**.
4.  **Copy** the Token** (starts with `sqp...`).
5.  Go back to Jenkins > **Manage Jenkins** > **Credentials** > **System**.
6.  **Add** > **Secret text**.
    *   **Secret:** Paste the token here.
    *   **ID:** Give it a name like `sonar-token`.
    *   Click **Create**.

---

### 4. The Pipeline Script (Simplified)
Replace your existing `Test` stage (or add a new stage) with this code.
*   **Note:** Replace `easy-grade` with your actual Project Key from SonarQube dashboard.

```groovy
pipeline {
    agent any
    tools {
        // Ensure Maven is available (configured in Global Tool Config)
        maven 'M3' 
    }

    stages {
        stage('Checkout') {
            steps {
                // Get code
                git branch: 'main', url: 'https://github.com/shubhamkalsait/cdec-b48-jenkins.git'
                // If you are in a subfolder, navigate to it (e.g., `cd backend` or `backend/src/main/java`)
                // sh 'cd backend && mvn clean package' 
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            // sh 'mvn test' // Optional: Run unit tests before scanning
        }

        stage('SonarQube Analysis') {
            steps {
                // Connect to SonarQube using the Token and Config
                withSonarQube(installation: 'Sonar Server', 
                             credentialsId: 'sonar-token', 
                             scannerHome: tool 'M3') {
                    // This command triggers the scan
                    sh "mvn sonar:sonar \
                     -Dsonar.projectKey=easy-grade \
                     -Dsonar.host=${env.SONAR_HOST} \
                     -Dsonar.login=admin \
                     -Dsonar.password=admin \
                     -Dsonar.sources=src"
                }
            }
        }
    }
}
```

### Important: Environment Variables
In the script above, I used `${env.SONAR_HOST}`.
*   **Where do I define this?**
    In the Pipeline configuration, look for **Environment variables**.
    *   Key: `SONAR_HOST` (or `SONAR_URL`).
    *   Value: `http://<YOUR-PUBLIC-IP>:9000`

---

### 5. Troubleshooting Common Errors

#### Error: "Pipeline passes (Green) but SonarQube shows Red (Failed)"
*   **The Issue:** SonarQube blocked the build.
*   **The Fix:** Go to SonQube Dashboard -> **Projects** -> Click your project.
    *   Look at the **Quality Gate** section.
    *   If it says "Failed" and shows Bugs/Vulnerabilities, you must fix the code in your local IDE, push to GitHub, and run Jenkins again.

#### Error: "Connection Refused" or "401 Unauthorized"
*   **The Issue:** Jenkins is sending the wrong password or Token.
*   **The Fix:**
    *   Did you copy the **Token** (starts with `sqp_...`) into the Jenkins Credentials?
    *   Did you update the `sonar.jdbc.url` in `/opt/sonar/conf/sonar.properties`?
    *   Did you check the **Global Tool Configuration** name matches the path?

#### Error: "API ID / Key ID ... connection refused"
*   **The Issue:** The "Installation Name" in Jenkins Global Tool Configuration doesn't match the actual installation or ID is wrong.
*   **The Fix:**
    *   Go to SonarQube Dashboard -> **My Account** -> **Security**.
    *   **Generate Token**.
    *   In Jenkins, check the **Credentials** you added. Ensure the Secret matches the token exactly.
    *   Check the **Global Tool Configuration**: Ensure `SONARQUBE_HOME` is correct (e.g., `/opt/sonar`).

#### Error: "SonarQube Scanner not found"
*   **The Issue:** Jenkins doesn't know where the `mvn` command comes from.
*   **The Fix:**
    *   Did you add `maven 'M3'` in the `tools {}` block?
    *   Is the `scannerHome` path correct?
    *   Did you include the `withSonarQube` wrapper?

---

### Summary of the Process
1.  **Develop:** Write code locally.
2.  **Push:** Push to GitHub.
3.  **Build:** Jenkins pulls and builds it.
4.  **Scan:** SonarQube analyzes it.
5.  **Result:**
    *   **Quality Gate Pass:** Pipeline continues to Deploy.
    *   **Quality Gate Fail:** Pipeline stops. Check Dashboard for details.

This ensures you only deploy **clean code** to production.
```bash
# Quick check if SonarQube is up on port 9000
curl http://<YOUR-IP>:9000/api/system/status

# Check database connection
psql -U linux -d sonarqube -c "SELECT 1"
```

**If the connection is refused, check your AWS Security Group for Port 9000.**