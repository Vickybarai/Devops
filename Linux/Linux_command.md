# 🐧 DevOps Linux Fast-Command_overlook

---

# 🧩 MODULE 1 — Linux Basics

---

## 1️⃣ What is Linux?

**Definition:**
Linux is a powerful, open-source operating system that supports multi-user and multi-tasking capabilities.
It allows multiple users to work on the same system at the same time and run multiple processes efficiently. Linux is widely used in servers, cloud platforms, and DevOps environments because it is secure, stable, and highly customizable.

**Why used in DevOps?**
Most servers, cloud systems, Docker, and Kubernetes run on Linux.

---

## 2️⃣ Linux Login Prompt Meaning

Example prompt:

```bash
devops@server1:~$
```

| Part    | Meaning                  |
| ------- | ------------------------ |
| devops  | Logged-in user           |
| @       | Separator                |
| server1 | Hostname                 |
| ~       | Home directory           |
| $       | Normal user (`#` = root) |

---

## 3️⃣ Important Linux Directories

| Directory | Purpose                |
| --------- | ---------------------- |
| /         | Root of system         |
| /home     | User home folders      |
| /etc      | Configuration files    |
| /var      | Logs & variable data   |
| /tmp      | Temporary files        |
| /bin      | Basic user commands    |
| /sbin     | System admin commands  |
| /usr      | Installed software     |
| /proc     | Process info (virtual) |

---

# 🧩 MODULE 2 — File System & Navigation

---

## 4️⃣ Check Current Directory

```bash
pwd
```

📌 Shows your present working directory.

---

## 5️⃣ Change Directory

```bash
cd /etc        # Go to specific folder
cd ..          # Go one level up
cd ~           # Go to home directory
cd -           # Go to previous directory
```

---

## 6️⃣ List Files

```bash
ls        # Basic list
ls -l     # Detailed list
ls -a     # Hidden files
ls -lh    # Human-readable sizes
```

---

## 7️⃣ Create Files & Directories

```bash
mkdir testdir          # Create directory
mkdir dir1 dir2        # Multiple dirs
touch file.txt         # Create empty file
```

---

## 8️⃣ Copy, Move, Rename

```bash
cp file.txt backup.txt     # Copy file
cp -r dir1 dir2             # Copy directory
mv old.txt new.txt          # Rename
mv file.txt /tmp/           # Move file
```

---

## 9️⃣ Delete Files & Folders

```bash
rm file.txt          # Delete file
rm -rf folder/       # Delete folder (danger)
rmdir emptydir       # Remove empty dir
```

---

## 🔟 View File Content

```bash
cat file.txt         # Show full file
less logfile.txt     # Scroll large file
head file.txt        # First 10 lines
tail file.txt        # Last 10 lines
tail -f log.txt      # Live logs
```

---

# 🧩 MODULE 3 — Permissions & Ownership

---

## 1️⃣ Check Permissions

```bash
ls -l file.sh
```

Example:

```
-rwxr-xr-- 1 user group 1200 file.sh
```

| Part | Meaning           |
| ---- | ----------------- |
| rwx  | Owner permissions |
| r-x  | Group permissions |
| r--  | Others            |

---

## 2️⃣ Change Permissions

```bash
chmod 755 script.sh
chmod 644 file.txt
```

| Number | Meaning |
| ------ | ------- |
| 7      | rwx     |
| 6      | rw-     |
| 5      | r-x     |
| 4      | r--     |

---

## 3️⃣ Change Ownership

```bash
chown user:group file.txt
```

---

## 4️⃣ Special Permissions

```bash
chmod u+s file     # SUID
chmod g+s dir      # SGID
chmod +t /tmp      # Sticky bit
```

---

# 🧩 MODULE 4 — User & Group Management

---

## 1️⃣ Create User

```bash
useradd devops
useradd -m tester
passwd devops
```

---

## 2️⃣ Delete User

```bash
userdel devops
userdel -r devops
```

---

## 3️⃣ Create Group

```bash
groupadd devteam
```

---

## 4️⃣ Add User to Group

```bash
usermod -aG devteam alice
```

---

## 5️⃣ Check Groups

```bash
groups alice
```

---

# 🧩 MODULE 5 — Process Management

---

## 1️⃣ View Processes

```bash
ps -ef
top
htop
```

---

## 2️⃣ Kill Process

```bash
kill 1234
kill -9 1234
killall nginx
```

---

## 3️⃣ Background & Foreground

```bash
ping google.com &   # Run in background
jobs                # Show jobs
fg %1               # Bring to foreground
bg %1               # Send back
```

---

# 🧩 MODULE 6 — Disk & System Monitoring

---

## 1️⃣ Disk Usage

```bash
df -h
du -sh /var/log
lsblk
```

---

## 2️⃣ Memory & CPU

```bash
free -h
vmstat 1
uptime
```

---

## 3️⃣ Find Files & Text

```bash
find / -name file.txt
grep "error" logfile.txt
locate nginx.conf
```
----


# 🧩 MODULE 7 — Basic Commands & Utilities (New Beginner Questions)

---

## 1️⃣ Check Current User

```bash
whoami
```

**Similar:**

```bash
echo $USER
id -un
```

**Interview Tip:** Often asked as “How do you know which user is logged in?”

---

## 2️⃣ Check Hostname / Computer Name

```bash
hostname
```

**Similar:**

```bash
uname -n
cat /etc/hostname
```

---

## 3️⃣ Show Date & Time

```bash
date
```

**Similar:**

```bash
timedatectl
hwclock
```

**Tip:** Useful in logs and cron scheduling questions.

---

## 4️⃣ Check System Info

```bash
uname -a
```

**Similar:**

```bash
cat /etc/os-release
lsb_release -a
```

**Tip:** Can show kernel version, architecture, and OS name.

---

## 5️⃣ View Last Logged In Users

```bash
last
```

**Similar:**

```bash
who
w
```

---

## 6️⃣ Check Current Logged-In Sessions

```bash
who
```

**Similar:**

```bash
w
users
```

---

## 7️⃣ Disk Free Space

```bash
df -h
```

**Similar:**

```bash
lsblk
du -sh *
```

---

## 8️⃣ File Search by Name

```bash
find /home -name "*.txt"
```

**Similar:**

```bash
locate "*.txt"
fd "*.txt"
```

---

## 9️⃣ Search Text Inside Files

```bash
grep "hello" file.txt
```

**Similar:**

```bash
grep -i "hello" file.txt   # Case insensitive
grep -r "hello" /home      # Recursive
ripgrep "hello"
```

---

## 🔟 Count Words, Lines, Characters

```bash
wc file.txt
wc -l file.txt   # Only lines
```

**Similar:**

```bash
awk '{print NF}' file.txt  # Count words per line
```

---

## 1️⃣1️⃣ Display First / Last Lines of File

```bash
head -5 file.txt
tail -5 file.txt
```

**Similar:**

```bash
sed -n 1,5p file.txt    # First 5 lines
sed -n -5,$p file.txt   # Last 5 lines
```

---

## 1️⃣2️⃣ Sort File Content

```bash
sort file.txt
sort -r file.txt    # Reverse order
```

**Similar:**

```bash
uniq file.txt       # Remove duplicates (sort needed)
sort -u file.txt    # Sort & remove duplicates
```

---

## 1️⃣3️⃣ Count Specific Pattern in File

```bash
grep -c "error" logfile.txt
```

**Similar:**

```bash
grep -i "error" logfile.txt | wc -l
awk '/error/ {count++} END {print count}' logfile.txt
```

---

## 1️⃣4️⃣ Display Disk Usage per Folder

```bash
du -sh *
```

**Similar:**

```bash
ncdu
tree -h
```

---

## 1️⃣5️⃣ Check Environment Variables

```bash
env
printenv
echo $HOME
```

**Similar:**

```bash
set
```

---

## 1️⃣6️⃣ Display Calendar

```bash
cal
```

**Similar:**

```bash
ncal
date "+%Y-%m-%d"
```

---

## 1️⃣7️⃣ Create & Extract Compressed Files

```bash
tar -cvf archive.tar file1 file2
tar -xvf archive.tar
gzip file.txt
gunzip file.txt.gz
```

**Similar:**

```bash
zip archive.zip file1 file2
unzip archive.zip
```

---

## 1️⃣8️⃣ Monitor System Logs

```bash
tail -f /var/log/syslog
```

**Similar:**

```bash
less /var/log/syslog
journalctl -f
```

---

## 1️⃣9️⃣ Check Listening Ports

```bash
netstat -tuln
```

**Similar:**

```bash
ss -tuln
lsof -i -P -n
```

---

## 2️⃣0️⃣ Check Uptime & System Load

```bash
uptime
```

**Similar:**

```bash
top
w
```

---
