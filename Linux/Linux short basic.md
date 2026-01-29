


1️⃣ File System

Know where logs, configs, and binaries live

Linux is predictable. Once you understand the filesystem, 50% debugging becomes easy.

🔹 Core Rule

> Linux separates configuration, binaries, logs, and data clearly.



📂 Critical Directories (Interview MUST)

Directory	Purpose	Why it matters

/etc	Configuration files	Service not working? Config issue = here
/var/log	Logs	First place to debug failures
/bin, /usr/bin	User commands	Where core commands live
/sbin, /usr/sbin	Admin commands	Root-only binaries
/lib, /usr/lib	Libraries	Missing libs = app crash
/home	User data	User access issues
/root	Root home	Admin environment
/tmp	Temporary files	Auto-cleaned
/opt	Optional software	Third-party apps
/var	Variable data	Logs, cache, spool


🧠 Interview Insight

> “If a service fails, I check /etc for config, /var/log for errors, and binary path for existence.”




---

2️⃣ Permissions & Ownership

Fix 80% of access issues

Most Linux problems are NOT bugs, they’re permission problems.

🔹 Permission Model

r = read
w = write
x = execute

Applied to:

Owner

Group

Others


Example:

-rwxr-xr--

Owner: full access

Group: read + execute

Others: read only


🔹 Ownership

chown user:group file

🔹 Why apps fail

Script not executable

Service user doesn’t own file

Wrong directory permissions


🔐 Special Permissions

Type	Use case

setuid	Run as owner (passwd)
setgid	Shared group dirs
sticky bit	/tmp safety


🧠 Interview Insight

> “When I see ‘Permission denied’, I immediately check ownership, chmod, and SELinux.”




---

3️⃣ Processes & Services

Understand what’s actually running

Linux runs processes, systemd manages services.

🔹 Process Basics

Every process has a PID

Parent → Child hierarchy

Resources: CPU, memory, files


Key Commands:

ps -ef
top
htop

🔹 Kill Logic

kill → graceful

kill -9 → force (last option)


🔹 Zombie Process

Finished execution

Parent didn’t collect status

Fix = restart parent


🧠 Interview Insight

> “High load? I first check running processes, not restart blindly.”




---

4️⃣ Logs & Debugging

Find the real cause, not guesses

Admins read logs, juniors restart services.

🔹 Where logs live

/var/log/

Common logs:

syslog

messages

auth.log

secure

App-specific folders


🔹 systemd logs

journalctl
journalctl -u nginx
journalctl -xe

🔹 Debug mindset

1. What failed?


2. When?


3. What changed?


4. What error exactly?



🧠 Interview Insight

> “I never assume. Logs always tell the truth.”




---

5️⃣ Networking Basics

Ports, DNS, IPs, firewalls

Most production outages = network issues.

🔹 IP & Interfaces

ip addr
ifconfig

🔹 Connectivity

ping
curl
telnet
nc

🔹 Ports

ss -tuln
netstat -putan

🔹 DNS

Files:

/etc/hosts → local override

/etc/resolv.conf → DNS servers


🔹 Firewall

iptables
firewalld
ufw

🧠 Interview Insight

> “Service running but not reachable usually means port or firewall issue.”




---

6️⃣ Disk & Memory

Why systems slow down or crash

🔹 Disk

df -h
du -sh

🔹 Inodes

Disk may have space but no inodes left.

df -i

🔹 Memory

free -h
top

🔹 Swap

Used when RAM full → performance drops.

🧠 Interview Insight

> “Before scaling, I check disk I/O, memory pressure, and swap usage.”




---

7️⃣ Package Management

How software is installed

Linux uses repositories + package managers.

Common managers:

OS	Tool

Ubuntu	apt
RHEL/CentOS	yum / dnf


Flow:

1. Repo configured


2. Metadata fetched


3. Package installed


4. Config in /etc


5. Binary in /usr/bin


6. Service created



🧠 Interview Insight

> “Package manager ensures dependency resolution and clean upgrades.”




---

8️⃣ System Startup (systemd)

How services actually run

Boot Flow:

BIOS → GRUB → Kernel → systemd → services

systemd basics:

systemctl status nginx
systemctl start nginx
systemctl enable nginx

Service files:

/usr/lib/systemd/system
/etc/systemd/system

🧠 Interview Insight

> “If a service fails at boot, I check unit file and journalctl.”




---

9️⃣ Users & SSH

Secure access to servers

User management:

useradd
usermod
userdel

SSH

Encrypted

Port 22

Key-based auth preferred


Secure SSH:

Disable root login

Use keys

Limit users


🧠 Interview Insight

> “SSH security is first line of defense in Linux.”




---

🔟 Automation (Bash)

Make Linux work for you

Admins automate, not repeat.

Bash used for:

Backups

Monitoring

Cleanup

Deployments


Automation tools:

bash

cron

systemd timers


Key concept:

> “If you run a command twice, script it.”



🧠 Interview Insight

> “Automation reduces human error and saves time.”




