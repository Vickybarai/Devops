variable "instance_name" {
  description = "value for instance name"
  type = string
}

variable "ami_value" {
  description = "value for ami instance type"
  type = string
}

variable "instance_type_value" {
  description = "value for aws instance_type"
  type = string
}

variable "instance_key_name" {
  description = "value for aws key_name"
  type = string
}

variable "vpc_security_group_ids" {
  description = "value for aws vpc_security_group_ids"
  type = list(string)
  default = ["sg-067611a347a2c9c1a" ]
}

variable "subnet_id_value" {
  description = "value for aws subnet_id"
  type = list(string)
  default = ["subnet-014cfef582bc076a8", "subnet-016c5cd1838c909f4"]
}

variable "storage_size" {
  description = "value for storage size"
  type = number
}

variable "environment_name" {
  description = "value for environment name"
  type = string
}

variable "user_data" {
  description = "value for user script"
  type = string
}