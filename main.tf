# Step 1 : Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Main VPC created by ${var.profile} profile"
  }
}




