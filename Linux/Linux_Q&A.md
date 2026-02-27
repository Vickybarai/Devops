# 🟩 **MODULE 1: Linux Fundamentals (Core Concepts)** — Detailed Answers for Interviews

---

**0 .Can you describe the end-to-end Linux boot process in detail, from the moment you press the power button to reaching the user login prompt? Please explain the role and interaction of components like BIOS/UEFI, MBR/ESP, GRUB, the Kernel, and systemd (or init) at each stage."

**answer:**

Power On and CPU Initialization:
When a computer or server is powered on, power is supplied to the motherboard and its components.
The CPU, acting as the "brain," is hardwired by the manufacturer to look for instructions at a fixed address called the Reset Vector.
This Reset Vector points to Non-Volatile Memory (ROM or Flash Memory) on the motherboard, which stores the BIOS or UEFI firmware.

2. BIOS/UEFI Firmware:
BIOS (Basic Input Output System) is used in older systems, while UEFI (Unified Extensible Firmware Interface) is used in modern systems. Both are firmware – special types of programs embedded in hardware.
Their primary tasks include:
POST (Power-On Self-Test): Checking and initializing hardware components to ensure they are in a healthy state.
Bootable Device Search: Once POST is successful, the firmware searches for a bootable device (e.g., SSD, HDD, USB drive).

3. MBR/ESP:
Once a bootable device is found, the firmware targets a specific section of its memory:
MBR (Master Boot Record): For BIOS-compatible devices, this is the first sector of the device, 512 bytes in size. It contains machine code instructions to help boot the machine, divided into:
Bootloader Code: Loads the second stage bootloader (like GRUB for Linux).
Partition Table: Informs the bootloader and OS about partition locations.
Boot Signature: Indicates a valid MBR.
ESP (EFI System Partition): For UEFI-compatible devices, this is a special partition on a GPT-formatted disk, typically 100-500 MB. It contains the executable files for the bootloader.

4. GRUB (Grand Unified Bootloader):
After MBR or ESP, the GRUB bootloader (specifically GRUB2, the modern version) is loaded into memory.
GRUB reads its configuration file, presents a text-based or graphical menu for OS selection, and then locates and loads the Linux kernel binary and the `initramfs` (initial RAM filesystem) image into RAM.

5. Kernel:
The Linux Kernel is the main and core component of the operating system, responsible for managing hardware and resources.
During boot, the compressed kernel is decompressed, and it starts running from within the temporary `initramfs` in RAM.
The `initramfs` provides essential drivers, modules, and scripts to help the kernel find and mount the permanent root filesystem.
Once the main root filesystem is mounted, the kernel shifts its operation to the main disk, discarding the temporary `initramfs`.
Finally, the kernel launches the first user-space process: `init` (for older systems) or `systemd` (for modern systems).

6. systemd/init:
systemd (or `init` in older systems) is the first process in user space, always having a Process ID (PID) of 1.
It initializes all required services and targets (or run levels in `init`) according to its configuration.
systemd brings up services in parallel, making the boot time faster, while `init` brought them up sequentially.
It manages services for the entire uptime of the system, bringing the system to a specified target (e.g., graphical mode, multi-user mode).

7. User Space:
This is the final stage where the user can interact with the operating system, run applications, scripts, and processes.
Meanwhile, the kernel continues to handle low-level tasks, including hardware and resource management, in the background
___

### **1. What is Linux? Difference between Linux, UNIX, and Windows?**

**Answer:**
Linux is a powerful, open-source operating system that supports multi-user and multi-tasking capabilities.
It allows multiple users to work on the same system at the same time and run multiple processes efficiently. Linux is widely used in servers, cloud platforms, and DevOps environments because it is secure, stable, and highly customizable.


**Key Differences:**

| Feature                | Linux                  | UNIX               | Windows                |
| ---------------------- | ---------------------- | ------------------ | ---------------------- |
| Type                   | Open-source            | Proprietary        | Proprietary            |
| Cost                   | Free                   | Paid               | Paid                   |
| Kernel                 | Monolithic             | Monolithic         | Hybrid                 |
| Command-line interface | Bash / Shell           | Shell              | CMD / PowerShell       |
| Target usage           | Servers, cloud, DevOps | Enterprise servers | Desktop, business apps |
| File system            | ext4, XFS, Btrfs       | UFS                | NTFS, FAT32            |

**Points to remember:**

* Linux is free and open-source.
* UNIX is older, mostly proprietary.
* Windows uses a GUI-heavy environment, Linux/UNIX are CLI-heavy but can also run GUI.

---

### **2. Explain Linux architecture (Kernel, Shell, User space)**

**Answer:**
Linux has **three main layers**:

1. **Kernel:** Core of the OS. Handles **CPU scheduling, memory management, device drivers, process management, file system management**.
2. **Shell:** Interface between user and kernel. Translates user commands to kernel instructions. Examples: `bash`, `zsh`, `sh`.
3. **User Space:** Everything outside the kernel. Includes **applications, libraries, scripts, and binaries**.

**Analogy:** Kernel = engine, Shell = steering wheel, User space = passengers using the car.

**Points to remember:**

* Kernel runs in **ring 0 (privileged mode)**, user space in **ring 3 (unprivileged mode)**.
* Commands typed in shell are processed through user space → kernel → hardware.

---

### **3. What happens when you type a command and press Enter?**

**Answer:**

1. **Input:** Shell reads your command from terminal.
2. **Parsing:** Shell interprets the command, checks syntax.
3. **Path search:** Shell searches for command binary in directories listed in `$PATH`.
4. **Execution:** Kernel creates a process and executes the command.
5. **Output:** Result is returned to shell and displayed on terminal.

**Example:** `ls` → shell finds `ls` binary → kernel executes → shows files in current directory.

**Points to remember:**

* Command execution = Shell → Kernel → Process → Output
* Built-in commands vs external binaries: Shell handles built-in directly.

---

### **4. What are environment variables? How to view/set them?**

**Answer:**
Environment variables are **key-value pairs** storing system info used by the shell and applications.

* Common examples: `PATH`, `HOME`, `USER`, `SHELL`.
* **View all:** `printenv` or `env`
* **View one:** `echo $PATH`
* **Set temporarily:** `export VAR=value` (lasts for session)
* **Set permanently:** Add to `~/.bashrc` or `~/.bash_profile`

**Points to remember:**

* `$` is used to access variable value.
* Temporary variables disappear after terminal closes.

---

### **5. What are absolute vs relative paths?**

**Answer:**

* **Absolute path:** Starts from root `/` and defines full location of a file.

  * Example: `/home/user/docs/file.txt`
* **Relative path:** Path relative to **current directory**.

  * Example: `docs/file.txt` if current directory is `/home/user`

**Points to remember:**

* Absolute path always starts with `/`.
* Relative path does **not start with `/`**, useful for shortcuts in scripts.

---

### **6. Explain Linux directory structure (/, /bin, /etc, /home, /var)**

**Answer:**

| Directory | Purpose                                 |
| --------- | --------------------------------------- |
| `/`       | Root of filesystem                      |
| `/bin`    | Essential command binaries (`ls`, `cp`) |
| `/etc`    | System configuration files              |
| `/home`   | User home directories (`/home/bhai`)    |
| `/var`    | Variable data like logs, mail, spool    |
| `/tmp`    | Temporary files                         |

**Points to remember:**

* `/usr` → user-installed programs.
* `/lib` → shared libraries.
* `/opt` → optional software packages.

---

### **7. What are the types of shells in Linux?**

**Answer:**

* **Bash:** Default on most Linux distros.
* **Sh:** Original Bourne shell.
* **Zsh:** Advanced features, scripting-friendly.
* **Ksh:** Korn shell.
* **Csh / Tcsh:** C-like syntax, rare now.

**Points to remember:**

* Bash = most commonly used.
* Shells differ mainly in scripting syntax and features.

---

### **8. What is the difference between shell and kernel?**

**Answer:**

* **Kernel:** Core OS, interacts directly with hardware.
* **Shell:** Command interpreter, talks to kernel for you.

**Analogy:** Kernel = engine, Shell = driver, User = passenger.

**Points to remember:**

* Kernel runs in **protected memory**.
* Shell is optional but necessary for CLI interaction.

---

### **9. Explain file system hierarchy — where are configs, binaries, and logs kept?**

**Answer:**

* **Binaries:** `/bin`, `/usr/bin`
* **Config files:** `/etc`
* **Logs:** `/var/log`
* **User data:** `/home`
* **Temporary files:** `/tmp`

**Points to remember:**

* Stick to **FS hierarchy standard (FHS)** for DevOps jobs.
* Important for backup and troubleshooting.

---

### **10. What is the difference between /root and /home directories?**

**Answer:**

* `/root` → home directory of **root user** (admin).
* `/home` → home directories for **normal users**.

**Points to remember:**

* Root has unlimited privileges.
* Regular users cannot modify `/root`.

---

### **11. What is a Linux Kernel? Why is it important?**

**Answer:**

* Kernel = core of Linux OS. Manages **processes, memory, devices, and system calls**.
* Without kernel, Linux **cannot interact with hardware or run programs**.

**Points to remember:**

* Monolithic kernel = single binary with modules.
* Handles low-level tasks, abstracts hardware for applications.

---

### **12. What is a shell in Linux, and how is it different from bash?**

**Answer:**

* **Shell:** Interface between user and kernel, executes commands.
* **Bash:** A type of shell (Bourne Again Shell) with scripting features.

**Points to remember:**

* Shells differ in **syntax, scripting capabilities, and features**.
* Bash is most common and interview-friendly.

---

### **13. Basic components of Linux OS**

**Answer:**

1. **Kernel** → core OS functions
2. **Shell** → command interpreter
3. **File system** → organizes storage
4. **User applications** → software, scripts, binaries

**Points to remember:**

* DevOps focus: understanding kernel + shell is most critical.

---

### **14. What is the init process in Linux?**

**Answer:**

* **Init (PID 1)** = first process started by kernel.
* Responsible for starting **services, daemons, and boot targets**.
* Modern Linux uses **systemd** instead of old init scripts.

**Points to remember:**

* `systemctl` commands interact with systemd.
* Init ensures system boots to a usable state.

---

### **15. What is root?**

**Answer:**

* Root = **superuser** with unlimited privileges.
* Can read/write all files, manage users, install software, and modify system configs.

**Points to remember:**

* Avoid logging in as root directly in production.
* Use `sudo` for safer admin access.

---

### **16. Check hostname**

```bash
hostname
```

**Points to remember:**

* Shows system’s network name.
* Useful in server identification in DevOps.

---

### **17. Check current user**

```bash
whoami
```

**Points to remember:**

* Shows the username of the session currently logged in.
* `id` command also gives UID, GID, and groups.

---

### **18. Check current working directory**

```bash
pwd
```

===


# 🟨 **MODULE 2: File Management & Permissions** — Detailed Answers

---

### **19. What are file permissions (rwx)? Explain chmod 755 vs 777**

**Answer:**

* Linux file permissions control **who can read, write, or execute** a file.
* **rwx**:

  * `r` = read
  * `w` = write
  * `x` = execute
* Permissions apply to: **user (owner), group, others**.

**Numeric representation:**

* r = 4, w = 2, x = 1
* Add for each category (user/group/others)

**Examples:**

* `chmod 755 file` →

  * Owner = 7 → rwx
  * Group = 5 → r-x
  * Others = 5 → r-x
* `chmod 777 file` →

  * Everyone = rwx → full access

**Points to remember:**

* `chmod` changes permissions.
* Avoid 777 on production files — security risk.

---

### **20. Types of permissions (Read, Write, Execute)**

**Answer:**

| Permission  | Effect              |
| ----------- | ------------------- |
| Read (r)    | View file content   |
| Write (w)   | Modify file content |
| Execute (x) | Run file/script     |

**Points to remember:**

* Directories use **execute (x)** to enter/access.
* rwx can be combined: rw- → read + write.

---

### **21. What is the difference between a Soft Link and a Hard Link?**

**Answer:**

* **Hard Link:** Points directly to the file inode.

  * Acts as the same file.
  * Deleting original file → hard link still works.
* **Soft Link (symbolic link):** Points to the filename.

  * Acts like a shortcut.
  * Deleting original file → soft link broken.

**Commands:**

```bash
ln file1 file_hardlink      # Hard link
ln -s file1 file_symlink    # Soft link
```

**Points to remember:**

* Use **soft links for directories**.
* Hard links cannot span different file systems.

---

### **22. How do you change file ownership and group (chown, chgrp)?**

**Answer:**

* **chown** → change owner
* **chgrp** → change group

**Examples:**

```bash
chown bhai file.txt        # Change owner to bhai
chown bhai:devops file.txt # Change owner and group
chgrp devops file.txt       # Change only group
```

**Points to remember:**

* Only **root** or sudo user can change ownership.
* Important for multi-user environments.

---

### **23. What is umask? What does it control?**

**Answer:**

* **umask** = default permission mask for newly created files/directories.
* Subtracts from default permission (666 for files, 777 for directories).

**Example:**

```bash
umask 022
# New file permission = 644 (666-022)
# New dir permission = 755 (777-022)
```

**Points to remember:**

* Controls **default security of new files**.
* Check current umask: `umask`

---

### **24. What is the sticky bit and where is it used (/tmp example)?**

**Answer:**

* **Sticky bit**: Special permission on directories.
* Only file owner can delete their files, even if others have write permission.

**Example:** `/tmp` directory:

```bash
drwxrwxrwt  14 root root  4096 Jan 26  /tmp
```

* `t` at the end = sticky bit set

**Points to remember:**

* Common in **shared directories**.
* Prevents accidental deletion by other users.

---

### **25. What are /etc/passwd, /etc/shadow, and /etc/group used for?**

**Answer:**

* `/etc/passwd` → stores **user account info** (username, UID, GID, home, shell)
* `/etc/shadow` → stores **encrypted passwords** (accessible by root only)
* `/etc/group` → stores **group info** (group name, GID, members)

**Points to remember:**

* Never give write access to regular users.
* Core files for authentication and user management.

---

### **26. What is the difference between su and sudo?**

**Answer:**

* **su** (switch user) → login as another user (full session)
* **sudo** → execute a single command as another user (typically root)

**Examples:**

```bash
su - root         # switch to root
sudo apt update   # run command as root
```

**Points to remember:**

* `sudo` is safer; logs all commands.
* `su` gives full root session.

---

### **27. How do you safely edit the sudoers file (visudo)?**

**Answer:**

* Use `visudo` command → safely edits `/etc/sudoers`
* Prevents syntax errors which can lock out sudo access

```bash
sudo visudo
```

**Points to remember:**

* Never edit `/etc/sudoers` directly with `vim` or `nano`.
* Add user like: `bhai ALL=(ALL) NOPASSWD:ALL`

---

### **28. How do you find recently modified files (find -mtime)?**

**Answer:**

```bash
find /path -type f -mtime -1   # files modified in last 1 day
find /path -type f -mtime +7   # files older than 7 days
```

**Points to remember:**

* `-mtime` = modification time in days
* `-mmin` = modification time in minutes

---

### **29. What are hidden files, and how to view them (ls -a)?**

**Answer:**

* Hidden files start with `.` (dot), like `.bashrc`
* Command to view:

```bash
ls -a
```

**Points to remember:**

* Dot files often store **configs**.
* `ls -la` → view permissions, owner, size for hidden files.

---

### **30. Change file permissions using chmod**

**Answer:**

```bash
chmod 644 file.txt   # owner read/write, others read-only
chmod +x script.sh   # add execute permission
chmod -x script.sh   # remove execute permission
```

**Points to remember:**

* Numeric mode (644, 755, 777)
* Symbolic mode (+x, -x, u+w, g-r)

---

### **31. Permissions to execute a script**

**Answer:**

* Scripts need **execute (x)** permission to run:

```bash
chmod +x script.sh
./script.sh
```

**Points to remember:**

* Can also run with interpreter: `bash script.sh` without +x
* Use execute permission for safety.

---

### **32. Create/manage symbolic links**

**Answer:**

* **Create:**

```bash
ln -s target_file link_name
```

* **Check link:**

```bash
ls -l
```

* **Delete link:**

```bash
rm link_name
```

**Points to remember:**

* Soft links can point to files or directories.
* Hard links cannot point across different filesystems.

===

# 🟧 **MODULE 3: Process & System Management** — Detailed Answers

---

### **33. What is a process?**

**Answer:**

* A **process** is an instance of a program in execution.
* Every command you run in Linux (like `ls`, `vim`) becomes a process.
* Each process has: **PID (Process ID), owner, state, memory, CPU usage**.

**Command to check processes:**

```bash
ps aux
top
htop
```

**Points to remember:**

* Every process is created by a **parent process** (PPID).
* Processes can run **foreground** or **background**.

---

### **34. Difference between process and thread**

| Feature      | Process                                 | Thread                                 |
| ------------ | --------------------------------------- | -------------------------------------- |
| Definition   | Independent program in execution        | Lightweight unit inside a process      |
| Memory       | Has own memory                          | Shares memory with parent process      |
| Creation     | More resource-intensive                 | Less resource-intensive                |
| Crash impact | One process crash may not affect others | Thread crash may affect entire process |

**Points to remember:**

* Threads = multiple tasks inside same process.
* Processes = isolated and safer, heavier.

---

### **35. Explain ps, top, and htop commands**

**Answer:**

* `ps` → snapshots of running processes

  ```bash
  ps aux | grep process_name
  ```
* `top` → real-time process monitoring (CPU, memory, PID)

  ```bash
  top
  ```
* `htop` → interactive top (needs installation)

  ```bash
  sudo apt install htop
  htop
  ```

**Points to remember:**

* `ps` = static view, `top/htop` = dynamic view.
* `htop` allows sorting, killing processes interactively.

---

### **36. What is a Zombie process and how do you handle it?**

**Answer:**

* A **zombie process** is a dead process that has **finished execution but still has an entry in the process table**.
* Usually parent hasn’t read its exit status.

**Identify zombie:**

```bash
ps aux | grep Z
```

**Handle zombie:**

* Kill parent process (if safe) → zombie removed.
* Typically harmless unless many accumulate.

**Points to remember:**

* Zombie ≠ using CPU, just occupies **PID table**.
* Orphaned zombies handled by `init` process.

---

### **37. Difference between kill and kill -9**

| Command       | Effect                                                  |
| ------------- | ------------------------------------------------------- |
| `kill PID`    | Sends **SIGTERM** → graceful termination                |
| `kill -9 PID` | Sends **SIGKILL** → force termination, cannot be caught |

**Points to remember:**

* Always try normal `kill` first.
* Use `kill -9` only if process is stuck.

---

### **38. How do you run a process in the background (&, nohup, screen)?**

**Answer:**

* **`&`** → run process in background:

```bash
sleep 100 &
```

* **`nohup`** → run process ignoring hangups:

```bash
nohup python script.py &
```

* **`screen` or `tmux`** → persistent session even after logout

**Points to remember:**

* Use `jobs` to list background jobs.
* `fg %1` → bring job 1 to foreground.

---

### **39. What is the purpose of nice and renice?**

**Answer:**

* **nice** → sets **priority** of a process at start
* **renice** → changes priority of a running process

**Command example:**

```bash
nice -n 10 python script.py   # lower priority
renice -n 5 -p 1234           # change PID 1234 priority
```

**Points to remember:**

* Lower numeric value = higher priority (-20 highest, +19 lowest).
* Helps manage CPU in multi-process environment.

---

### **40. How to check which process is consuming the most CPU/memory?**

**Answer:**

* Using `top` or `htop` → sort by `%CPU` or `%MEM`.
* Using `ps` → one-liner:

```bash
ps aux --sort=-%cpu | head -5
ps aux --sort=-%mem | head -5
```

**Points to remember:**

* Top resource-consuming processes are key to troubleshoot slow systems.

---

### **41. What is load average? Interpret uptime output**

**Answer:**

* Load average = average number of **processes waiting for CPU** over 1, 5, 15 minutes.
* Example:

```bash
uptime
# 12:00:01 up 10 days,  3:24,  3 users,  load average: 0.20, 0.15, 0.10
```

* 0.2 → low load, 1 → fully utilized, > number of CPU cores → overloaded

**Points to remember:**

* Compare load average to **number of CPU cores**.
* High load + low CPU utilization → likely I/O bound.

---

### **42. Explain swap memory and when it’s used**

**Answer:**

* **Swap** = disk space used as virtual memory when RAM is full.
* Helps prevent out-of-memory (OOM) errors.

**Commands:**

```bash
swapon -s       # list swap
free -h         # check memory and swap
```

**Points to remember:**

* Swap is slower than RAM.
* Should be sized ~ RAM size or based on workload.

---

### **43. Check running processes**

**Answer:**

```bash
ps aux            # list all processes
top               # dynamic monitoring
htop              # interactive monitoring
pgrep process_name # find PID
```

**Points to remember:**

* Use `ps` + `grep` to find specific process.
* Useful in automation scripts.

---

### **44. Terminate process**

**Answer:**

```bash
kill PID          # graceful termination
kill -9 PID       # force termination
pkill process_name # kill by name
```

**Points to remember:**

* Always identify process before killing.
* Use `jobs`, `ps`, `top` to confirm PID.

===
# 📦 MODULE 4: Disk, Filesystem & Storage

**Difficulty:** Moderate
**Interview Ask Rate:** 95–85%

---

### **45. How do you check disk usage in Linux?**

Disk usage can be checked at two levels:

* **Filesystem level** → `df`
* **Directory/file level** → `du`

```bash
df -h
```

```bash
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G   12G  7.5G  62% /
```

```bash
du -sh /var/log
```

```bash
150M    /var/log
```

---

### **46. Disk shows space available but error says “No space left on device” — why?**

This usually happens due to **inode exhaustion**.

Linux stores file metadata in **inodes**.
If all inodes are used, new files cannot be created even if disk space is free.

```bash
df -i
```

```bash
Filesystem      Inodes  IUsed   IFree IUse% Mounted on
/dev/xvda1     1310720 1310720      0  100% /
```

---

### **47. Difference between disk full and inode full**

| Disk Full                 | Inode Full                      |
| ------------------------- | ------------------------------- |
| No storage space left     | No file metadata left           |
| Large files consume space | Many small files consume inodes |
| Checked via `df -h`       | Checked via `df -i`             |

---

### **48. How do you check disk partitions?**

```bash
lsblk
```

```bash
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda   202:0    0   20G  0 disk
└─xvda1        20G  0 part /
```

```bash
fdisk -l
```

---

### **49. What is `/etc/fstab` and its purpose?**

`/etc/fstab` defines **filesystems that mount automatically at boot**.

```bash
cat /etc/fstab
```

```bash
UUID=abc123  /data  ext4  defaults  0 2
```

Used for:

* Persistent mounts
* Network storage
* LVM volumes

---

### **50. How do you check if a disk is mounted?**

```bash
mount | grep data
```

```bash
/dev/xvdb on /data type ext4 (rw,relatime)
```

```bash
df -h | grep data
```

---

### **51. How do you mount and unmount a filesystem manually?**

```bash
mount /dev/xvdb /data
```

```bash
umount /data
```

Check mount status:

```bash
mount | grep xvdb
```

---

### **52. What is LVM? What are its advantages?**

**LVM (Logical Volume Manager)** allows flexible disk management.

Advantages:

* Resize volumes online
* Combine multiple disks
* Snapshot support
* Easier storage expansion

```bash
lvdisplay
```

---

### **53. Difference between ext4, xfs, and btrfs**

| Filesystem | Key Feature                   |
| ---------- | ----------------------------- |
| ext4       | Stable, general purpose       |
| xfs        | High performance, large files |
| btrfs      | Snapshot, compression         |

---

### **54. How do you find which directory is using the most space?**

```bash
du -h / | sort -hr | head -10
```

```bash
5.2G    /var
3.1G    /usr
```

---

### **55. How do you read first or last N lines of a file?**

```bash
head -5 file.txt
```

```bash
tail -5 file.txt
```

---

### **56. How do you combine two files into one?**

```bash
cat file1.txt file2.txt > file3.txt
```

---

### **57. How do you find the file type in Linux?**

```bash
file script.sh
```

```bash
script.sh: Bourne-Again shell script
```

---

### **58. How do you sort file content?**

```bash
sort names.txt
```

```bash
Amit
Rahul
Vicky
```

Reverse sort:

```bash
sort -r names.txt
```

---


# 🌐 MODULE 5: Networking & Connectivity

### **59. How do you check which ports are listening on a Linux server?**

Listening ports show which services are actively accepting connections.

```bash
ss -lntp
```

```bash
State   Recv-Q  Send-Q  Local Address:Port  Process
LISTEN  0       128     0.0.0.0:22         sshd
LISTEN  0       128     0.0.0.0:80         nginx
```

Alternative:

```bash
netstat -lntp
```

---

### **60. How do you check if a remote server is reachable on a specific port?**

Use `telnet` or `nc`.

```bash
telnet google.com 80
```

```bash
Connected to google.com
```

Using netcat:

```bash
nc -zv google.com 443
```

```bash
Connection to google.com 443 succeeded!
```

---

### **61. What is the SSH configuration file location?**

System-wide SSH config:

```bash
/etc/ssh/sshd_config
```

Client-side config:

```bash
~/.ssh/config
```

---

### **62. How do SSH keys work?**

SSH uses **public and private key authentication**.

Process:

1. Private key stays on client
2. Public key stored on server
3. Server verifies key instead of password

```bash
ssh-keygen
```

```bash
id_rsa
id_rsa.pub
```

---

### **63. Difference between curl and wget**

| curl                    | wget               |
| ----------------------- | ------------------ |
| API testing             | File download      |
| Supports many protocols | Mainly HTTP/FTP    |
| Used in scripts         | Used for downloads |

```bash
curl -I https://google.com
```

```bash
HTTP/2 200
```

```bash
wget https://example.com/file.zip
```

---

### **64. How do you check and restart the network service?**

```bash
systemctl status NetworkManager
```

```bash
systemctl restart NetworkManager
```

---

### **65. Explain `/etc/hosts` and `/etc/resolv.conf`**

`/etc/hosts` → Local hostname to IP mapping

```bash
127.0.0.1   localhost
```

`/etc/resolv.conf` → DNS servers

```bash
nameserver 8.8.8.8
```

---

### **66. How do you add a static route temporarily and permanently?**

Temporary:

```bash
ip route add 10.0.0.0/24 via 192.168.1.1
```

Permanent:

```bash
/etc/sysconfig/network-scripts/route-eth0
```

---

### **67. What is the TCP 3-way handshake?**

Steps:

1. SYN → Client requests connection
2. SYN-ACK → Server acknowledges
3. ACK → Connection established

Used to ensure **reliable communication**.

---

### **68. How do you check DNS resolution issues?**

```bash
nslookup google.com
```

```bash
Server: 8.8.8.8
Address: 142.250.190.78
```

```bash
dig google.com
```

---

### **69. How do you check if an IP or server is reachable?**

```bash
ping google.com
```

```bash
64 bytes from google.com: icmp_seq=1 ttl=117
```

---

### **70. How do you get information about open ports?**

```bash
netstat -l
```

---

### **71. How do you check a specific open port?**

```bash
netstat -putan | grep 80
```

```bash
tcp   0   0 0.0.0.0:80   LISTEN
```

---

### **72. How do you check network interfaces?**

```bash
ifconfig
```

or

```bash
ip addr
```

```bash
eth0: inet 192.168.1.10
```

---

### **73. Difference between Telnet and SSH**

| Telnet     | SSH       |
| ---------- | --------- |
| Plain text | Encrypted |
| Insecure   | Secure    |
| Port 23    | Port 22   |


# 🌐 MODULE 5: Networking & Connectivity

**Level:** Beginner → Intermediate
**Interview Ask Rate:** 90–80%

---

### **59. How do you check which ports are listening on a Linux server?**

Listening ports show which services are actively accepting connections.

```bash
ss -lntp
```

```bash
State   Recv-Q  Send-Q  Local Address:Port  Process
LISTEN  0       128     0.0.0.0:22         sshd
LISTEN  0       128     0.0.0.0:80         nginx
```

Alternative:

```bash
netstat -lntp
```

---

### **60. How do you check if a remote server is reachable on a specific port?**

Use `telnet` or `nc`.

```bash
telnet google.com 80
```

```bash
Connected to google.com
```

Using netcat:

```bash
nc -zv google.com 443
```

```bash
Connection to google.com 443 succeeded!
```

---

### **61. What is the SSH configuration file location?**

System-wide SSH config:

```bash
/etc/ssh/sshd_config
```

Client-side config:

```bash
~/.ssh/config
```

---

### **62. How do SSH keys work?**

SSH uses **public and private key authentication**.

Process:

1. Private key stays on client
2. Public key stored on server
3. Server verifies key instead of password

```bash
ssh-keygen
```

```bash
id_rsa
id_rsa.pub
```

---

### **63. Difference between curl and wget**

| curl                    | wget               |
| ----------------------- | ------------------ |
| API testing             | File download      |
| Supports many protocols | Mainly HTTP/FTP    |
| Used in scripts         | Used for downloads |

```bash
curl -I https://google.com
```

```bash
HTTP/2 200
```

```bash
wget https://example.com/file.zip
```

---

### **64. How do you check and restart the network service?**

```bash
systemctl status NetworkManager
```

```bash
systemctl restart NetworkManager
```

---

### **65. Explain `/etc/hosts` and `/etc/resolv.conf`**

`/etc/hosts` → Local hostname to IP mapping

```bash
127.0.0.1   localhost
```

`/etc/resolv.conf` → DNS servers

```bash
nameserver 8.8.8.8
```

---

### **66. How do you add a static route temporarily and permanently?**

Temporary:

```bash
ip route add 10.0.0.0/24 via 192.168.1.1
```

Permanent:

```bash
/etc/sysconfig/network-scripts/route-eth0
```

---

### **67. What is the TCP 3-way handshake?**

Steps:

1. SYN → Client requests connection
2. SYN-ACK → Server acknowledges
3. ACK → Connection established

Used to ensure **reliable communication**.

---

### **68. How do you check DNS resolution issues?**

```bash
nslookup google.com
```

```bash
Server: 8.8.8.8
Address: 142.250.190.78
```

```bash
dig google.com
```

---

### **69. How do you check if an IP or server is reachable?**

```bash
ping google.com
```

```bash
64 bytes from google.com: icmp_seq=1 ttl=117
```

---

### **70. How do you get information about open ports?**

```bash
netstat -l
```

---

### **71. How do you check a specific open port?**

```bash
netstat -putan | grep 80
```

```bash
tcp   0   0 0.0.0.0:80   LISTEN
```

---

### **72. How do you check network interfaces?**

```bash
ifconfig
```

or

```bash
ip addr
```

```bash
eth0: inet 192.168.1.10
```

---

### **73. Difference between Telnet and SSH**

| Telnet     | SSH       |
| ---------- | --------- |
| Plain text | Encrypted |
| Insecure   | Secure    |
| Port 23    | Port 22   |

---


# 🌐 MODULE 5: Networking & Connectivity

**Level:** Beginner → Intermediate
**Interview Ask Rate:** 90–80%

---

### **59. How do you check which ports are listening on a Linux server?**

Listening ports show which services are actively accepting connections.

```bash
ss -lntp
```

```bash
State   Recv-Q  Send-Q  Local Address:Port  Process
LISTEN  0       128     0.0.0.0:22         sshd
LISTEN  0       128     0.0.0.0:80         nginx
```

Alternative:

```bash
netstat -lntp
```

---

### **60. How do you check if a remote server is reachable on a specific port?**

Use `telnet` or `nc`.

```bash
telnet google.com 80
```

```bash
Connected to google.com
```

Using netcat:

```bash
nc -zv google.com 443
```

```bash
Connection to google.com 443 succeeded!
```

---

### **61. What is the SSH configuration file location?**

System-wide SSH config:

```bash
/etc/ssh/sshd_config
```

Client-side config:

```bash
~/.ssh/config
```

---

### **62. How do SSH keys work?**

SSH uses **public and private key authentication**.

Process:

1. Private key stays on client
2. Public key stored on server
3. Server verifies key instead of password

```bash
ssh-keygen
```

```bash
id_rsa
id_rsa.pub
```

---

### **63. Difference between curl and wget**

| curl                    | wget               |
| ----------------------- | ------------------ |
| API testing             | File download      |
| Supports many protocols | Mainly HTTP/FTP    |
| Used in scripts         | Used for downloads |

```bash
curl -I https://google.com
```

```bash
HTTP/2 200
```

```bash
wget https://example.com/file.zip
```

---

### **64. How do you check and restart the network service?**

```bash
systemctl status NetworkManager
```

```bash
systemctl restart NetworkManager
```

---

### **65. Explain `/etc/hosts` and `/etc/resolv.conf`**

`/etc/hosts` → Local hostname to IP mapping

```bash
127.0.0.1   localhost
```

`/etc/resolv.conf` → DNS servers

```bash
nameserver 8.8.8.8
```

---

### **66. How do you add a static route temporarily and permanently?**

Temporary:

```bash
ip route add 10.0.0.0/24 via 192.168.1.1
```

Permanent:

```bash
/etc/sysconfig/network-scripts/route-eth0
```

---

### **67. What is the TCP 3-way handshake?**

Steps:

1. SYN → Client requests connection
2. SYN-ACK → Server acknowledges
3. ACK → Connection established

Used to ensure **reliable communication**.

---

### **68. How do you check DNS resolution issues?**

```bash
nslookup google.com
```

```bash
Server: 8.8.8.8
Address: 142.250.190.78
```

```bash
dig google.com
```

---

### **69. How do you check if an IP or server is reachable?**

```bash
ping google.com
```

```bash
64 bytes from google.com: icmp_seq=1 ttl=117
```

---

### **70. How do you get information about open ports?**

```bash
netstat -l
```

---

### **71. How do you check a specific open port?**

```bash
netstat -putan | grep 80
```

```bash
tcp   0   0 0.0.0.0:80   LISTEN
```

---

### **72. How do you check network interfaces?**

```bash
ifconfig
```

or

```bash
ip addr
```

```bash
eth0: inet 192.168.1.10
```

---

### **73. Difference between Telnet and SSH**

| Telnet     | SSH       |
| ---------- | --------- |
| Plain text | Encrypted |
| Insecure   | Secure    |
| Port 23    | Port 22   |

---

# 🌐 MODULE 5: Networking & Connectivity


### **59. How do you check which ports are listening on a Linux server?**

Listening ports show which services are actively accepting connections.

```bash
ss -lntp
```

```bash
State   Recv-Q  Send-Q  Local Address:Port  Process
LISTEN  0       128     0.0.0.0:22         sshd
LISTEN  0       128     0.0.0.0:80         nginx
```

Alternative:

```bash
netstat -lntp
```

---

### **60. How do you check if a remote server is reachable on a specific port?**

Use `telnet` or `nc`.

```bash
telnet google.com 80
```

```bash
Connected to google.com
```

Using netcat:

```bash
nc -zv google.com 443
```

```bash
Connection to google.com 443 succeeded!
```

---

### **61. What is the SSH configuration file location?**

System-wide SSH config:

```bash
/etc/ssh/sshd_config
```

Client-side config:

```bash
~/.ssh/config
```

---

### **62. How do SSH keys work?**

SSH uses **public and private key authentication**.

Process:

1. Private key stays on client
2. Public key stored on server
3. Server verifies key instead of password

```bash
ssh-keygen
```

```bash
id_rsa
id_rsa.pub
```

---

### **63. Difference between curl and wget**

| curl                    | wget               |
| ----------------------- | ------------------ |
| API testing             | File download      |
| Supports many protocols | Mainly HTTP/FTP    |
| Used in scripts         | Used for downloads |

```bash
curl -I https://google.com
```

```bash
HTTP/2 200
```

```bash
wget https://example.com/file.zip
```

---

### **64. How do you check and restart the network service?**

```bash
systemctl status NetworkManager
```

```bash
systemctl restart NetworkManager
```

---

### **65. Explain `/etc/hosts` and `/etc/resolv.conf`**

`/etc/hosts` → Local hostname to IP mapping

```bash
127.0.0.1   localhost
```

`/etc/resolv.conf` → DNS servers

```bash
nameserver 8.8.8.8
```

---

### **66. How do you add a static route temporarily and permanently?**

Temporary:

```bash
ip route add 10.0.0.0/24 via 192.168.1.1
```

Permanent:

```bash
/etc/sysconfig/network-scripts/route-eth0
```

---

### **67. What is the TCP 3-way handshake?**

Steps:

1. SYN → Client requests connection
2. SYN-ACK → Server acknowledges
3. ACK → Connection established

Used to ensure **reliable communication**.

---

### **68. How do you check DNS resolution issues?**

```bash
nslookup google.com
```

```bash
Server: 8.8.8.8
Address: 142.250.190.78
```

```bash
dig google.com
```

---

### **69. How do you check if an IP or server is reachable?**

```bash
ping google.com
```

```bash
64 bytes from google.com: icmp_seq=1 ttl=117
```

---

### **70. How do you get information about open ports?**

```bash
netstat -l
```

---

### **71. How do you check a specific open port?**

```bash
netstat -putan | grep 80
```

```bash
tcp   0   0 0.0.0.0:80   LISTEN
```

---

### **72. How do you check network interfaces?**

```bash
ifconfig
```

or

```bash
ip addr
```

```bash
eth0: inet 192.168.1.10
```

---

### **73. Difference between Telnet and SSH**

| Telnet     | SSH       |
| ---------- | --------- |
| Plain text | Encrypted |
| Insecure   | Secure    |
| Port 23    | Port 22   |

---

## ✅ Beginner Interview Strategy (Important)

If interviewer asks networking:

* First **check connectivity** (ping)
* Then **check port** (ss / netstat)
* Then **check service**
* Then **check firewall/DNS**
