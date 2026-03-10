provider "aws" {
  region = "ca-central-1"
}   

module "s3" {
  source = "./module/s3"
 
  s3_bucket = "tf-s3-bucket-2024"
  object_ownership = "BucketOwnerPreferred"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  acl    = "public-read"

    Effect    = "Allow"
    Principal = "*"
    Action    = "s3:GetObject"

    s3_bucket_website_configuration-suffix = "index.html"

    upload_index-key = "index.html"
    upload_index-source       = "./index.html" 
    upload_index-content_type = "text/html"
    upload_index-acl          = "public-read"

}
output "website_url" {
  value = module.s3.website_url
}
