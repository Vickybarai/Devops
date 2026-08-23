If you forgot your Jenkins password, don't panic. How you fix it depends on whether this is your **very first time logging in** (using the auto-generated password) or if you **already changed it previously** and forgot the new one.

Here are the exact bash scripts and steps for both scenarios.

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

### Scenario 2: You Already Changed The Password & Forgot It
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
