# # Create an S3 bucket for storing the Terraform state file
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "ams-s3-bucket-kimit"
  
#   # Prevent accidental deletion of the bucket
#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     Name = "Terraform State Storage"
#   }
# }

# # Create a DynamoDB table for state locking
# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-lock-file"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#   tags = {
#     Name = "Terraform Lock Table"
#   }
#   lifecycle {
#     prevent_destroy = true
#   }
# }
