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

variable "ssh_port"{
  type = number
  description = "SSH Port Number"
  default = 22
}

variable "http_port"{
  type = number
  description = "HTTP Port Number"
  default = 80
}

variable "https_port"{
  type = number
  description = "HTTPS Port Number"
  default = 443
}

variable "protocol" {
  type = string
  description = "Protocol Type"
  default = "tcp"
}

variable "outbound_port" {
  type = number
  description = "Outbound Port"
  default = 0
}

variable "outbound_protocol" {
  type = string
  description = "Outbound Protocol"
  default = "-1"
}

variable "volume_size" {
  type = number
}

variable "volume_type" {
  type = string
}

variable "delete_on_termination" {
  type = bool
}

variable "disable_api_termination"{
  type = bool
}

