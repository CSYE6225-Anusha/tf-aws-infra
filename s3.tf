# resource "random_uuid" "bucket_id" {}

# resource "aws_s3_bucket" "my_bucket" {
#   bucket = random_uuid.bucket_id.result
#   force_destroy = true
#    tags = {
#     Name        = "My S3 Bucket"
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
#   bucket = aws_s3_bucket.my_bucket.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]

#   bucket = aws_s3_bucket.my_bucket.id
#   acl    = "private"
# }

# resource "aws_kms_key" "mykey" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
#   bucket = aws_s3_bucket.my_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.mykey.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

# resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
#   bucket = aws_s3_bucket.my_bucket.id
#    rule {
#     id = "lifecycle"
#     status = "Enabled"
#     transition {
#       days          = 30
#       storage_class = "STANDARD_IA"
#     }
#   }
# }

# resource "aws_iam_policy" "s3_access_policy" {
#   name        = "S3AccessPolicy"
#   description = "Policy to allow getting, updating, and deleting S3 objects"
  
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:DeleteObject",
#         ],
#         Resource = [
#           "${aws_s3_bucket.my_bucket.arn}",
#           "${aws_s3_bucket.my_bucket.arn}/*"   
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
#   policy_arn = aws_iam_policy.s3_access_policy.arn
#   role       = aws_iam_role.ec2_role.name
# }