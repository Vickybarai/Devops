
<<<<<<< HEAD
# provider "aws" {
#   region = "ca-central-1"
# }

# module "ec2" {
#   source = "./modules/ec2"

#   instance_name = "instance"
#   environment_name = "jenkins"
#   ami_value = "ami-0938a60d87953e820"
#   instance_type_value = "t3.micro"
#   instance_key_name = "TF-key"
#   vpc_security_group_ids = ["sg-0c34f567e22c52e77"]
#   subnet_id_value = ["subnet-016c5cd1838c909f4"]
#   storage_size = 9
# user_data = <<-EOF
# #!/bin/bash
# set -e

# apt update -y
# apt install -y fontconfig openjdk-21-jre

# mkdir -p /etc/apt/keyrings

# curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
# | tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null

# echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
# https://pkg.jenkins.io/debian-stable binary/ \
# | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# apt update -y
# apt install -y jenkins

# systemctl enable jenkins
# systemctl start jenkins
# EOF
# }
=======
provider "aws" {
  region = "ca-central-1"
}

module "ec2" {
  source = "./modules/ec2"

  instance_name = "instance"
  environment_name = "jenkins"
  ami_value = "ami-0938a60d87953e820"
  instance_type_value = "t3.micro"
  instance_key_name = "TF-key"
  vpc_security_group_ids = ["sg-0c34f567e22c52e77"]
  subnet_id_value = ["subnet-016c5cd1838c909f4"]
  storage_size = 9
user_data = <<-EOF
#!/bin/bash
sudo -i

apt update -y && apt install -y fontconfig openjdk-21-jre

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y && apt install -y jenkins

systemctl enable jenkins && systemctl start jenkins
EOF

}
>>>>>>> 40a49ddd9e152cf3ea2cb07ec426d9e1ead6b0d6
