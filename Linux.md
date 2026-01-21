


___
Linux File System – Tree Structure

/
├── bin
│   └── Essential user commands (ls, cp, mv, cat)
│
├── sbin
│   └── System/admin commands (reboot, fsck, ip)
│
├── etc
│   └── Configuration files
│       ├── passwd
│       ├── shadow
│       ├── group
│       └── ssh/
│
├── home
│   ├── ubuntu
│   ├── ram
│   └── other users' home folders
│
├── root
│   └── Home directory of root user
│
├── var
│   ├── log
│   │   ├── syslog
│   │   ├── auth.log
│   │   └── app logs
│   ├── cache
│   └── spool
│
├── usr
│   ├── bin
│   │   └── User applications (git, python, docker)
│   ├── sbin
│   │   └── Admin tools
│   └── lib
│       └── Libraries for /usr programs
│
├── lib
│   └── Core libraries for /bin and /sbin
│
├── tmp
│   └── Temporary files (auto-cleaned)
│
├── opt
│   └── Optional / third-party software
│
├── run
│   └── Runtime process data (PID, sockets)
│
├── proc
│   └── Virtual process & system info
│
├── sys
│   └── Kernel & hardware info
│
├── dev
│   └── Device files (disk, USB, memory)
│
├── mnt
│   └── Temporary mounts
│
├── media
│   └── Auto-mounted devices (USB, CD)
│
└── boot
    └── Bootloader & kernel files



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