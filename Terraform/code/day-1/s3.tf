provider "aws" {
  region = "ca-central-1"
}

# 2. IAM SECTION
# (Order: User -> Group -> Membership -> Policy Attachment)

resource "aws_iam_user" "TF-ami-user" {
  name = "TF-ami-user"
}

resource "aws_iam_group" "TF-group" {
  name = "TF-group"
}

resource "aws_iam_group_membership" "TF-group-membership" {
  name   = "TF-group-membership"
  users  = [aws_iam_user.TF-ami-user.name]
  group  = aws_iam_group.TF-group.name
}

# Custom Policy (Cleaned up JSON)
resource "aws_iam_policy" "TF-s3-policy" {
  name        = "TF-s3-policy"
  description = "S3 Access Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::my-tf-s3-bucket-1234567890"
      },
      {
        Effect   = "Allow"
        # Removed "ListBucket" here because it doesn't apply to objects (/*)
        Action   = ["s3:GetObject", "s3:DeleteObject"] 
        Resource = "arn:aws:s3:::my-tf-s3-bucket-1234567890/*"
      }
    ]
  })
}

# Attach AWS Managed Policy to Group
resource "aws_iam_group_policy_attachment" "s3-full-access-policy" {
  group      = aws_iam_group.TF-group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# 3. S3 SECTION 
#  Create the Bucket
resource "aws_s3_bucket" "TF-s3-bucket" {
  bucket = "my-tf-s3-bucket-1234567890"
}

#  Configure Ownership (Required for ACLs)
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.TF-s3-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Turn Off Public Access Block (Required for Website)
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.TF-s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set Bucket ACL to Public 
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.public_access_block
  ]

  bucket = aws_s3_bucket.TF-s3-bucket.id
  acl    = "public-read"
}

# Apply Bucket Policy . We add depends_on to ensure Public Access is OFF before applying policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.TF-s3-bucket.id
  
  depends_on = [
    aws_s3_bucket_public_access_block.public_access_block
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.TF-s3-bucket.arn}/*"
      }
    ]
  })
}

#  Enable Website Configuration
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.TF-s3-bucket.id
  index_document {
    suffix = "index.html"
  }
}

#  Upload File 
resource "aws_s3_object" "upload_index" {
  bucket       = aws_s3_bucket.TF-s3-bucket.id
  key          = "index.html"
  source       = "./index.html" 
  content_type = "text/html"
  acl          = "public-read"
}

#  OUTPUTS
output "website_url" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}