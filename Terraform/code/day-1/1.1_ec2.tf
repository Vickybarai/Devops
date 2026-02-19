provider "aws" {
    region = "ca-central-1"
}

resource "aws_instance" "TF-instance" {
  ami           = "ami-0938a60d87953e820"
  instance_type = "t3.micro"
  key_name      = "TF-key" 
  vpc_security_group_ids = ["sg-0798a20332ea69abf"]  
  tags = {
    Name = "my-terraform-instance"
  }
}
