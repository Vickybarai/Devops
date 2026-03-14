### **Prerequisites**
*   You have installed SonarQube and PostgreSQL on your server (or cloud instance) following the installation guide.
*   You have the URL: `http://<YOUR-SERVER-PUBLIC-IP>:9000`.
*   **Important:** You are running the command on your local machine (laptop or Jenkins Agent), not on the SonarQube server itself.

---

### **1. Identify Your Project Directory**
The instructor mentioned a project named **"socket"** located in the "bread" (meaning the root or a folder in the project).

1.  Open the GitHub link you provided: [https://github.com/Vickybarai/jenkins](https://github.com/Vickybarai/jenkins).
2. Look at the file structure on GitHub.
3. Find the folder where `pom.xml` exists.
    *   You will likely see a folder named `backend` (based on the instructor's mention of "backend" and the structure `/backend/.../pom.xml`).
    *   *Alternative:* Look for a folder named `socket`. If you find it, go inside it.
    *   *Alternative:* If the structure is simply files at the root, you are already in the right place.

**Goal:** Navigate to the folder that contains the `pom.xml` file. You must run the command from there.

---

### 2. Log in to SonarQube & Create Project
1.  **Login:**
    *   URL: `http://<YOUR-SERVER-PUBLIC-IP>:9000`
    *   User: `admin`
    *   Password: `admin` (change it immediately).
2.  **Create Project:**
    *   Click **Create Project**.
    *   **Project Name:** Enter the name exactly as you see it in the file (e.g., if the folder is named `backend`, type `backend` or `socket`).
    *   **Organization:** Select any (e.g., `MyCompany` or `Default Organization`).
    *   **Analysis:** Select **Manually**.
    *   **Project Key:** Click **Copy** the **Project Key** (e.g., `xyz_jenkins_backend`).

---

### 3. Generate Authentication Token
You need a secret key (token) so Jenkins can log in to SonarQube without using your password.

1.  In SonarQube, click your Name -> **My Account** -> **Security**.
2.  Click **Generate**.
3.  **Name the token** (e.g., `sonar-token`) and copy the string (starts with `sqp...`).
4.  In Jenkins, go to **Manage Jenkins** -> **Credentials** -> **System** -> **Global Credentials**.
5.  **Add** -> **Secret text**.
    *   **Secret:** Paste the token here.
    *   **ID:** `sonar-token` (or whatever name you prefer).
    *   **Create**.

---

### 4. The Scan Command (Crucial Step)
The instructor used the command "Sonar Polum" (likely `sonar:sonar`). You must ensure your **Project Key** and **Server URL** are correct.

Here is the command. Replace the placeholders with your actual details:

```bash
mvn sonar:sonar \
  -Dsonar.projectKey=YOUR_PROJECT_KEY \
  -Dsonar.host=http://<YOUR-SERVER-IP>:9000 \
  -Dsonar.login=admin \
  -Dsonar.password=admin \
  -Dsonar.sources=src
```

*   **`YOUR_PROJECT_KEY`: The key you copied in Step 2 (e.g., `xyz_jenkins_backend`).
*   **`YOUR-SERVER-IP`: The public IP of your SonarQube server.
*   **`sonar.sources`: If your code is inside a folder (like `backend` or `src`), point to that folder. If it is in the root, just use `.` (dot).
*   **`sonar.login` / `sonar.password`: Default is usually `admin`/`.

**Where to run this?**
1.  Open your terminal.
2.  **Navigate to the project directory** (e.g., `cd backend`).
3.  Paste the command and press Enter.
4.  Wait for the upload to finish.

---

### 5. Troubleshooting Common Issues

#### **Issue: "0% Coverage"
**Meaning:** SonarQube found no files to scan.
*   **Fix 1 (Path):**
    *   Are you in the root directory where `pom.xml` is? Use `ls` to check.
    *   If your code is inside a folder (like `backend`), your command must include that path: `-Dsonar.sources=backend`.
    *   If you are in the root and code is in `backend`, the command is simply `sonar sonar ... -Dsonar.sources=backend`.

#### **Issue: Project Not Found**
**Meaning: The Project Key in the command doesn't match what you created.
*   **Fix:** Check the **Project Key** in SonarQube Dashboard (e.g., `Vickybarai/jenkins` or `backend`). Copy it correctly into the command.

#### **Issue: "Bed Success" & "Two Ladies Regulate" (Quality Gate)**
*   **"Two ladies regulate it"** means the **Quality Gate** (Quality Gate).
*   **"Bed success"** means the scan passed the Quality Gate (you see Green).
*   If you see **Red (Failed):** Click **Quality Gate** to see why (e.g., "Too many code smells").
*   **Fix:** Fix the code locally and scan again.

#### **Issue: It says "Socket" in the file name**
*   If the folder is named `socket`, use that name in the Project Name and in the path.
*   If the folder is `backend`, use `backend` in the Project Name and path.

---

### 6. What happens after the scan?
Once the command finishes, check the SonarQube Dashboard.

1.  **Project Dashboard:** You will see a "Bug", "Vulnerability", and "Code Smell" breakdown.
2.  **Quality Gate:** Look at the status bar. Green means "Passed". Red means "Failed".
3.  **Coverage:** Look at the percentage. If 0%, check your path.

### Summary
To succeed with the manual scan:
1.  Go to the `backend` folder.
2.  Run the `mvn sonar sonar` command.
3.  (Optional) If it fails, check the Quality Gate settings in SonarQube (Project Settings -> Quality Gate) and relax the condition so it passes.
4.  Check the Dashboard for issues.