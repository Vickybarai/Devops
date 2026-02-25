provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my_instance" {
    ami = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    vpc_security_group_ids = [var.sg_id, aws_security_group.my_sg.id]
    tags = {
        Name = "my_instance"
        env = "dev"
    }
    # heredoc
    user_data = <<EOF
    #!/bin/bash
    yum install httpd -y
    systemctl enable httpd
    systemctl start httpd
    EOF
}

resource "aws_security_group" "my_sg" {
    name = "new-sg"
    description = "new security group"
    vpc_id = data.aws_vpc.my_vpc.id

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
        protocol = -1        
    }
}

data "aws_vpc" "my_vpc" {
    default = true
}

variable "image_id" {
    description = "enter AMI ID"
    default = "ami-0c1fe732b5494dc14"
}

variable "instance_type" {
    description = "enter instance type"
    default = "t3.micro"
}

variable "key_pair" {
    default = "new-key"
}

variable "sg_id" {
    default = "sg-07316d011e1dec8ce"
}

output "public_ip" {
    value = aws_instance.my_instance.public_ip
}
