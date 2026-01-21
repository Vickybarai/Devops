


# Linux File System – Tree Structure (Quick Reference)

Understanding the Linux filesystem hierarchy is critical for system administration,
DevOps troubleshooting, and interview preparation.  
If you understand this tree, Linux debugging becomes **10x easier**.

---

## 📁 Linux File System Tree

/
├── bin/        # Essential user commands (ls, cp, mv, cat)
├── sbin/       # System administration commands (reboot, fsck, ip)
├── etc/        # System and application configuration files
├── home/       # Home directories for normal users
│   └── user/   # Example: /home/ubuntu
├── root/       # Home directory of root user
├── var/        # Variable data (logs, cache, mail, spool)
│   └── log/    # System and application logs
├── usr/        # User programs, binaries, libraries, docs
│   ├── bin/    # Non-essential user commands
│   ├── sbin/   # Admin commands
│   └── lib/    # Libraries for /usr binaries
├── lib/        # Shared libraries for /bin and /sbin
├── tmp/        # Temporary files (auto-cleaned)
├── opt/        # Optional / third-party software
├── run/        # Runtime data (PID files, sockets)
├── proc/       # Virtual filesystem (process & system info)
├── sys/        # Kernel and hardware information
├── dev/        # Device files (disk, USB, memory)
├── mnt/        # Temporary mount point
├── media/      # Auto-mounted removable devices
└── boot/       # Bootloader and kernel files

---

## 📌 Directory Purpose Explained (Simple)

### `/`
Root of the filesystem. Everything starts here.

### `/bin`
Essential commands required for system operation and recovery.

### `/sbin`
System-level commands used by administrators.

### `/etc`
Configuration files for OS, services, and applications.

### `/home`
User personal directories and files.

### `/root`
Root user's private home directory.

### `/var`
Frequently changing data like logs and cache.

### `/var/log`
Critical system and application logs (debugging hotspot).

### `/usr`
Installed programs and libraries.

### `/lib`
Libraries needed by essential system commands.

### `/tmp`
Temporary files; safe to clean.

### `/opt`
External or custom software installations.

### `/run`
Runtime state information created after boot.

### `/proc`
Live system and process information (virtual filesystem).

### `/sys`
Kernel and hardware control interface.

### `/dev`
Device representation as files.

### `/mnt`
Manual mount point.

### `/media`
Auto-mounted removable devices.

### `/boot`
Kernel and bootloader required to start Linux.

---

## 🧠 Interview Quick Logic

- `/bin` → critical commands
- `/usr/bin` → non-critical user tools
- `/var/log` → first place to check errors
- `/proc` → live system data, not stored on disk

---

## 🚀 DevOps Insight

Mastering this filesystem tree helps you:
- debug production issues faster
- locate logs instantly
- manage permissions correctly
- clear Linux interviews confidently

---

📌 **Tip:** This tree alone covers ~70% of Linux filesystem interview questions.

Linux File System – Quick Map 

Root Level

/
Root of the filesystem. Every file and directory starts here.



---

Essential System Directories

/bin
Essential user commands like ls, cp, mv, cat.
Needed even if system is in rescue mode.

/sbin
System administration commands like reboot, fsck, ip.
Mostly used by root or sudo users.

/lib
Shared libraries required by /bin and /sbin commands.
Without this, basic commands will not run.



---

Configuration & User Data

/etc
Configuration files for system, services, and applications.
Example: passwd, sshd_config, fstab.

/home
Home directories for normal users.
Example: /home/ubuntu, /home/ram.

/root
Home directory of root user.
Separate from /home for security reasons.



---

Logs & Variable Data

/var
Variable data that changes frequently.
Includes logs, cache, mail, spool files.

/var/log
System and application logs.
Example: auth.log, syslog, nginx logs.



---

Programs & Software

/usr
User programs, binaries, libraries, documentation.
Contains /usr/bin, /usr/lib, /usr/sbin.

/opt
Optional or third-party software installations.
Example: custom apps, vendor software.



---

Temporary & Runtime

/tmp
Temporary files.
Often auto-cleaned on reboot.

/run
Runtime data like PID files and sockets.
Exists only while system is running.



---

Virtual & Hardware Interfaces

/proc
Virtual filesystem showing process and system information.
Data comes from memory, not disk.

/sys
Kernel and hardware information.
Used for device and kernel tuning.

/dev
Device files like disks, USB, memory.
Example: /dev/sda, /dev/null.



---

Mount & Boot

/mnt
Temporary mount point for filesystems.

/media
Auto-mounted removable devices like USB, CD.

/boot
Bootloader and kernel files.
Required for system startup

---