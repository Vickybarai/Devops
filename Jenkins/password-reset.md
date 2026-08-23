
---

### Scenario 1: First Time Logging In (Auto-Generated Password) 
If you just finished installing Jenkins and haven't logged in yet, the password is automatically saved in a secret file on the server.

**Steps:**
1. SSH into your `jenkins-master-server`.
2. Run the script below to print the password to your terminal.
3. Copy the output, go to `http://<Your-Server-IP>:8080`, paste it, and continue setup.

<details>
<summary>📁 Click to view: get-jenkins-password.sh</summary>

```bash
# Prints the initial auto-generated Jenkins admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
</details>

---
===

### Scenario 2:
### Option 1 : You Already Changed The Password & Forgot It (manual)
If you already logged in, set up Jenkins, changed the password (e.g., to `admin@therate123` as mentioned in the lecture), and now you are locked out, you need to disable Jenkins security temporarily to bypass the login screen.

**Steps:**
1. SSH into your `jenkins-master-server`.
2. Run the script below to disable security.
3. Restart Jenkins.
4. Go to `http://<Your-Server-IP>:8080` (it will let you right in without asking for a password).
5. Go to `Manage Jenkins` -> `Security` -> Set a new password and re-enable security.

<details>
<summary>📁 Click to view: disable-jenkins-security.sh</summary>

```bash
# 1. Disables Jenkins security so you can log in without a password
sudo sed -i 's/<useSecurity>true</useSecurity>/<useSecurity>false/g' /var/lib/jenkins/config.xml

# 2. Restarts the Jenkins service to apply the changes
echo "Restarting Jenkins..."
sudo systemctl restart jenkins

echo "✅ Security disabled. Wait about 30 seconds, then refresh your browser."
echo "Go to Manage Jenkins -> Security to set a new password."
```
</details>

### 🔄 How to turn security back on (Optional)
Once you are logged in and have set your new password via the UI, it is good practice to turn the XML setting back to `true` (though the UI usually handles this automatically when you save security settings). If you want to be absolutely sure, you can run this:

<details>
<summary>📁 Click to view: enable-jenkins-security.sh</summary>

```bash
# Re-enables Jenkins security
sudo sed -i 's/<useSecurity>false</useSecurity>/<useSecurity>true/g' /var/lib/jenkins/config.xml
sudo systemctl restart jenkins
```
</details>

**Pro-Tip:** If you ever get a `Permission denied` error when running these scripts, make sure you used `sudo`!

....





### Option B fast: Locked Out (Stuck at Login Screen)
If you enabled security, changed the password, forgot it, and are completely locked out of the web UI, use this "Nuclear Option" script via SSH to force your way back in.

<details>
<summary>📁 Click to view: force-reset-jenkins.sh (The Nuclear Option)</summary>

```bash
#!/bin/bash
echo "========================================="
echo " FORCE JENKINS SECURITY RESET"
echo "========================================="

CONFIG_FILE="/var/lib/jenkins/config.xml"

# 1. Force Stop Jenkins completely
echo "[1/5] Stopping Jenkins service completely..."
sudo systemctl stop jenkins

# 2. Kill any lingering Java/Jenkins processes just in case
echo "[2/5] Killing any leftover background processes..."
sudo pkill -9 -f java 2>/dev/null
sleep 2

# 3. Create a backup, then forcefully change the security setting
echo "[3/5] Forcing security to FALSE in config.xml..."
sudo cp $CONFIG_FILE ${CONFIG_FILE}.backup
sudo sed -i 's/<useSecurity>true</useSecurity>/<useSecurity>false/g' $CONFIG_FILE

# 4. Verify the change actually happened
echo "[4/5] Verifying the change was applied..."
if grep -q "<useSecurity>false</useSecurity>" "$CONFIG_FILE"; then
    echo "✅ SUCCESS: Security is definitively disabled in the file."
else
    echo "❌ ERROR: The file didn't update. Trying alternative method..."
    sudo awk '{gsub(/<useSecurity>true/, "<useSecurity>false")}1' ${CONFIG_FILE}.backup > $CONFIG_FILE
    if grep -q "<useSecurity>false</useSecurity>" "$CONFIG_FILE"; then
        echo "✅ SUCCESS: Security disabled via fallback method."
    else
        echo "❌ CRITICAL: Could not disable security."
        exit 1
    fi
fi

# 5. Start Jenkins
echo "[5/5] Starting Jenkins service..."
sudo systemctl start jenkins

echo ""
echo "========================================="
echo " WAIT 60 SECONDS BEFORE REFRESHING!"
echo "========================================="
echo "Jenkins takes time to boot up. Do not refresh your browser yet."
echo "Starting countdown..."
for i in {60..1}; do
    echo -ne "Starting in $i seconds... \r"
    sleep 1
done
echo -e "\n✅ Jenkins should be ready now. Open an INCOGNITO browser window to bypass cache."
```
</details>

### Scenario B: Forgot Password (But Can Still Access Dashboard)
> **Scenario:** You can access the Jenkins dashboard, but you have forgotten the Jenkins user password and need to reset it safely.

#### 1. Open Jenkins Dashboard
Open your Jenkins URL: `http://<JENKINS-SERVER-IP>:8080/`

#### 2. Open Manage Jenkins
From the dashboard: `Dashboard` → `Manage Jenkins`

#### 3. Configure Security
Open: `Manage Jenkins` → `Security`

Configure the following settings exactly:
*   **Security Realm:** Select `Jenkins' own user database`
*   **Allow users to sign up:** **Unchecked** ☐
*   **Authorization:** Select `Logged-in users can do anything`
*   **Allow anonymous read access:** **Unchecked** ☐

> ⚠️ **Important:** Do NOT click "Save" on the Security page until you have confirmed your user has a working password in Step 6!

#### 4. Open a New Browser Tab
Go back to: `Dashboard` → `Manage Jenkins` → `Users`
*(Do not guess the URL, use the UI to navigate).*

#### 5. Open Your Jenkins User
Find your username (e.g., `admin`) → Click **Configure**

#### 6. Change the Password
Find the **Password** and **Confirm password** fields. Enter your new password in both. Click **Save**.

#### 7. Return to Security
Go back to `Manage Jenkins` → `Security`. Verify the settings are correct, then click **Save**.

#### 8. Test the New Password
Open an **Incognito/Private browser window**. Go to your Jenkins URL and log in with the new password.

---

### Quick Emergency Flow (Cheat Sheet)
If you ever need to reset a password in the future, follow this exact sequence to avoid locking yourself out:

```text
Jenkins Dashboard
       ↓
Manage Jenkins → Security
       ↓
DON'T SAVE YET!
       ↓
Manage Jenkins → Users → Your Username → Configure
       ↓
Password & Confirm Password → Save
       ↓
Back to Security → Verify settings → Save
       ↓
Test in Incognito Browser
```
