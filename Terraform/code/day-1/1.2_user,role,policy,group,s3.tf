provider "aws" {
    region = "ca-central-1"
}

# user

resource "aws_iam_user" "TF-user-child1" {
  name = "TF-user-child1"
}

resource "aws_iam_policy" "TF-policy-child1" {
  name        = "TF-policy-child1"
  description = "A s3-read policy for TF-user-child1"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:ListBucket"],
        Resource = "arn:aws:s3:::my-tf-s3-bucket-1234567890"
      },
      {
          Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = "arn:aws:s3:::my-tf-s3-bucket-1234567890/*"
      }

    ]
  })
}

# group

resource "aws_iam_group" "TF-group" {
    name = "TF-group"
    }

resource "aws_iam_group_membership" "TF-group-membership" {
    name = "TF-group-membership"
    users = [aws_iam_user.TF-user-child1.name]
    group = aws_iam_group.TF-group.name
    }


resource "aws_iam_group_policy_attachment" "s3-full-access-policy" {
    group = aws_iam_group.TF-group.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}    


#s3

resource "aws_s3_bucket" "TF-s3-bucket" {
  bucket = "my-tf-s3-bucket-1234567890"
}

resource "aws_s3_bucket_ownership_controls" "ownership"{
 bucket = aws_s3_bucket.TF-s3-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "TF-s3-bucket-public-access-block" {
  bucket = aws_s3_bucket.TF-s3-bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.TF-s3-bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject","s3:ListBucket"],
        Resource = "arn:aws:s3:::my-tf-s3-bucket-1234567890/*"
      }
    ]
  })
}

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   depends_on = [
#     aws_s3_bucket_ownership_controls.ownership,
#     aws_s3_bucket_public_access_block.TF-s3-bucket-public-access-block
#   ]
#   bucket = aws_s3_bucket.TF-s3-bucket.id
#   acl    = "public-read"
# }

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.TF-s3-bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "upload_index" {
  bucket       = aws_s3_bucket.TF-s3-bucket.id
  key          = "index.html"
  source       = "E:\\vs code\\GITHUB\\Devops\\Terraform\\code\\day-1\\index.html"
 }

 #output

output "website_url" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

output "user_name" {
  value = aws_iam_user.TF-user-child1.name
}

output "user_direct_permissions" {
  value = "Read Only S3 (Direct Policy Attachment)"
}

output "user_inherited_permissions" {
  value = "Full S3 Access (via Group Membership)"
}
