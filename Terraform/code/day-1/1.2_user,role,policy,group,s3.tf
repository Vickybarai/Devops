provider "aws" {
    region = "ca-central-1"
}

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
        Action   = ["s3:ListBucket"],
        Effect   = "Allow",
        Resource = "readonly-bucket"
      }
    ]
  })
}


resource "aws_iam_group" "TF-group-child1" {
    name = "TF-group"
    }

resource "aws_iam_group_membership" "TF-group-member" {
    name = "TF-group-member"
    users = [aws_iam_user.TF-user-child1.name]
    }


resource "aws_iam_group_policy_attachment" "s3-full-access-policy" {
    group = aws_iam_group.s3-full-access-policy
    policy_arn = arn.aws:iam::aws:policy/AmazonS3FullAccess
    }    

resource "s3_bucket" "TF-s3-bucket" {
  bucket = "my-tf-s3-bucket-1234567890"
}

resource "aws_s3_bucket_public_access_block" "TF-s3-bucket-public-access-block" {
  bucket = aws_s3_bucket.TF-s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}



