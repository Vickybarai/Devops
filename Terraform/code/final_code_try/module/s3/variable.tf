variable "s3_bucket" {
  type = string
  description = "S3_bucket name"
}

variable "object_ownership" {
  type = string
  description = "Ownership control for the S3 bucket"
}

variable "block_public_acls" {
  type = bool
  description = "Whether to block public ACLs for the S3 bucket"
}   
variable "block_public_policy" {
  type = bool
  description = "Whether to block public policies for the S3 bucket"
}
variable "ignore_public_acls" {
  type = bool
  description = "Whether to ignore public ACLs for the S3 bucket"
}
variable "restrict_public_buckets" {
  type = bool
  description = "Whether to restrict public buckets for the S3 bucket"
}

variable "acl" {
  type = string
  description = "ACL for the S3 bucket"
}   

variable "Effect" {
  type =    string
  description = "Effect for the S3 bucket policy statement"
}

variable "Principal" {
  type =    string
  description = "Principal for the S3 bucket policy statement"
}

variable "Action" {
  type =    string
  description = "Action for the S3 bucket policy statement"
}
variable "s3_bucket_website_configuration-suffix" {
  type =    string
  description = "Suffix for the S3 bucket website configuration"
}

variable "upload_index-key" {
  type = string
}

variable "upload_index-source" {
  type = string
}

variable "upload_index-content_type" {
  type = string
}   
variable "upload_index-acl" {
  type = string
}
