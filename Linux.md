

📘 DevOps Linux Notes

1. What is Linux?

Definition:
Linux is a free and open-source operating system based on Unix. It is widely used in servers, DevOps, cloud systems, and automation.

Key Features:

Open Source

Command-line based

Secure and stable

Used in cloud & containers



2. Why Linux in DevOps?

Definition:
Linux is essential in DevOps because most tools (like Docker, Kubernetes, Jenkins) run on Linux servers. It supports automation, scripting, and remote management.

Use Case:

Run CI/CD pipelines

Automate deployment

Manage server infrastructure


___

login_name@hostname:~$


login_name Current user
@          Separator
hostname   Machine name
:          Separator
~          Home directory of user
$          Prompt symbol for normal user (# for root)


---

Linux Commands and Directory Paths 

Basic Directories:

1. /media
Definition: Mount point for removable devices.
Use: Auto-mount for CD/DVDs, USB drives, SD cards.


2. /run
Definition: Stores runtime information.
Use: Holds data for currently running processes; deleted after reboot.


3. /lib
Definition: Shared library files required by system.
Use: Supports essential binary execution.


4. /lib64
Definition: 64-bit system libraries.
Use: Contains 64-bit shared object files.


5. /bin
Definition: Essential binaries.
Use: Contains commands used by all users, e.g., ls, cp.


6. /sbin
Definition: System binaries.
Use: Only root user can run commands from here, e.g., shutdown.


7. /usr
Definition: User programs, docs, libraries.
Use: Stores user commands, docs, and app data.


8. /opt
Definition: Optional software.
Use: For third-party and vendor software packages.


9. /tmp
Definition: Temporary files directory.
Use: Files are auto-deleted after 12 days or reboot.


10. /srv
Definition: Service data directory.
Use: Contains service-specific data (e.g., web, FTP).


11. /sys
Definition: Virtual filesystem for kernel data.
Use: Displays device and system kernel info.


12. /mnt
Definition: Temporary mount point for storage.
Use: Used for mounting USBs, hard disks manually.


13. /proc
Definition: Virtual process info directory.
Use: Displays running processes and kernel info (e.g., /proc/cpuinfo)


---

✅ Linux Move, Rename & Remove Commands – Easy Points

🔄 Basic Move / Rename Operations

1. Move a file from one location to another
Command: mv [options] source target_location
Example: mv file1.txt /tmp/
Meaning: Moves file1.txt from current location to /tmp/.


2. Rename a file
Command: mv old_name new_name
Example: mv report.txt final_report.txt
Meaning: Renames the file report.txt to final_report.txt.


3. Move and Rename together
Command: mv old_file /new/location/new_file
Example: mv data.txt /home/user/data_backup.txt
Meaning: Moves data.txt and renames it in the new folder.


4. Move a directory to another location
Command: mv folder1/ /backup/
Meaning: Moves folder folder1 into /backup/ directory.




---

🗑️ Basic Remove (Delete) Operations

1. Delete a file
Command: rm filename
Example: rm test.txt
Meaning: Permanently deletes test.txt.


2. Delete multiple files
Command: rm file1 file2 file3
Example: rm a.txt b.txt c.txt
Meaning: Deletes all listed files.


3. Force delete a file (no warning)
Command: rm -f filename
Example: rm -f unsafe.log
Meaning: Deletes the file even if it’s write-protected (no prompt).


4. Delete an empty directory
Command: rmdir dirname
Example: rmdir emptyfolder
Meaning: Deletes an empty folder.


5. Delete a folder and all its content (recursive)
Command: rm -r foldername
Example: rm -rf project/
Meaning: Deletes the folder project/ and everything inside it forcefully.




---


---

✅ Linux File Operations: Move, Rename, Delete, and Editors


Linux Commands – Directory Management

1. Create directory in current path:
~# mkdir dirname


2. Create multiple directories with different names:
~# mkdir dir1 dir2 dir3


3. Create directories in different locations:
~# mkdir /mnt/dir1 /home/user/dir2 /tmp/dir3




---

Linux Commands – File Management

4. Create file in current directory:
~# touch file1.txt


5. Create file in specified location:
~# touch /home/user/file2.txt


6. Create files in multiple directories:
~# touch /mnt/file1.txt /tmp/file2.txt /home/file3.txt


7. Create multiple files with same directory:
~# touch {a.txt,b.mp3,c.txt}


8. Create multiple files in multiple directories:
~# touch /mnt/{a1.txt,a2.txt}
~# touch /tmp/{1.txt,2.txt}




---

📌 Definitions

mv: Move or rename files/directories.

rm: Remove files.

rmdir: Remove empty directories.

-f: Force delete.

-r: Recursive delete (for folders).

---

🔁 1. Move & Rename Operation – mv

➤ Syntax:

mv [source] [destination]

📌 Use Cases:

Purpose	Command Example	Meaning

Move file to another location	mv /home/user/file.txt /tmp/	Moves file.txt to /tmp directory
Rename a file	mv file1.txt file2.txt	Renames file1.txt to file2.txt
Move multiple files	mv *.txt /home/user/docs/	Moves all .txt files to the target folder
Move & rename	mv oldname.txt /home/user/newname.txt	Moves and renames the file in one step



---

🗑️ 2. Delete Operation – rm

➤ Syntax:

rm [options] file_or_directory

➤ Common Options:

-r: Recursive (used for directories)

-v: Verbose (shows progress)

-f: Force deletion (no confirmation)


📌 Use Cases:

Purpose	Command Example	Meaning

Delete a file	rm audio.mp3	Deletes a single file
Delete a folder & contents	rm -rvf myfolder/	Recursively deletes myfolder and its content without prompt
Verbose delete (show steps)	rm -v file1.txt	Shows what file is being deleted



---

📁 3. Change Directory – cd

➤ Use Cases:

Command	Meaning

cd /home/user/docs	Go to specified directory
cd ..	Go back one step (parent directory)
cd ../../	Go back two levels
cd	Go to home directory
cd -	Switch to previous directory




---

✅ LINUX PATHS, FILE VIEWING, EDITORS, & VIM – FULL PRACTICAL NOTES

1. Linux Path Basics

Type	Description	Example

Absolute	Starts with /, full from root	/home/ss/
Full Path	Complete path from / to file/dir	ls /home/ss/
Relative	Based on current location, no /	ls ../, ./file
Shortcuts	~ (home), . (current), .. (parent)	cd ~, cd ..



---

2. File Reading Commands in Linux

Command	Use	Example

cat filename	Show entire file in one go	cat notes.txt
less filename	Page-by-page viewing; scroll with arrows, q to quit	less big.txt
more filename	Like less, but limited	more doc.txt
head filename	First 10 lines (default)	head log.txt
head -n 20	First 20 lines	head -n 20 data.txt
tail filename	Last 10 lines	tail log.txt
tail -f	Real-time updates (logs)	tail -f /var/log/syslog



---

3. Move, Rename, Copy, Delete Files & Folders

Command	Syntax	Purpose

mv	mv old.txt new.txt	Rename a file
	mv file.txt /path/dir/	Move file to another folder
cp	cp file.txt backup.txt	Copy file
cp -r	cp -r dir1 dir2	Copy directory recursively
rm	rm file.txt	Delete file
rm -r	rm -r folder/	Remove directory and contents
rm -rf	rm -rf folder/	Force delete everything (⚠️ Caution!)



---

4. Graphical Editors (Linux Desktop)

Editor	Description	Example

gedit	GUI Notepad-style editor	gedit file.txt
kedit	KDE version of gedit	kedit hello.cpp



---

5. Command-Line Editors

nano

Easy to use; shows shortcuts below.

Open: nano file.txt


pico

Similar to nano.

Open: pico file.txt


vi / vim (Modal Editor – Very Powerful)

Open: vi filename.txt or vim filename.txt


Modes in vim:

Mode
Enter with
Description
Command
Default
Navigate, delete, search
Insert
i, I, a, A, o, O
Type text, Esc to exit
Ex/Execute
: (colon)
Save/Quit/Commands: :w, :q, :wq, :q!
Visual
v, V, Ctrl+v
Select chars, lines, blocks

---

6. Common vim Commands

Navigation

gg : Start of file

G  : End of file

/word : Search for "word"


Insert Mode

i : Insert at cursor

I : Insert at beginning of line

a : Append after cursor

A : Append at end of line

o : New line below

O : New line above

Esc : Exit insert mode


Copy-Paste-Delete

yy : Copy line

dd : Delete line

yw : Copy word

p  : Paste below

P  : Paste above


Visual Mode

v : Visual (char-by-char)

V : Visual (line-by-line)

Ctrl+v : Visual block (column/rectangular)

After selection:

y : Copy

d : Delete

c : Change



Ex/Command Mode (after :)

:w  : Save

:q  : Quit

:q! : Force quit without saving

:wq / :x : Save and quit

:set nu : Show line numbers


Search & Replace

:s/old/new/g    : Replace in current line

:%s/old/new/g   : Replace in entire file



---

7. Bonus – Viewing, Line Count & Navigation

Task	Command

Show first N lines	head -n 20 file.txt
Show last N lines	tail -n 20 file.txt
Show with line numbers	nl file.txt or cat -n
Show current directory	pwd


___



---


1️⃣ What is Linux?
🗣️ Sample answer:
“Linux is an open-source operating system based on UNIX. It manages hardware, runs applications, and provides a stable and secure environment for servers and developers.”


---

2️⃣ What are the main components of Linux?
🗣️ Sample answer:
“Linux has four main components: the Kernel, Shell, System Libraries, and System Utilities. The kernel interacts with hardware, and the shell provides a command-line interface for user interaction.”


---

3️⃣ How do you check the current working directory?
🗣️ Sample answer:
“You can use the command pwd — it prints the present working directory path.”


---

4️⃣ What command is used to list files in Linux?
🗣️ Sample answer:
“The ls command lists files and directories. For more details, use options like ls -l for long listing or ls -a to show hidden files.”


---

5️⃣ How do you view the contents of a file?
🗣️ Sample answer:
“You can use commands like cat, less, or more to view file contents. For example, cat filename.txt displays the entire file.”


---

6️⃣ What is the difference between absolute and relative paths?
🗣️ Sample answer:
“An absolute path starts from the root directory /, while a relative path starts from the current working directory.”


---

7️⃣ How do you check disk usage in Linux?
🗣️ Sample answer:
“Use df -h to display disk space usage in human-readable format, or du -sh <directory> for specific directory usage.”


---

8️⃣ How do you see running processes in Linux?
🗣️ Sample answer:
“You can use ps, top, or htop. For example, ps -ef shows all processes running in detail.”


---

9️⃣ What command is used to change file permissions?
🗣️ Sample answer:
“The chmod command changes file permissions. For example, chmod 755 file.sh gives the owner full permission and read/execute for others.”


---

🔟 What is the difference between su and sudo?
🗣️ Sample answer:
“su switches users and runs commands as another user, usually root. sudo executes a single command as root with permission control.”


---


---

🧠 Long Answer Questions (1–5 min)

1️⃣ Explain the Linux boot process.
🗣️ Sample answer:
“The Linux boot process starts with BIOS/UEFI, which loads the bootloader like GRUB. The bootloader then loads the Linux kernel into memory. The kernel initializes hardware and mounts the root filesystem. After that, it runs the init or systemd process, which starts all necessary background services and finally brings the system to a usable state with a login prompt.”


---

2️⃣ How do file permissions work in Linux?
🗣️ Sample answer:
“Each file and directory in Linux has permissions for three types of users — owner, group, and others — represented by read (r), write (w), and execute (x). You can check permissions using ls -l. For example, -rwxr-xr-- means the owner can read, write, and execute; the group can read and execute; others can only read. You can modify permissions with chmod and ownership with chown.”


---

3️⃣ Explain process management in Linux.
🗣️ Sample answer:
“In Linux, each running program is a process identified by a PID (Process ID). The ps, top, and htop commands help monitor them. You can terminate a process using kill <PID> or killall <process name>. Daemons are background processes that start at boot. Process states include running, sleeping, stopped, and zombie. Understanding this helps in debugging and resource management.”


---

4️⃣ How does Linux handle memory management?
🗣️ Sample answer:
“Linux uses virtual memory management. It divides memory into pages and uses a swap space on disk when RAM is full. The free -h or vmstat commands show memory usage. The kernel uses caching and buffering to optimize performance. Swapping and paging ensure efficient memory utilization even under heavy load.”


---

5️⃣ Explain how to manage users and groups in Linux.
🗣️ Sample answer:
“Linux manages users with /etc/passwd and groups with /etc/group. You can create a user using useradd and set a password using passwd. usermod changes user properties, and groupadd creates groups. Managing users correctly ensures security and proper file access control.”


---



---

1️⃣ What is Linux, and how is it different from other operating systems?

🗣️ Sample Answer:
“Linux is an open-source operating system that works as a bridge between hardware and software. It’s based on UNIX and manages hardware resources like CPU, memory, and storage, while allowing users to run applications efficiently.
The main difference between Linux and other OS like Windows or macOS is that Linux is open-source, meaning its source code is freely available for everyone to use, modify, and distribute. It’s also more secure, stable, and widely used in servers, cloud systems, and DevOps environments. Unlike Windows, Linux gives full control to users through the command line, which is very powerful for automation.”


---

2️⃣ Explain the architecture of Linux.

🗣️ Sample Answer:
“Linux has a modular architecture divided into several layers:

1. Kernel: The core part that communicates directly with hardware. It manages CPU, memory, and devices.


2. System Libraries: These are special programs that help applications interact with the kernel.


3. System Utilities: These are commands and tools for user operations like managing files, users, and processes.


4. Shell: It’s a command interpreter where users type commands. Examples are Bash or Zsh.


5. Application Layer: These are programs that run on top of Linux like web servers, editors, or databases.



This layered structure makes Linux stable, secure, and modular — you can modify or replace parts without affecting the entire system.”


---

3️⃣ What is the Linux Kernel, and why is it important?

🗣️ Sample Answer:
“The Linux Kernel is the heart of the operating system. It acts as a bridge between hardware and applications. Whenever you run a program, the kernel allocates memory, schedules tasks, and manages system calls.
There are different types of kernels, and Linux uses a monolithic kernel, meaning all core functionalities like device drivers and process management run inside the kernel space.
The kernel is important because it ensures efficient resource utilization, hardware abstraction, and system stability. Every time you boot Linux, the kernel is one of the first components loaded.”


---

4️⃣ What are the main features of Linux that make it popular?

🗣️ Sample Answer:
“Linux is popular for several key features:

1. Open-source: Anyone can modify or improve it.


2. Multitasking: It can run many processes at once efficiently.


3. Multi-user: Multiple users can use the same system securely.


4. Security: Built-in permissions and user management keep systems secure.


5. Portability: Runs on almost any hardware — from Raspberry Pi to mainframes.


6. Stability: Servers can run for months or years without rebooting.


7. Networking: Linux has powerful built-in networking and firewall tools.


8. Command-line interface: Makes automation and DevOps integration easy.



That’s why Linux is the foundation for servers, cloud platforms, and DevOps tools.”


---

5️⃣ What is the difference between Linux and UNIX?

🗣️ Sample Answer:
“UNIX is the original proprietary operating system developed in the 1970s, while Linux is an open-source clone inspired by UNIX, created by Linus Torvalds in 1991.
The key differences are:

UNIX is commercial; Linux is free and open-source.

UNIX systems are mostly used in enterprise mainframes; Linux is everywhere — servers, desktops, and embedded systems.

Linux has many distributions like Ubuntu, CentOS, Red Hat, and Debian.

UNIX systems are certified by The Open Group, while Linux is community-driven.
In short, Linux offers the power of UNIX with freedom and flexibility.”



---

6️⃣ What are Linux distributions, and which ones are most common?

🗣️ Sample Answer:
“A Linux distribution, or distro, is a version of Linux that includes the kernel plus supporting software, libraries, and package management tools.
Popular distributions include:

Ubuntu: Beginner-friendly and widely used for development.

CentOS / Rocky Linux: Preferred for servers and enterprise systems.

Red Hat Enterprise Linux (RHEL): Commercial version used in large companies.

Debian: Stable and secure, often used for servers.

Fedora: Cutting-edge, used for testing new technologies.

Kali Linux: Used for security and penetration testing.


Different distros share the same kernel but offer different user experiences and software management.”


---

7️⃣ What is a Linux Shell, and what are its types?

🗣️ Sample Answer:
“The shell is a program that takes commands from the user and gives them to the operating system to execute. It acts as an interface between the user and the kernel.
There are several types of shells:

Bash (Bourne Again Shell): The most common and default on many systems.

Zsh: Advanced features like auto-correction and customization.

Ksh (Korn Shell) and Csh (C Shell): Used in different UNIX systems.


The shell can also execute scripts, making it essential for automation in DevOps. Bash is particularly important for writing scripts to automate daily system tasks.”


---

8️⃣ What is the Linux command line, and why is it powerful?

🗣️ Sample Answer:
“The Linux command line is a text-based interface that allows users to interact directly with the system using typed commands instead of a GUI.
It’s powerful because it gives full control over the system, supports automation through scripting, and can execute complex operations with a few commands.
For example, you can create users, copy files, start servers, and even deploy applications without leaving the terminal.
In DevOps, the command line is essential because most tools (Docker, Git, Kubernetes) are designed to integrate seamlessly with it.”


---

9️⃣ What does open-source mean in the context of Linux?

🗣️ Sample Answer:
“Open-source means that the source code of Linux is publicly available for anyone to view, modify, and distribute. This encourages innovation, security, and community support.
Because it’s open-source, developers around the world continuously improve Linux, fix bugs, and add features.
For companies, it means lower cost and flexibility. For individuals, it means learning opportunities and control over how their system behaves.
This openness is one of the biggest reasons Linux dominates cloud computing and DevOps.”


---

🔟 Why is Linux preferred in DevOps and Cloud Environments?

🗣️ Sample Answer:
“Linux is the backbone of most DevOps and cloud infrastructures because it’s lightweight, stable, and customizable.
It supports tools like Docker, Jenkins, Kubernetes, and Terraform natively. Most cloud providers (AWS, Azure, GCP) run Linux-based virtual machines.
Linux also provides powerful command-line tools and scripting capabilities for automation, which is a key part of DevOps.
Additionally, its open-source nature allows teams to tailor it to their exact needs without licensing costs.”


---