provider "aws" {
  region = var.region
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_subnet" "tf_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "tf_subnet"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.tf_subnet.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
}



resource "aws_security_group" "vpc_sg_tf" {
  name   = "vpc_sg_tf"
  vpc_id = aws_vpc.tf_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "TF-instance"{
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key
  vpc_security_group_ids      = [aws_security_group.vpc_sg_tf.id]
  subnet_id                   = aws_subnet.tf_subnet.id
  associate_public_ip_address = true
  depends_on = [
    aws_internet_gateway.tf_igw,
    aws_route_table_association.rt_association
  ]

user_data = <<-EOF
#!/bin/bash
apt update -y
apt install -y nginx
systemctl enable nginx
systemctl start nginx
echo "Terraform NGINX Working" > /usr/share/nginx/html/index.html
EOF



  tags = {
    Name = "my-terraform-instance"
  }
}
