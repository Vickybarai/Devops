variable "region" {
  description = "AWS region"
  type        = string
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

variable "sg" {
  type        = list(string)
}