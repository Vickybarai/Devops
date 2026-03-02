
resource "aws_instance" "TF-instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key 
  vpc_security_group_ids = var.sg
  tags = {
    Name = "my-terraform-instance"  
  }
}