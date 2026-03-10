
provider "aws" {
  region = "ca-central-1"
}

module "jenkins" {
  source = "./TF-jenkin_install"

  instance_name = "instance"
  environment_name = "jenkins"
  ami_value = "ami-0938a60d87953e820"
  instance_type_value = "t3.micro"
  instance_key_name = "TF-key"
  vpc_security_group_ids = ["sg-0c34f567e22c52e77"]
  subnet_id_value = ["subnet-016c5cd1838c909f4"]
  storage_size = 9

#  user_data = <<-EOF
# sudo apt update
# sudo apt install fontconfig openjdk-21-jre -y
# java -version
# sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
#   https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
# echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
#   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
#   /etc/apt/sources.list.d/jenkins.list > /dev/null 
# sudo apt update
# sudo apt install jenkins 
#   sudo systemctl daemon-reload
#   sudo systemctl enable jenkins
#   sudo systemctl start jenkins
#   sudo systemctl status jenkins

user_data = <<-EOF
#!/bin/bash
set -e

# Update system packages
apt-get update -y

# Install required dependencies
apt-get install -y fontconfig openjdk-21-jre wget

# Verify Java installation
java -version

# Create keyrings directory
mkdir -p /etc/apt/keyrings

# Add Jenkins repository key
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list again
apt-get update -y

# Install Jenkins
apt-get install -y jenkins

# Start and enable Jenkins service
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Check Jenkins status
systemctl status jenkins
EOF

}
