variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "ami" {
  type        = string
  default     = "ami-0938a60d87953e820"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "key" {
  type        = string
}

# variable "sg" {
#   type        = list(string)
# }
