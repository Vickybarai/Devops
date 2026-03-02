# resource "aws_s3_bucket" "remote_s3" {
#     bucket = "${var.env}-${var.bucket}-remote" 
    
#     tags = {
#         Name = "${var.env}-${var.bucket}-remote"
#         environment = var.env
#     }
  
# }