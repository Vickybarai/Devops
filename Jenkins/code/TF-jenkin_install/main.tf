resource "aws_instance" "EC2"{
  ami           = var.ami_value
  instance_type = var.instance_type_value
  key_name = var.instance_key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id     = var.subnet_id_value[0]
  associate_public_ip_address = true
    tags = {
    Name = "${var.environment_name}-${var.instance_name}"
    Environment = var.environment_name
  }
  root_block_device {
  volume_size = var.storage_size
  }
  user_data = var.user_data
}