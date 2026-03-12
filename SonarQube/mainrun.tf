
provider "aws" {
  region = "ca-central-1"
}

module "sonarqube" {
  source = "./TF-sonar_install"

  instance_name = "instance"
  environment_name = "sonar"
  ami_value = "ami-0938a60d87953e820"
  instance_type_value = "t3.micro"
  instance_key_name = "TF-key"
  vpc_security_group_ids = ["sg-0c34f567e22c52e77"]
  subnet_id_value = ["subnet-016c5cd1838c909f4"]
  storage_size = 9

 user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install openjdk-17-jdk postgresql -y


EOF

}
output "sonarqube_public_ip" {
  value = module.sonarqube.public_ip
}
