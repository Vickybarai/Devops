provider "aws" {
    region = "us-east-1"
}

### COUNT LOOP FOR IDENTICAL CONFIGURATION

# resource "aws_instance" "my_instance_1" {
#     count = 3
#     ami = "ami-0c1fe732b5494dc14"
#     instance_type = "t3.micro"
#     key_name = "new-key"

#     vpc_security_group_ids = ["sg-07316d011e1dec8ce"]
#     tags = {
#         Name = "my_instance"
#         env = "dev"
#     }
# }


### FOR EACH LOOP FOR SINGLE CONFIGURATION

# resource "aws_instance" "my_instance_1" {
#     for_each = toset(["ami-0c1fe732b5494dc14", "ami-0b6c6ebed2801a5cb"])
#     ami = each.value
#     instance_type = 
#     key_name = "new-key"
#     vpc_security_group_ids = ["sg-07316d011e1dec8ce"]
#     tags = {
#         Name = "my_instance"
#         env = "dev"
#     }
# }


### FOR EACH LOOP FOR DIFFERENT CONFIGURATION

# resource "aws_instance" "my_instance_1" {
#     for_each = tomap(var.my_instance)
#     ami = each.value.ami
#     instance_type = each.value.instance_type
#     key_name = each.value.key_name

#     vpc_security_group_ids = ["sg-07316d011e1dec8ce"]
#     tags = {
#         Name = each.key
#         env = "dev"
#     }
# }

# variable "my_instance" {
#     default =  { instance1 = {instance_type = "t2.micro", ami = "ami-0c1fe732b5494dc14", key_name = "new-key"},
#                 instance2 = {instance_type = "t2.micro", ami = "ami-0b6c6ebed2801a5cb", key_name = "new-key"},
#                 instance3 = {instance_type = "t3.micro", ami = "ami-0c1fe732b5494dc14", key_name = "new-key"}
#     }
# }

# resource "aws_instance" "my_instance" {
#     count = 3
#     ami = "ami-0c1fe732b5494dc14"
#     instance_type = "t3.micro"
#     key_name = "new-key"

#     vpc_security_group_ids = ["sg-07316d011e1dec8ce"]
#     tags = {
#         Name = "my_instance"
#         env = "dev"
#     }
# }

# output "my_instance" {
#     value = [for ip in aws_instance.my_instance : ip.public_ip]
# }

resource "aws_instance" "my_instance" {
    count = 3
    ami = "ami-0c1fe732b5494dc14"
    instance_type = "t3.micro"
    key_name = "new-key"

    vpc_security_group_ids = ["sg-07316d011e1dec8ce"]
    tags = {
        Name = "my_instance"
        env = "dev"
    }
}

output "my_output"  {
    value = aws_instance.my_instance[*].public_ip
}
