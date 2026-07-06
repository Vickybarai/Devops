1. Update System Packages:
Ensure your system repository is up to date with the latest packages.
`sudo apt update`

2. Install Docker:
Install the Docker engine required to run containers.
`sudo apt install docker.io`

3. Configure Docker Permissions:
Grant the necessary permissions to the user and the Docker daemon to avoid "permission denied" errors.
`sudo usermod -aG docker $USER`
`newgrp docker`
`sudo chmod 777 /var/run/docker.sock`

4. Install kubectl:
Install the Kubernetes command-line tool to interact with your cluster.
`sudo apt install kubectl`

5. Install Minikube:
Install Minikube to create a local Kubernetes cluster.
`sudo apt install minikube`

6. Start the Minikube Cluster:
Initialize your local cluster.
`minikube start`

7. Apply Pod Configuration:
Once you have created your YAML file (e.g., `pod.yaml`), deploy it to the cluster.
`kubectl apply -f pod.yaml`

Useful Management Commands:
To check the cluster status: `minikube status`
To list all nodes: `kubectl get nodes`
To list all pods: `kubectl get pods`
To view detailed info about a specific pod: `kubectl describe pod `