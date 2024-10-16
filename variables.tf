variable "profile" {
  type        = string
  description = "AWS profile"
}

variable "region" {
  type        = string
  description = "AWS infrastructure region"
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
}

variable "destination_cidr_zero" {
  type        = string
  description = "Destination CIDR"
}

variable "port" {
  type        = number
  description = "My application port"
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
  default     = "t2.micro"
}