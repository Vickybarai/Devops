
📘 DevOps Linux Interview Notes (Beginner to Intermediate)

---

🧩 Module 1: Introduction to Linux


---

1️⃣ What is Linux?

Definition:
Linux is a free and open-source operating system based on UNIX. It acts as a bridge between hardware and applications, managing resources like CPU, memory, and storage.

Key Features:

🟢 Open Source – Source code is freely available.

🖥️ Command-line Based – Powerful terminal interface.

🔒 Secure and Stable – Reliable for production systems.

☁️ Widely Used – Essential in cloud, DevOps, and container systems.


Use Case:
Linux powers most servers, cloud environments, and DevOps tools like Docker, Jenkins, and Kubernetes.


---

2️⃣ Why Linux is Important in DevOps

Definition:
Linux is the backbone of DevOps because most automation, orchestration, and CI/CD tools are built to run on Linux servers.

Use Cases:

🧱 Running CI/CD pipelines (Jenkins, GitLab CI)

⚙️ Automating deployments using shell scripts

🌐 Managing remote servers and cloud infrastructure


Example:
“Most cloud servers (AWS EC2, Azure VM, GCP Compute) run on Linux because it is lightweight, secure, and scriptable.”


---

3️⃣ Linux Login Prompt Breakdown

When you see:

login_name@hostname:~$

Explanation:

Symbol	Meaning

login_name	Current user name
@	Separator between user and host
hostname	System or machine name
:	Separator between hostname and directory
~	User’s home directory
$	Command prompt for normal user (root = #)



---

🗂️ Linux Directories and Their Purpose

Directory	Definition	Use

/bin	Essential binaries	Commands for all users (e.g., ls, cp, mv)
/sbin	System binaries	Root-level admin commands (e.g., shutdown, fdisk)
/usr	User programs & docs	Stores installed user applications
/lib	Shared system libraries	Supports binary execution
/lib64	64-bit libraries	Contains shared object files for 64-bit systems
/media	Removable devices	Mount point for USB/CDs
/mnt	Temporary mount point	Manual mounts for storage or partitions
/tmp	Temporary files	Auto-deleted on reboot
/proc	Virtual process directory	Displays running processes & system info
/sys	Kernel data interface	Shows device and system kernel information
/srv	Service data	Holds service-specific data (e.g., web, FTP)
/opt	Optional software	Vendor or third-party packages
/run	Runtime data	Temporary process data cleared on reboot



---

🧰 Common Linux Operations and Commands

Move, Rename, and Remove

Move or Rename a File

mv old.txt new.txt
mv file1.txt /tmp/

✅ Moves or renames files and directories.

Remove (Delete)

rm filename
rm -rf foldername/

✅ Deletes files and folders recursively (-r) and forcefully (-f).

Remove Empty Directory

rmdir emptyfolder


---

📁 Directory & File Management

Task	Command	Description

Create directory	mkdir dirname	Makes a new directory
Create multiple	mkdir dir1 dir2	Creates multiple directories
Create file	touch file1.txt	Creates empty file
Create in multiple paths	touch /mnt/a.txt /tmp/b.txt	Create files in different directories



---

📖 File Viewing Commands

Command	Description	Example

cat	Show file contents	cat file.txt
less	View large files with scroll	less logfile.txt
head	Show first 10 lines	head file.txt
tail	Show last 10 lines	tail file.txt
tail -f	Monitor real-time logs	tail -f /var/log/syslog
nl	Show with line numbers	nl file.txt



---

✍️ Linux Editors Overview

Graphical Editors

Editor	Description	Example

gedit	Simple GUI text editor	gedit file.txt
kedit	KDE-based text editor	kedit test.cpp


Command-Line Editors

Editor	Description

nano	Beginner-friendly, shows shortcuts below
pico	Similar to nano
vi / vim	Powerful modal editor used for scripting and configuration


Vim Modes Overview

Mode	Command	Description

Insert	i, a, o	Enter text mode
Command	:	Save/Quit commands
Visual	v, V, Ctrl+v	Select text for copy/paste


Common Vim Commands

Action	Command

Save	:w
Quit	:q
Save & Quit	:wq
Force Quit	:q!
Copy Line	yy
Paste	p
Delete Line	dd
Search	/word



---

🎯 Key Linux Interview Questions (Module 1)

1️⃣ What is Linux?

🗣️ “Linux is an open-source OS that manages hardware, runs applications, and provides a stable and secure platform for servers, developers, and DevOps operations.”


---

2️⃣ What are the main components of Linux?

🗣️ “Linux has four core parts — Kernel, Shell, System Libraries, and System Utilities. The kernel interacts with hardware, while the shell allows users to execute commands.”


---

3️⃣ What is the Linux Kernel and why is it important?

🗣️ “The Kernel is the core part of Linux responsible for managing hardware, memory, and processes. It ensures stability and acts as a bridge between software and hardware.”


---

4️⃣ What are Linux Distributions?

🗣️ “A Linux distribution combines the kernel with software and package managers. Examples: Ubuntu, CentOS, Debian, Fedora, and Kali Linux.”


---

5️⃣ What is a Linux Shell and what are its types?

🗣️ “The Shell is the command interpreter. Common shells are Bash, Zsh, Ksh, and Csh. Bash is most widely used for scripting and automation.”


---

6️⃣ What does ‘Open Source’ mean in Linux?

🗣️ “It means Linux’s source code is publicly available for anyone to use, modify, or distribute, promoting collaboration and innovation.”


---

7️⃣ Why is Linux popular in DevOps and Cloud?

🗣️ “Linux is stable, lightweight, and supports most DevOps tools like Docker, Jenkins, and Kubernetes. It’s the foundation for automation and scalable cloud infrastructure.”


---

✅ Summary: Module 1 builds the foundation for your DevOps Linux journey.
Once you master these, you can confidently move to Module 2 – Linux File System & Navigation, which covers real commands and hands-on examples.


---

Would you like me to format Module 2 (Linux File System & Navigation) next in the same clean, interview-ready layout (with commands, tables, and sample Q&A)?

🧩 Module 2 – Linux File System, Navigation & Basic Commands

This module is highly important for DevOps beginners, as 80% of Linux interview questions come from these topics.


---

📘 1️⃣ What is the Linux File System?

Definition:
The Linux file system organizes data and files into a hierarchical structure — starting from the root directory (/).
Everything in Linux — including files, directories, devices, and processes — is treated as a file.

Example Structure:

/
├── bin
├── etc
├── home
│   ├── user1
│   └── user2
├── var
├── tmp
└── usr

🗣️ Interview Answer (30 sec):
“Linux uses a hierarchical file system starting from the root (/). Everything — devices, users, processes — is stored as files in directories under root.”


---

📁 2️⃣ Explain Absolute and Relative Paths

Type	Description	Example

Absolute Path	Starts from / (root directory)	/home/devops/file.txt
Relative Path	Starts from current location	../file.txt, ./script.sh


🗣️ Answer (Short):
“An absolute path always starts from the root, while a relative path starts from the current directory.”


---

📂 3️⃣ Directory Navigation Commands

Command	Description	Example

pwd	Print current working directory	pwd → /home/user
cd	Change directory	cd /etc
cd ..	Go to parent directory	Moves one level up
cd ~	Go to home directory	Shortcut for /home/username
cd -	Go to previous directory	Useful for switching between dirs


🗣️ Short Answer:
“To move between directories, use cd. cd .. moves up one level, and pwd shows where you are.”


---

📜 4️⃣ File and Directory Listing

Command	Description	Example

ls	List files and directories	ls
ls -l	Long listing (permissions, size, date)	ls -l /home
ls -a	Show hidden files	ls -a
ls -lh	Human-readable sizes	ls -lh
ls -lt	Sort by modified time	ls -lt


🗣️ Short Answer:
“Use ls to list files, ls -l for details, and ls -a to see hidden files.”


---

📄 5️⃣ File Creation and Viewing

Command	Description	Example

touch	Create empty file	touch file.txt
cat	View file contents	cat notes.txt
less	Scroll view for long files	less logfile.txt
head	Show first 10 lines	head file.txt
tail	Show last 10 lines	tail file.txt
tail -f	Live update for logs	tail -f /var/log/syslog


🗣️ Long Answer (1 min):
“To create a new file, we use touch. For viewing, cat shows the whole file, less allows page-by-page scrolling, and tail -f is perfect for monitoring logs in real time.”


---

🧰 6️⃣ File Operations (Move, Copy, Delete)

Operation	Command	Example	Explanation

Move	mv old.txt new.txt	mv file1 /tmp/	Move or rename a file
Copy	cp file.txt backup.txt	cp -r dir1 dir2	Copy file or directory
Delete	rm file.txt	rm -rf folder/	Delete file/folder permanently
Remove Empty Directory	rmdir dirname	rmdir olddir	Removes only empty folders


🗣️ Caution Tip:
“Be careful with rm -rf, it deletes files permanently without asking for confirmation.”


---

⚙️ 7️⃣ View File Properties & Permissions

Command	Description	Example

ls -l	Show permissions	ls -l file.txt
stat	Show detailed info	stat file.txt


Example Output:

-rwxr-xr--  1 devops devgroup 1234 Jan 22 15:30 deploy.sh

Explanation:

Symbol	Meaning

r	Read permission
w	Write permission
x	Execute permission
-rwxr-xr--	Owner has full (rwx), group has read/execute, others read-only


🗣️ Interview Answer (2 min):
“In Linux, every file has permissions for the owner, group, and others. They define who can read, write, or execute the file. We can view them using ls -l and modify using chmod.”


---

🔐 8️⃣ Changing File Permissions & Ownership

Task	Command	Example

Change permissions	chmod 755 file.sh	Owner: full, Group/Others: read & execute
Change ownership	chown user:group file.txt	chown devops:admin report.txt
Numeric permissions	r=4, w=2, x=1 → rwx=7	chmod 644 file.txt → rw-r--r--


🗣️ Short Answer (45 sec):
“Use chmod to set permissions. 755 means full access for owner and read/execute for others. Ownership can be changed using chown.”


---

🧮 9️⃣ Disk Usage and Space Monitoring

Command	Description	Example

df -h	Show disk usage in human-readable form	df -h
du -sh /var/log	Show directory size	du -sh /var/log
lsblk	List storage devices	lsblk
mount / umount	Mount or unmount disks	mount /dev/sdb1 /mnt


🗣️ Long Answer (2 min):
“df -h shows overall disk usage and available space, while du -sh is used to check how much space a specific directory uses. For example, du -sh /var/log tells you log folder size.”


---

💡 10️⃣ Search and Locate Files

Command	Description	Example

find	Search by name, size, or type	find / -name file.txt
locate	Fast file search (uses database)	locate nginx.conf
grep	Search text within files	grep 'error' /var/log/syslog


🗣️ Short Answer (45 sec):
“Use find to locate files by name or path, and grep to search for text within files. Example: grep "error" logfile.txt shows all error lines.”


---

🧩 Module 3 – Linux User Management, Permissions & Process Handling

This module is critical for every DevOps beginner. Almost every Linux-based DevOps, Cloud, or System Admin interview includes questions on user management, permissions, and process control.


---

👤 1️⃣ What are Users and Groups in Linux?

Definition:
In Linux, every individual who uses the system is a user, and users can be grouped into groups to manage permissions collectively.

🗣️ Short Answer (45 sec):
“Users represent individual accounts, and groups are collections of users that share the same permissions. It helps manage access control efficiently.”


---

👥 2️⃣ Types of Users

Type	Description	Example

Root User	Has full system access (administrator)	Username: root
Normal User	Limited privileges	Created via useradd
System User	Created automatically for services	nginx, mysql, etc.


🗣️ Interview Answer (30 sec):
“There are three types of users in Linux — root, normal, and system users. Root has full control, normal users have restricted access, and system users are for running services securely.”


---

👨‍💻 3️⃣ User Management Commands

Task	Command	Example

Create new user	useradd username	useradd devops
Create user with home directory	useradd -m username	useradd -m tester
Set password	passwd username	passwd devops
Change username	usermod -l newname oldname	
Delete user	userdel username	userdel tester
Delete user and home dir	userdel -r username	userdel -r devops


🗣️ Long Answer (1 min):
“To create a user, we use useradd. Adding the -m flag ensures a home directory is created. Passwords are set using passwd. For cleanup, userdel -r removes the user and their home directory.”


---

👥 4️⃣ Group Management Commands

Task	Command	Example

Create a group	groupadd groupname	groupadd devteam
Add user to group	usermod -aG groupname username	usermod -aG devteam alice
Delete group	groupdel groupname	groupdel devteam
Show group info	groups username	groups alice


🗣️ Interview Answer (45 sec):
“Groups make it easy to manage permissions for multiple users. For example, if you add users to the ‘devops’ group, all of them get the same access level to project files.”


---

🔐 5️⃣ File Ownership and Permissions

Type	Description	Command

Ownership	Each file has a user and group owner	ls -l
Change owner	chown user:group filename	chown alice:devops script.sh
Change permissions	chmod [mode] filename	chmod 755 deploy.sh


Example Output:

-rwxr-xr-- 1 alice devops 1200 Jan 22 10:00 deploy.sh

🗣️ Explanation (2 min):
“The owner has full (rwx) access, the group has read and execute (r-x), and others can only read (r--). We modify these using chmod and ownership using chown.”


---

🧮 6️⃣ Understanding Permission Numbers

Symbolic	Numeric	Meaning

rwx	7	Read, write, execute
rw-	6	Read, write
r-x	5	Read, execute
r--	4	Read only
---	0	No access


Example:
chmod 755 file.sh → Owner: full, Group: read+execute, Others: read+execute

🗣️ Short Answer:
“Permissions are represented numerically: 7 means full access, 6 for read-write, 5 for read-execute, and 4 for read-only.”


---

🧠 7️⃣ Special Permissions: SUID, SGID, Sticky Bit

Permission	Symbol	Function	Example

SUID	s on user	Run file with owner’s privileges	/usr/bin/passwd
SGID	s on group	Run with group privileges	Shared project dirs
Sticky Bit	t on others	Only owner can delete file	/tmp directory


🗣️ Long Answer (2–3 min):
“These special permissions enhance security. SUID allows users to execute files as the owner (like passwd). SGID ensures new files inherit group permissions. Sticky Bit prevents other users from deleting your files in shared directories.”


---

⚙️ 8️⃣ Process Management in Linux

Definition:
A process is a running instance of a program.

Important Commands:

Command	Description	Example

ps -ef	Show all running processes	`ps -ef
top	Real-time system monitor	top
htop	Interactive process viewer	htop
kill <PID>	Kill process by ID	kill 1234
killall <name>	Kill process by name	killall python
nice, renice	Set process priority	nice -n 10 processname


🗣️ Interview Answer (2 min):
“ps -ef lists all processes, top and htop show real-time usage, and kill stops processes. Priority can be managed with nice and renice — lower values mean higher priority.”


---

🧰 9️⃣ System Resource Monitoring

Command	Description	Example

uptime	System running time	uptime
free -h	Memory usage	free -h
vmstat	Process and memory statistics	vmstat 1
iostat	Disk usage	iostat
sar	Performance over time	sar -u 5 5


🗣️ Long Answer (2–3 min):
“In DevOps, system monitoring is key. Commands like free -h show memory, vmstat shows CPU and process stats, and iostat checks disk performance. This helps identify performance bottlenecks.”


---

🚀 10️⃣ Foreground and Background Processes

Action	Command	Description

Run in background	command &	ping google.com &
List background jobs	jobs	Shows running jobs
Bring job to foreground	fg %1	Resume job #1
Send job to background	bg %1	Resume job #1 in background


🗣️ Interview Answer (1 min):
“To multitask, Linux lets you run commands in the background using &. You can list jobs with jobs, bring them forward using fg, or send them back with bg.”


