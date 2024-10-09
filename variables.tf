variable "profile" {
  type        = string
  description = "AWS profile"
}

variable "region" {
  type        = string
  description = "AWS infrastructure region"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for VPC"
}

variable "total_public_subnets" {
  type        = number
  description = "Total number of public subnets"
}

variable "total_private_subnets" {
  type        = number
  description = "Total number of private subnets"
}

variable "subnet_size" {
  type        = number
  description = "Subnet size"
  default     = 8
}