

### 1. Linux & Operating System

#### **How do you find files modified two days ago in Linux?**
*   **What:** A command to search the filesystem based on time metadata.
*   **Type:** File search command (`find`).
*   **Use:** To locate logs, configuration changes, or recently created files.
*   **How:** Use the `find` command with the `-mtime` flag.
    ```bash
    find . -mtime -2 -type f
    ```
*   **Simple Interview Answer:**
    "I use the `find` command. Specifically, `find . -mtime -2 -type f` looks in the current directory (`.`) for files (`-type f`) modified less than 2 days ago (`-mtime -2`). This is useful for tracking recent changes or finding specific log files generated in the last 48 hours."

#### **What is the sudoers file? What is its purpose?**
*   **What:** A configuration file that defines user permissions.
*   **Type:** System configuration file located at `/etc/sudoers`.
*   **Use:** To control which users have the right to execute commands as the `root` or superuser.
*   **How:** It is edited using the `visudo` command (which locks the file and checks syntax) to prevent errors.
*   **Simple Interview Answer:**
    "The `sudoers` file is the central control point for user permissions in Linux. It determines *who* can run *what* commands with elevated privileges. Its purpose is security—ensuring not everyone has root access, and allowing specific users to perform specific admin tasks. We always edit it with `visudo` to avoid locking ourselves out with syntax errors."

#### **What is a zombie process?**
*   **What:** A process that has completed execution but still holds an entry in the process table.
*   **Type:** Defunct process.
*   **Use:** (None, it is a system state).
*   **How:** It occurs when a child process finishes but the parent process hasn't called `wait()` to read its exit status yet.
*   **Simple Interview Answer:**
    "A zombie process is essentially a dead process that hasn't been fully 'cleaned up' by its parent. The child finished its job and sent an exit signal, but the parent didn't acknowledge it. It appears in the process table but consumes no memory or CPU. If the parent crashes, the 'init' process (PID 1) usually adopts and cleans these up."

#### **Any short Linux question (commands, permissions, process management, networking basics)**
*   **Permissions:**
    *   **What:** Access controls for files/directories.
    *   **How:** `chmod 755 file` (Owner: rwx, Group: rx, Others: rx).
*   **Process Management:**
    *   **What:** Managing running programs.
    *   **How:** `ps -ef` (view processes), `kill -9 [PID]` (force stop).
*   **Networking:**
    *   **What:** Checking connectivity.
    *   **How:** `ping google.com`, `curl -I http://example.com` (check headers).
*   **Simple Interview Answer:**
    "For permissions, I use `chmod` and `chown` to manage access. For processes, I rely on `ps` to list them and `kill` to stop them. For networking basics, I use `ping` to check connectivity and `netstat` or `ss` to see which ports are open and listening on the server."

---

### 2. AWS (Amazon Web Services)

#### **How do you allow HTTP and HTTPS access to an EC2 instance?**
*   **What:** Configuring network access rules.
*   **Type:** Security Group Inbound Rules.
*   **Use:** To allow web traffic to reach your application.
*   **How:** Edit the Security Group attached to the EC2 instance. Add rules for Port 80 (HTTP) and Port 443 (HTTPS).
*   **Simple Interview Answer:**
    "You need to configure the **Security Group** associated with the instance. I would add an Inbound Rule allowing traffic on Port 80 for HTTP and Port 443 for HTTPS. I would usually set the source to `0.0.0.0/0` to allow access from anywhere, or restrict it to a specific IP range for better security."

#### **What is the pricing model of the CloudWatch Agent?**
*   **What:** Cost structure for monitoring data.
*   **Type:** Pay-as-you-go based on data volume.
*   **Use:** To monitor servers and applications more deeply than standard metrics.
*   **How:** You pay for custom metrics and log ingestion (data sent to CloudWatch).
*   **Simple Interview Answer:**
    "The CloudWatch Agent software itself is free, but you pay for the **data** it generates. Specifically, you are charged for **Custom Metrics** and **Log Ingestion/Storage**. Standard metrics like CPU usage are free, but if I send detailed application logs or custom memory stats, I pay based on the volume of that data."

#### **What is the difference between ALB and NLB?**
*   **What:** Two types of AWS Load Balancers.
*   **Type:**
    *   **ALB (Application Load Balancer):** Layer 7 (Application).
    *   **NLB (Network Load Balancer):** Layer 4 (Transport).
*   **Use:** ALB for web routing (URL paths); NLB for ultra-high performance (TCP/UDP).
*   **How:** ALB inspects HTTP headers; NLB just passes packets.
*   **Simple Interview Answer:**
    "The main difference is the Layer they operate on. **ALB** works at Layer 7, meaning it understands HTTP/HTTPS content and can route traffic based on URL paths (like `/api` vs `/images`). **NLB** works at Layer 4, handling raw TCP and UDP traffic. NLB is much faster and handles millions of requests per second, but it can't inspect the content of the packets like ALB can."

#### **What is the difference between Multi-AZ and Load Balancing?**
*   **What:** Two distinct high-availability strategies.
*   **Type:** Infrastructure redundancy (Multi-AZ) vs. Traffic distribution (Load Balancing).
*   **Use:** Multi-AZ protects against data center failure; Load Balancing prevents server overload.
*   **How:** Multi-AZ replicates data across physical data centers; Load Balancing spreads traffic across healthy instances.
*   **Simple Interview Answer:**
    "They serve different purposes. **Multi-AZ** is about disaster recovery—it duplicates my resources (like a database) across separate physical data centers so if one burns down, the other takes over. **Load Balancing** is about traffic management—it distributes incoming users across multiple servers so no single server crashes due to heavy load."

#### **Explain NAT Gateway (creation + traffic flow)**
*   **What:** Network Address Translation Gateway.
*   **Type:** Managed AWS service for outbound internet access.
*   **Use:** To allow private instances (in a private subnet) to download updates/patches without being exposed to the internet.
*   **How:**
    1.  Create it in a **Public Subnet**.
    2.  Allocate an **Elastic IP**.
    3.  Update **Private Subnet Route Table** to point `0.0.0.0/0` to the NAT Gateway ID.
*   **Simple Interview Answer:**
    "A NAT Gateway lets private servers talk *out* to the internet, but stops the internet from talking *in*. To create one, you place it in a Public Subnet and give it a static Elastic IP. For traffic flow: When a private instance requests a web page, the request goes to the Route Table, which directs it to the NAT Gateway. The NAT Gateway replaces the private IP with its public IP, sends the request out, and passes the response back to the private instance."

#### **Explain Auto Scaling Group**
*   **What:** A logical grouping of EC2 instances.
*   **Type:** Elasticity service.
*   **Use:** To automatically adjust capacity based on demand (scale out when busy, scale in when quiet).
*   **How:** Define a minimum/maximum size and scaling policies (e.g., add an instance if CPU > 80%).
*   **Simple Interview Answer:**
    "An Auto Scaling Group ensures I have the correct number of EC2 instances running to handle the load. If traffic spikes and CPU usage goes high, it automatically launches new instances. If traffic drops, it terminates instances to save money. It also handles health checks, replacing any unhealthy instances automatically."

#### **Explain Load Balancer in AWS**
*   **What:** A traffic manager.
*   **Type:** ELB (Classic), ALB, or NLB.
*   **Use:** To distribute incoming application traffic across multiple targets (EC2, Containers) in multiple Availability Zones.
*   **How:** It acts as a single point of contact (DNS name) for clients and routes requests only to registered, healthy targets.
*   **Simple Interview Answer:**
    "A Load Balancer sits in front of my servers and acts as a traffic cop. It accepts incoming requests and routes them to a group of backend servers (like EC2 instances) using algorithms like Round Robin. If a server fails, the Load Balancer detects it and stops sending traffic there until it recovers."

#### **Explain S3 Lifecycle policies and Storage Classes**
*   **What:** Rules to manage data cost and retention.
*   **Type:** S3 feature (Lifecycle configuration).
*   **Use:** To automatically move data to cheaper storage as it gets older (Cost Optimization).
*   **How:**
    *   **Storage Classes:** Standard (Hot), IA (Infrequent Access), Glacier (Cold/Archive).
    *   **Policy:** "Move to IA after 30 days, Delete after 1 year."
*   **Simple Interview Answer:**
    "S3 Lifecycle policies automate data management. For example, I can set a rule to move files from **S3 Standard** (expensive) to **S3 Glacier** (very cheap) 30 days after they are created. Storage classes help us pay less for data we don't access often. The policy handles the move automatically so we don't have to do it manually."

---

### 3. Kubernetes (K8s) & Containerization

#### **What is the difference between arguments (args) and environment variables (env)?**
*   **What:** Two ways to pass configuration to a container.
*   **Type:** Runtime parameters.
*   **Use:** `env` for configuration settings; `args` for command execution details.
*   **How:** `env` sets `KEY=VALUE` pairs inside the OS; `args` passes parameters directly to the entrypoint command.
*   **Simple Interview Answer:**
    "Both pass data to the application, but differently. **Environment Variables (`env`)** are like settings loaded into the container's operating system (e.g., `DB_HOST=localhost`). **Arguments (`args`)** are command-line flags passed to the application command itself (e.g., `--port=8080`). I use `env` for general config and `args` when I need to override the startup command."

#### **What is the difference between ConfigMap and Secret?**
*   **What:** K8s objects for storing configuration data.
*   **Type:** Non-sensitive vs. Sensitive data storage.
*   **Use:** ConfigMap for URLs and config files; Secret for passwords and tokens.
*   **How:** ConfigMap stores plain text; Secret stores base64 encoded data.
*   **Simple Interview Answer:**
    "The main difference is sensitivity. A **ConfigMap** is used for non-sensitive data like configuration files, application variables, or URLs. A **Secret** is used for sensitive data like passwords, SSH keys, or API tokens. While Secrets are base64 encoded and not meant to be logged, they aren't encrypted by default without extra configuration, but they are treated more securely by Kubernetes."

#### **Explain three-tier architecture in Kubernetes**
*   **What:** A standard app design pattern.
*   **Type:** Architecture pattern.
*   **Use:** To separate concerns: Presentation, Logic, and Data.
*   **How:**
    1.  **Frontend (Web):** Pods exposed via Service/Ingress.
    2.  **Backend (App):** Pods communicating with Frontend and Database.
    3.  **Database:** Usually StatefulSet or External Service.
*   **Simple Interview Answer:**
    "In K8s, this means separating the app into three layers:
    1.  **Frontend:** A Deployment (like React/Node) exposed to the internet via an Ingress.
    2.  **Backend:** A Deployment (like Java/Python) that connects to the frontend but stays internal.
    3.  **Database:** A StatefulSet (or Cloud DB) for data persistence.
    Communication happens via internal K8s Services (ClusterIP)."

#### **Traffic is routed to a pod, but no response is received — what could be the issue?**
*   **What:** Troubleshooting network connectivity in K8s.
*   **Type:** Debugging scenario.
*   **Use:** To identify why a service is failing.
*   **How:** Check Pod logs, Pod status (CrashLoopBackOff), Port mismatch, Security Groups, or Resource limits.
*   **Simple Interview Answer:**
    "If traffic reaches the Pod but gets no response, I would check three things:
    1.  **Application Crash:** Did the app start? I check `kubectl logs` to see if it threw an error.
    2.  **Port Mismatch:** Is the app listening on port 8080, but the K8s Service is pointing to port 80?
    3.  **Security Groups:** Is an AWS firewall blocking the response traffic?
    4.  **Probes:** Did the Liveness/Readiness probe fail, causing K8s to stop routing traffic?"

#### **Explain Deployment vs StatefulSet**
*   **What:** Controllers for managing Pods.
*   **Type:** Stateless vs. Stateful workload management.
*   **Use:** Deployment for web servers; StatefulSet for databases.
*   **How:** Deployment creates interchangeable Pods with random IDs. StatefulSet creates Pods with sticky, ordered names (web-0, web-1) and stable storage.
*   **Simple Interview Answer:**
    "**Deployment** is for stateless apps. All Pods are identical; if one dies, a new random one replaces it. **StatefulSet** is for stateful apps like databases. It guarantees that a Pod always has the same identity (name) and the same storage, even if it restarts. This is crucial because databases need to know 'who they are' to maintain data consistency."

#### **Write and explain a Pod manifest file**
*   **What:** A YAML file defining a Pod.
*   **Type:** K8s Configuration.
*   **Use:** To declare the desired state of a Pod.
*   **How:**
    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: my-app-pod
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
    ```
*   **Simple Interview Answer:**
    "This YAML creates a single Pod.
    *   `apiVersion: v1` and `kind: Pod` tell K8s what object we are making.
    *   `metadata.name` gives it a unique ID.
    *   `spec` defines the 'desired state'. Here, I'm asking for a container named `nginx` using the `nginx:latest` image, and I'm declaring that the app listens on port 80 inside the container."

---

### 4. Docker

#### **Write and explain a Dockerfile for a Java application**
*   **What:** A text document containing all commands to build an image.
*   **Type:** Build script.
*   **Use:** To automate the creation of a Docker image for an app.
*   **How:**
    ```dockerfile
    # 1. Base OS with Java
    FROM openjdk:11-jre-slim

    # 2. Working directory
    WORKDIR /app

    # 3. Copy JAR file
    COPY target/myapp.jar /app/myapp.jar

    # 4. Run command
    CMD ["java", "-jar", "myapp.jar"]
    ```
*   **Simple Interview Answer:**
    "I start with `FROM openjdk:11` to get a lightweight Java environment.
    *   `WORKDIR /app` sets the directory inside the container.
    *   `COPY` moves my compiled Java JAR file from my machine into the container.
    *   `CMD` specifies the command that runs when the container starts—executing the Java JAR file. This ensures anyone who runs this image gets the exact same runtime environment."

---

### 5. Git & Version Control

#### **What is the difference between git revert and git reset?**
*   **What:** Commands to undo changes.
*   **Type:** History manipulation.
*   **Use:** Revert for safe undoing on shared branches; Reset for cleaning local history.
*   **How:** `revert` creates a *new* commit that undoes changes. `reset` moves the branch pointer *back*, deleting commits.
*   **Simple Interview Answer:**
    "The key difference is safety. **`git revert`** creates a *new* commit that reverses a previous change. This is safe for shared branches because it preserves history. **`git reset`** moves the branch pointer backward, effectively deleting commits. I use this only on my local machine to clean up messy commits before pushing, because it rewrites history and can break other people's repositories if used on shared code."

#### **Why are Git webhooks used?**
*   **What:** HTTP callbacks triggered by Git events.
*   **Type:** Automation trigger.
*   **Use:** To connect Git events (like a push) to external tools (like Jenkins).
*   **How:** Configure a URL in GitHub/GitLab settings. When code is pushed, Git sends a POST request to that URL.
*   **Simple Interview Answer:**
    "Webhooks are used for automation. For example, when I push code to GitHub, the webhook sends an automatic signal to my Jenkins server. This signal triggers the Jenkins pipeline to start building and testing the code immediately. It removes the need for a human to manually click a 'build' button every time code changes."

#### **Explain branching strategy in GitHub**
*   **What:** Rules for creating and merging branches.
*   **Type:** Workflow management (e.g., Git Flow, Trunk Based).
*   **Use:** To organize development and stabilize the production code.
*   **How:** Maintain a permanent `main` branch. Create short-lived `feature` branches for new work. Merge via Pull Requests.
*   **Simple Interview Answer:**
    "I typically use a simplified **Git Flow**. We have a `main` branch for production-ready code. When I need to work on a new feature, I create a `feature` branch from `main`. Once the code is tested and ready, I create a **Pull Request (PR)**. My team reviews the code, and once approved, it merges back into `main`. This keeps `main` stable and allows for easy code review."

---

### 6. CI/CD (Jenkins + Code Quality)

#### **What are the stages in a Jenkins pipeline?**
*   **What:** Logical blocks of work in a pipeline script.
*   **Type:** Pipeline definition (Declarative or Scripted).
*   **Use:** To break down the software delivery process into distinct steps.
*   **How:** Defined in a `Jenkinsfile` using the `stage` block.
*   **Simple Interview Answer:**
    "Stages divide the pipeline into clear steps. Typical stages include **Build** (compiling code), **Test** (running unit/integration tests), and **Deploy** (pushing to a server). This structure makes logs easier to read and helps us fail fast—if the build stage fails, the pipeline stops, and we don't waste time running tests on broken code."

#### **Explain a 4-stage pipeline (Pull → Build → Test → Deploy)**
*   **What:** A standard continuous delivery workflow.
*   **Type:** CI/CD Pipeline.
*   **Use:** To automate the path from code commit to production.
*   **How:**
    1.  **Pull:** `git checkout` / `git pull` to get latest code.
    2.  **Build:** `mvn clean package` or `docker build`.
    3.  **Test:** `mvn test` or run automated scripts.
    4.  **Deploy:** `kubectl apply` or `scp` to server.
*   **Simple Interview Answer:**
    "This is the standard automation flow:
    1.  **Pull:** Jenkins fetches the latest code from the Git repository.
    2.  **Build:** It compiles the source code (e.g., compiling Java or building a Docker image).
    3.  **Test:** It runs automated tests to ensure the build isn't broken.
    4.  **Deploy:** If tests pass, it deploys the artifact to a server or Kubernetes environment."

#### **Why is SonarQube used? What is a Quality Gate?**
*   **What:** Static code analysis tool.
*   **Type:** Code Quality & Security tool.
*   **Use:** To detect bugs, code smells, and security vulnerabilities automatically.
*   **How:** It scans code during the CI pipeline. A **Quality Gate** is a pass/fail criteria (e.g., "Coverage must be > 80%").
*   **Simple Interview Answer:**
    "SonarQube is used to analyze code quality for bugs and vulnerabilities. A **Quality Gate** is the pass/fail threshold defined for the project. For example, we might set a Quality Gate that says 'New code coverage must be at least 80%.' If the code fails this check, SonarQube will fail the build, preventing low-quality or insecure code from being merged to the main branch."

---

### 7. Terraform (Infrastructure as Code)

#### **What is terraform.tfstate? How do you secure it?**
*   **What:** A file that tracks the real-world resources managed by Terraform.
*   **Type:** State file (JSON format).
*   **Use:** To map your configuration to the actual resource IDs in the cloud (e.g., mapping "web_server" to "i-12345").
*   **How:** Terraform creates it automatically.
*   **Security:** Never commit to Git. Store in a secure backend like AWS S3 with encryption and versioning.
*   **Simple Interview Answer:**
    "The `terraform.tfstate` file is Terraform's memory. It stores the IDs and properties of the real infrastructure AWS created so Terraform knows what to update next time. It contains sensitive data, so I **never** commit it to Git. To secure it, I use a **Remote Backend** like AWS S3 with server-side encryption enabled, and I enable **State Locking** (using DynamoDB) so two people can't write to it at the same time."

#### **Write and explain an EC2 Terraform configuration file (ec2.tf)**
*   **What:** A Terraform configuration file (HCL language).
*   **Type:** Infrastructure Code.
*   **Use:** To provision an EC2 instance on AWS.
*   **How:**
    ```hcl
    resource "aws_instance" "my_web_server" {
      ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
      instance_type = "t2.micro"

      tags = {
        Name = "MyWebServer"
      }
    }
    ```
*   **Simple Interview Answer:**
    "This file defines an AWS EC2 instance using Terraform.
    *   `resource "aws_instance"` tells Terraform we want to create a virtual machine.
    *   `ami` specifies which machine image to use (like the OS template).
    *   `instance_type` defines the hardware size (`t2.micro` is the free tier eligible size).
    *   `tags` are used to label the instance 'MyWebServer' so we can easily identify it in the AWS console."