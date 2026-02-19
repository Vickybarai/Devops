## 1️⃣ File System: Where everything lives

Linux stores files in a **hierarchical structure**. Knowing this is key for debugging, backups, and automation.

| Directory | Purpose | Example Files |
|-----------|---------|---------------|
| `/`       | Root of all filesystems | /bin, /etc, /home, /var |
| `/bin`   | Essential binaries for all users | ls, cp, mv, cat |
| `/sbin`  | System binaries (root only) | ifconfig, fdisk, ip |
| `/etc`   | Configuration files | passwd, ssh/sshd_config |
| `/var`   | Variable data like logs, caches | /var/log/syslog, /var/log/messages |
| `/home`  | User home directories | /home/bhai, /home/user1 |
| `/tmp`   | Temporary files | tmp uploads, script temp files |
| `/usr`   | User-installed programs | /usr/bin, /usr/lib |
| `/opt`   | Optional software packages | /opt/java, /opt/docker |

**Commands to explore:**
```bash
ls -l /etc        # List configs
ls -l /var/log    # Check logs
file /bin/ls      # Identify file type

Explanation:

Logs → /var/log (syslog, auth.log, kernel logs)

Configs → /etc (service configs, user settings)

Binaries → /bin, /sbin, /usr/bin (who runs what, system or user)



---

2️⃣ Permissions & Ownership: Fix 80% of access issues

Linux permissions control who can read/write/execute files. Most access problems come from misconfigured ownership or permissions.

Permissions structure: rwxr-xr--

Owner → first 3 chars

Group → next 3 chars

Others → last 3 chars


Commands:

ls -l filename                  # View permissions and owner
chmod 755 filename              # Owner rwx, group rx, others rx
chown user:group filename       # Change file owner & group
getfacl filename                # View detailed ACLs

Soft vs Hard Links:

ln -s /path/to/file linkname    # Soft link (can cross filesystems)
ln /path/to/file hardlink       # Hard link (same inode, same filesystem)

Explanation:

Most permission issues: wrong owner/group or missing execute (x) for scripts

Sticky bit: /tmp → prevents deletion of files by non-owners

setuid/setgid → run a program as the file owner/group



---

3️⃣ Processes & Services: Understand what’s running

Processes are running programs, and services/daemons run in the background.

Commands to monitor processes:

ps -ef                         # List all processes with PID & owner
top                             # Dynamic CPU/memory monitor
htop                            # Interactive process viewer
kill PID                        # Terminate process gracefully
kill -9 PID                      # Force kill

Services (systemd):

systemctl status sshd           # Check service status
systemctl start httpd           # Start service
systemctl stop httpd            # Stop service
systemctl enable sshd           # Auto-start at boot
systemctl disable sshd          # Disable at boot
journalctl -u sshd              # View logs for service

Explanation:

Use ps/top/htop to identify resource-hogging processes

Services controlled by systemd run in background → understanding targets helps debug startup



---

4️⃣ Logs & Debugging: Find the real cause

Logs reveal issues in system, kernel, apps, and users.

Important log files:

/var/log/syslog        # System messages
/var/log/messages      # Kernel & system
/var/log/auth.log      # Authentication and sudo logs
/var/log/boot.log      # Boot messages
/var/log/httpd/        # Webserver logs

Commands:

tail -f /var/log/syslog       # Real-time log viewing
grep "error" /var/log/syslog  # Filter logs for issues
less /var/log/auth.log         # Navigate large logs
journalctl -xe                # systemd errors

Explanation:

Logs are first place to debug failures

journalctl → systemd logs, centralized

grep + tail -f → monitor for live errors



---

5️⃣ Networking Basics: Ports, DNS, IPs, Firewalls

Networking is key for server connectivity and troubleshooting.

Commands:

ip addr                       # Check IP addresses
ping 8.8.8.8                   # Test connectivity
netstat -tuln                  # Listening ports
ss -tulnp                      # Advanced port info
telnet host port               # Test port connectivity
curl -I http://example.com     # Test HTTP connectivity

DNS & Hosts:

cat /etc/resolv.conf            # Check DNS servers
cat /etc/hosts                  # Static hostname resolution

Firewall (iptables / firewalld):

sudo iptables -L                # List firewall rules
sudo firewall-cmd --list-all    # List firewalld rules

Explanation:

Know which ports are open and services bound

Test connectivity before blaming applications

Understand routing & DNS resolution



---

6️⃣ Disk & Memory: Why systems slow down or crash

Check disk usage:

df -h                          # Disk usage by filesystem
du -sh /var/log/*               # Directory size
lsblk                           # Partition info
fdisk -l                        # Disk partition layout

Check memory:

free -h                        # RAM usage
vmstat 1 5                      # Memory & CPU stats
top                             # See top memory processes

Explanation:

Disk full vs inode full → “No space left on device”

Memory leaks → top + ps to locate culprit process



---

7️⃣ Package Management: How software is installed

Debian/Ubuntu (APT):

sudo apt update                 # Update repo info
sudo apt install nginx          # Install software
dpkg -l                         # List installed packages

RHEL/CentOS (YUM/DNF):

sudo yum install httpd
rpm -qa                         # List installed packages

Explanation:

Know how packages install binaries, configs, and dependencies

Always check service after installation



---

8️⃣ System Startup (systemd): How services run

Boot sequence: BIOS → GRUB → Kernel → init/systemd → targets → services

Common commands:

systemctl list-units --type=target
systemctl list-unit-files       # All services
systemctl reboot                 # Reboot system
systemctl isolate multi-user.target # Change runlevel

Explanation:

Targets = runlevels → define which services start

Custom services: /etc/systemd/system/myservice.service

Debug logs: journalctl -u myservice



---

9️⃣ Users & SSH: Secure access to servers

User management:

sudo adduser bhai
sudo passwd bhai
sudo usermod -aG sudo bhai     # Add to sudo
sudo deluser bhai

SSH access:

ssh bhai@server-ip
ssh-keygen -t rsa -b 4096
ssh-copy-id bhai@server-ip
sudo nano /etc/ssh/sshd_config   # Disable root login, set port
systemctl restart sshd

Explanation:

SSH keys → passwordless & secure login

Always check /etc/ssh/sshd_config for security settings

Limit root & use sudo



---

🔟 Automation (Bash): Make Linux work for you

Cron jobs:

crontab -l                        # List cron jobs
crontab -e                        # Edit cron jobs
# Format: min hour day month day_of_week command
0 2 * * * /usr/bin/backup.sh      # Daily backup at 2 AM

Basic scripting:

#!/bin/bash
# Monitor disk usage
THRESHOLD=80
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $USAGE -gt $THRESHOLD ]; then
  echo "Disk usage above threshold" | mail -s "Alert" admin@example.com
fi

Explanation:

Automate backups, monitoring, and alerts

Use cron + bash scripts → prevent manual errors

