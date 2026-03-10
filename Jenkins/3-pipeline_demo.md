# Jenkins Pipelines: The Modern Way to CI/CD

## 1. What is a Pipeline?
Imagine a real-world water pipeline system. You have several individual pipes connected by joints. Water flows through these pipes continuously from a source to a destination.

In Jenkins, a **Pipeline** works similarly:
*   **The Pipes:** Individual tasks or jobs (e.g., Pull Code, Build, Test, Deploy).
*   **The Flow:** The output of one task automatically triggers the next task.
*   **The Goal:** To move code changes from a developer's laptop to production automatically.

### The "Old Way" (Manual Chaining)
Before pipelines, if you wanted to run jobs in sequence (e.g., Build -> Test -> Deploy), you had to manually configure **Triggers** or **Post-Build Actions**.
*   You would tell Job A: "After you finish, trigger Job B."
*   You would tell Job B: "After you finish, trigger Job C."
*   **Problem:** This is tedious, manual, and hard to manage if the process gets complex.

### The "New Way" (Pipeline)
A Jenkins Pipeline allows you to define the entire flow (Pull -> Build -> Test -> Deploy) in a single script file. This script automates the execution of all stages in order.

---

## 2. The Pipeline Plugin
A "Jenkins Pipeline" isn't just one tool; it is a **Suite of Plugins**.
*   Think of it like **Microsoft Office**. When you install "Microsoft Office," you get Word, Excel, and PowerPoint together.
*   Similarly, when you install the **Pipeline Plugin** in Jenkins, it installs all the necessary dependencies required to run CI/CD workflows.

### The Language: Groovy DSL
To write a pipeline, we use a scripting language.
*   The language used is **Groovy**.
*   However, we don't write raw Groovy code. We use **DSL (Domain Specific Language)**.
*   **What is DSL?** It is a customized version of a language designed for a specific purpose.
    *   *Example:* Terraform uses HCL (which is basically JSON formatted differently).
    *   *In Jenkins:* The Groovy code is formatted specifically for defining Jenkins jobs. This format is called **Jenkins DSL**.

---

## 3. Types of Pipeline Syntax
There are two ways to write a Jenkins pipeline. You must know the difference for interviews.

### 1. Scripted Pipeline
*   **Start Keyword:** `node`
*   **Era:** Older style.
*   **Complexity:** Complex and harder to read.
*   **Usage:** Rarely used in new projects unless maintaining legacy code.

### 2. Declarative Pipeline (Recommended)
*   **Start Keyword:** `pipeline`
*   **Era:** Newer, standard style.
*   **Complexity:** Easier to read, write, and understand.
*   **Visuals:** Provides a great visual "Stage View" in the Jenkins UI showing boxes for each stage.

**Summary:** Always prefer **Declarative Pipeline** for new projects.

---

## 4. Structure of a Declarative Pipeline
A Declarative Pipeline script follows a specific hierarchy. You must memorize this structure:

```groovy
pipeline {        // 1. The root keyword (Start here)
    agent any     // 2. Where should this run? (Any available agent)
    
    stages {      // 3. Container for all your phases
        stage('Pull') {      // 4. Individual Phase 1
            steps {          // 5. Commands to run in Phase 1
                // code here
            }
        }
        stage('Build') {     // Individual Phase 2
            steps {
                // code here
            }
        }
        // ... add more stages like Test, Deploy
    }
}
```

**Key Terms:**
*   **`pipeline`**: The block that contains everything.
*   **`agent any`**: Tells Jenkins to run this job on any available Agent/Node server. (If you put `agent none`, it won't run anywhere).
*   **`stages`**: A list that holds all the phases of your job.
*   **`stage('Name')`**: A specific section of the job (e.g., Build, Test). This appears as a visual box in the Jenkins UI.
*   **`steps`**: The actual commands (Shell commands, Git commands) that execute inside a stage.

---

## 5. How to Write Pipeline Code: The "Snippet Generator"
You do not need to memorize complex Groovy syntax. Jenkins provides a tool called the **Pipeline Syntax Generator** (Snippet Generator).

**How to use it:**
1.  Open your Pipeline job configuration in Jenkins.
2.  Scroll down to the **Pipeline** section.
3.  Click on **Pipeline Syntax**.
4.  **Sample Step:** Select the tool you want to use (e.g., `git: Git`).
5.  **Configure:** Enter details like Repository URL and Branch.
6.  **Generate Groovy:** Click the button.
7.  **Copy/Paste:** Copy the generated code and paste it into your `steps { }` block.

**Important Note:**
The code generated (e.g., `checkout scm: ...`) is **Jenkins DSL**, not a raw Linux command.
*   *Wrong:* Writing `git clone https://...` (Linux command).
*   *Right:* Using the generated Git step (Jenkins DSL). Jenkins handles the logic of cloning, pulling, and checking for changes behind the scenes.

---

## 6. Practical Example: A 4-Stage Pipeline
Let's look at the example discussed in the lecture: **Pull, Build, Test, Deploy**.

#### Step 1: Create the Job
1.  Click **New Item**.
2.  Name it (e.g., `pipeline-demo`).
3.  Select **Pipeline** (Not Freestyle Project).

#### Step 2: Write the Script
In the **Script** section of the configuration:

```groovy
pipeline {
    agent any

    stages {
        stage('Pull') {
            steps {
                // Use Snippet Generator -> Git Step
                git branch: 'main', url: 'https://github.com/your-repo.git'
            }
        }

        stage('Build') {
            steps {
                // 'sh' is used to run shell commands
                sh 'echo "Build Success"'
                // You would add 'mvn clean package' here
            }
        }

        stage('Test') {
            steps {
                sh 'echo "Test Success"'
                // You would add SonarQube steps here
            }
        }

        stage('Deploy') {
            steps {
                sh 'echo "Deploy Success"'
                // You would add kubectl apply steps here
            }
        }
    }
}
```

#### Step 3: Run
1.  Click **Save**.
2.  Click **Build Now**.
3.  Click on the build number to see the **Stage View**.
4.  You will see 4 boxes (Pull, Build, Test, Deploy) light up Green as they complete successfully.

---

## 7. Summary Checklist
*   **Analogy:** A pipeline connects distinct jobs (pipes) to form a continuous flow.
*   **Plugin:** Install the "Pipeline" suite to get all necessary features.
*   **Syntax:** Use **Declarative Pipeline** (starts with `pipeline`).
*   **Structure:** `pipeline` -> `agent any` -> `stages` -> `stage` -> `steps`.
*   **Helper:** Use **Pipeline Syntax** (Snippet Generator) to generate code for Git, Maven, etc., so you don't have to memorize it.
*   **Execution:** Stages execute sequentially. If the 'Build' stage fails, the pipeline stops, and 'Test'/'Deploy' will not run.