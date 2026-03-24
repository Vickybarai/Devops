# Jenkins Pipelines with Maven: Building Java Applications

This lecture covers the integration of **Maven** (a Build Tool) into **Jenkins Pipelines**. We move from understanding the build process to automating it using Jenkins.

---

## 1. The Manual Build Process vs. Automation
Before using a tool, let's look at what happens in the **Build Phase** manually:
1.  **Validate:** Check syntax and code structure.
2.  **Compile:** Convert code to byte code.
3.  **Test:** Run unit tests.
4.  **Package:** Create a distributable file (e.g., `.jar` or `.war`).

**The Problem:**
A developer has to run 5-6 separate commands (like `javac`, `java`, `tar`) every time they make a small change. This consumes a lot of time.

**The Solution: Build Tools**
We use tools to automate this entire sequence with a single command.
*   **Java:** Maven, Gradle, Ant.
*   **Python:** PIP.
*   **.NET:** MSBuild.

**Maven** is the most commonly used tool for Java applications. It automates the compilation, testing, and packaging processes.

---

## 2. Maven Concepts: Goals, Phases, and Lifecycle
To understand Maven, you must understand three key terms:

### 1. Goal
A **Goal** is a specific task. Think of it like a function in programming.
*   *Example:* `jar:jar` (create a jar file), `compile` (compile code).
*   Technical term: It is a "plugin" goal.

### 2. Phase
A **Phase** is a stage in the build process. A phase is a collection of goals.
*   *Example:* `clean`, `package`, `install`.

### 3. Lifecycle
A **Lifecycle** is a sequence of phases. Maven has three built-in lifecycles:

1.  **Default Lifecycle (Main Build):** Contains 8 phases.
    *   Phases: `validate` -> `compile` -> `test` -> `package` -> `integration-test` -> `verify` -> `install` -> `deploy`.
    *   **Important Rule:** If you run a later phase (e.g., `package`), Maven automatically runs *all* previous phases (`validate`, `compile`, `test`) first.
2.  **Clean Lifecycle:**
    *   Phase: `clean`.
    *   **Function:** Deletes the build directory (target folder) and artifacts created by previous builds. It gives you a fresh start.
3.  **Site Lifecycle:**
    *   Phase: `site`.
    *   **Function:** Generates project documentation.

**Common Command:**
`mvn clean package`
*   This runs the `clean` lifecycle (deletes old files) and then runs the `package` phase (compiles, tests, and creates the JAR).

---

## 3. Maven Project Structure & `pom.xml`
Maven enforces a standard directory structure (Standard Hierarchy) so it knows where to find your files automatically.

**Standard Structure:**
```text
MyProject/
├── pom.xml                 <-- Configuration File
├── src/
│   ├── main/
│   │   ├── java/           <-- Your Java Source Code
│   │   └── resources/      <-- Config files (application.properties)
│   └── test/
│       └── java/           <-- Your Test Code
└── target/                 <-- Generated Build Output (Created automatically)
```

### The `pom.xml` File
This is the heart of a Maven project. It contains the configuration.
*   **Dependencies:** Lists external libraries needed (e.g., Spring Boot, MariaDB Driver, JUnit).
*   **Group ID / Artifact ID / Version:** Defines the identity of the application (e.g., `com.example : student-app : 1.0`).
*   **Build Plugins:** Defines specific goals to run during the build.

*How to find dependencies?*
You can search for dependencies on **mvnrepository.com** and copy the XML snippet into your `pom.xml`.

---

## 4. Configuring Maven in Jenkins
Jenkins does not know where Maven is installed by default. We must configure it.

**Steps:**
1.  Go to **Manage Jenkins** -> **Tools**.
2.  Scroll down to **Maven installations**.
3.  Click **Add Maven**.
4.  **Name:** Give it a name (e.g., `M3` or `m1`).
5.  **MAVEN_HOME:** Enter the path where Maven is installed on the server (e.g., `/usr/share/maven`).
6.  **Install Automatically:** You can check this box to let Jenkins download and install Maven automatically if it's not present.
7.  Click **Apply** and **Save**.

Now, Jenkins can use the name `M1` to refer to the Maven installation path in your pipelines.

---

## 5. Using Maven in a Jenkins Pipeline
Now we integrate Maven into our Declarative Pipeline.

### Step 1: Generate the Pipeline Syntax
Instead of writing complex Groovy code manually, Jenkins provides a **Snippet Generator**.
1.  Open your Pipeline configuration.
2.  Click **Pipeline Syntax**.
3.  Select **Sample Step** -> `sh: Shell Script` (for Linux) or `Invoke top-level Maven targets` (Maven-specific plugin).

### Step 2: Writing the Build Stage
We usually use the **Shell Script (`sh`)** step to run Maven commands because it gives us flexibility to change directories or run multiple commands.

**Scenario:**
Your Git repository has a `backend` folder containing the Java code. You need to run Maven inside that folder.

**Pipeline Script:**
```groovy
pipeline {
    agent any

    stages {
        stage('Pull') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo.git'
            }
        }

        stage('Build') {
            steps {
                // 1. Change directory to backend
                // 2. Run Maven clean package
                sh 'cd backend && mvn clean package'
            }
        }
    }
}
```

---
✅ Fix (Critical)
Step 1: Go to:
Manage Jenkins → Configure System → Global Properties

Step 2: Set correct PATH (append, not override)

Use:
Name: PATH
Value: /usr/share/maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

Step 3: Restart Jenkins
sudo systemctl restart jenkins

---
---

**Explanation:**
*   `sh`: This tells Jenkins to execute a shell command on the agent.
*   `cd backend`: Changes the current directory to `backend` (where `pom.xml` resides).
*   `&&`: This operator ensures the second command (`mvn...`) only runs if the first (`cd`) succeeds.
*   `mvn clean package`: Runs the Maven build. It downloads dependencies, compiles code, runs tests, and creates the artifact (JAR file).

### Summary
1.  **Maven** automates the build lifecycle (compile, test, package).
2.  **Lifecycles** (Clean, Default, Site) define the sequence of operations.
3.  **`pom.xml`** manages dependencies and project configuration.
4.  In **Jenkins**, configure Maven in **Global Tool Configuration**.
5.  In the **Pipeline**, use `sh 'cd <folder> && mvn clean package'` to trigger the build.