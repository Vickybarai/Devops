

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

Mode	Enter with	Description

Command	Default	Navigate, delete, search
Insert	i, I, a, A, o, O	Type text, Esc to exit
Ex/Execute	: (colon)	Save/Quit/Commands: :w, :q, :wq, :q!
Visual	v, V, Ctrl+v	Select chars, lines, blocks



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



---

✅ 8. Summary Table (Ready for Viva or Interviews)

Operation	Command	Use Case

View file	cat filename	Show entire file
Scroll file	less filename	Paginate + scroll
View start/end	head, tail, -n	Show top/bottom N lines
Copy file	cp file newfile	Backup or duplicate
Move/Rename	mv old new	Shift file or rename
Delete file	rm file.txt	Remove file
Delete folder	rm -r folder/	Remove directory
Edit (easy)	nano file.txt	Use friendly editor
Edit (advanced)	vim file.txt	Use powerful modal editor
Save/Quit (vim)	:w, :q, :wq, :q!	Save/exit vim editor
Replace Text	:%s/old/new/g	Search and replace in vim



