

### 1. Core Concepts: Serverless & PaaS
**Analogy Used: Cricket (Cloud Service Models)**
To understand where Lambda/Azure Functions fit, the speaker used a cricket analogy:
*   **IaaS (Infrastructure as a Service - e.g., EC2/Azure VM):** The cloud provider gives you the **Ground**. You have to build the pitch, arrange the bat and ball, and play. You manage the infrastructure.
*   **PaaS (Platform as a Service - e.g., Lambda/Azure Functions):** The cloud provider gives you the **Pitch**. The ground is included. You just bring your bat and ball (code) and play. The provider manages the OS and scaling.
*   **SaaS (Software as a Service):** You just pay and play (like a Turf booking). You don't manage anything; you just log in and use the service.

**What is Serverless?**
*   **AWS Lambda:** You focus only on your code. AWS handles the server provisioning, OS patching, auto-scaling, and health checks.
*   **Azure Functions:** The exact same concept as AWS Lambda but within the Microsoft Azure ecosystem. You run code without managing servers.

---

### 2. Implementation Steps: Creating an Azure Function
Based on the lecture's demonstration, here is how to create an Azure Function:

**Step 1: Create a Function App**
1.  Navigate to the **Azure Portal**.
2.  Search for **"Function App"**.
3.  Click **Create**.
4.  **Basics Tab:**
    *   **Resource Group:** Create a new one (e.g., near your region for lower latency).
    *   **Function App Name:** Enter a unique name (e.g., add random numbers if needed).
    *   **Publish:** Keep as "Code".
    *   **Runtime Stack:** Select your language (e.g., **Node.js**, Python, etc.).
    *   **Region:** Select a region close to you (e.g., Central India).
5.  **Hosting Plan (Important):**
    *   Select **Consumption (Serverless)** plan.
    *   *Reason:* It is cost-effective (pay per execution) and handles scaling automatically.
6.  Click **Review + Create**, then **Create**.

**Step 2: Create the Function & Trigger**
1.  Once the resource is deployed, go to the resource.
2.  In the overview, click **Functions** (or "Create in Azure Portal").
3.  **Select Trigger:** Choose **HTTP Trigger** (for API access via URL).
    *   *Other options mentioned:* Timer Trigger (runs every 5 mins), Blob Trigger (runs on file upload).
4.  **Authorization Level:**
    *   **Anonymous:** Public access. Anyone with the URL can call it.
    *   **Function:** Requires a specific key (standard for internal APIs).
    *   **Admin:** Master key access.
    *   *Demo selection:* **Anonymous** (for testing purposes).
5.  Click **Create**.

**Step 3: Deploy Code**
1.  Select your runtime (e.g., Node.js).
2.  Paste your code into the code editor window.
3.  **Save** the code.
4.  **Get Function URL:** Copy the URL provided.
5.  Run the URL in a browser or tool (like Postman) to see the output.

---

### 3. Interview Ready Questions: AWS Lambda vs. Azure Functions

**Q1: What is the difference between AWS EC2 and AWS Lambda (or Azure VM vs Azure Functions)?**
*   **EC2/VM:** You get full control over the infrastructure (IaaS). You choose the OS, install patches, and manage scaling manually. It is like being given a cricket ground where you have to prepare the pitch yourself.
*   **Lambda/Functions:** It is a PaaS/Serverless service. You only upload the code. The cloud provider manages the OS, scaling, and server health automatically. You pay only for the time your code runs.

**Q2: Explain the Hosting Plans in Azure Functions.**
*   **Consumption Plan:** The default serverless plan. You pay per execution. It scales automatically but has a timeout limit (e.g., 10 mins). It is cost-effective for sporadic workloads.
*   **Premium Plan:** Provides enhanced performance (VNet integration, no cold starts) but costs more.
*   **Dedicated (App Service) Plan:** Like standard web hosting. You pay for the VM instance regardless of whether code is running.

**Q3: What are "Triggers" in the context of Serverless computing?**
*   Triggers are events that start the execution of the function.
*   **Common Examples:**
    *   **HTTP Trigger:** Invoked via an HTTP URL (API call).
    *   **Timer Trigger:** Runs on a schedule (e.g., every 5 minutes or hourly).
    *   **Blob Trigger:** Runs when a file is uploaded to storage (e.g., processing an image).
    *   **Queue Trigger:** Runs when a message is added to a queue.

**Q4: What are the similarities between AWS Lambda and Azure Functions?**
*   Both are **Serverless** (PaaS) compute services.
*   Both support multiple programming languages (Python, Node.js, Java, C#, etc.).
*   Both auto-scale based on the number of incoming events.
*   Both follow a "pay-per-use" pricing model based on execution time and memory consumption.

**Q5: What are the Authorization Levels available for HTTP Triggers in Azure Functions?**
*   **Anonymous:** No key required; open to the public.
*   **Function:** Requires a function-specific key (secured).
*   **Admin:** Requires the master key (highest level of access).

**Q6: How does the pricing model differ between AWS Lambda and Azure Functions?**
*   **AWS Lambda:** Charges based on the number of requests and the duration (memory x GB-seconds).
*   **Azure Functions:** On the Consumption plan, it also charges per execution and duration (GB-seconds). However, Azure offers distinct "Hosting Plans" (Consumption vs. Premium) which allows for slightly different cost control strategies regarding resource allocation compared to AWS's pure tiered memory approach.