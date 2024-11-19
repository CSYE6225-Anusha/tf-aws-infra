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

variable "ssh_port" {
  type        = number
  description = "SSH Port Number"
  default     = 22
}

variable "http_port" {
  type        = number
  description = "HTTP Port Number"
  default     = 80
}

variable "https_port" {
  type        = number
  description = "HTTPS Port Number"
  default     = 443
}

variable "protocol" {
  type        = string
  description = "Protocol Type"
  default     = "tcp"
}

variable "outbound_port" {
  type        = number
  description = "Outbound Port"
  default     = 0
}

variable "outbound_protocol" {
  type        = string
  description = "Outbound Protocol"
  default     = "-1"
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

variable "disable_api_termination" {
  type = bool
}

variable "key-pair" {
  type    = string
  default = "my-key-pair"
}

# Database Name
variable "db_name" {
  description = "The name of the database."
  type        = string
}

# Database Engine
variable "engine" {
  description = "The database engine to use (e.g., postgres)."
  type        = string
}

# Engine Version
variable "engine_version" {
  description = "The version of the database engine."
  type        = string
}

# Instance Class
variable "instance_class" {
  description = "The instance type to use for the database (e.g., db.t3.micro)."
  type        = string
}

# Multi-AZ Deployment
variable "multi_az" {
  description = "Whether to deploy the database in multiple availability zones."
  type        = bool
}

# Database Identifier
variable "identifier" {
  description = "The identifier for the database instance."
  type        = string
}

# Database Username
variable "username" {
  description = "The master username for the database."
  type        = string
}

# Database Password
variable "password" {
  description = "The password for the master username of the database."
  type        = string
  sensitive   = true
}

# Publicly Accessible
variable "publicly_accessible" {
  description = "Whether the database should be publicly accessible."
  type        = bool
}

variable "dialect" {
  description = "Application Dialect"
  type        = string
  default     = "postgres"
}

variable "allocated_storage" {
  description = "Allocated Storage"
  type        = number
}

variable "skip_final_snapshot" {
  description = "Skip Final Snapshot"
  type        = bool
}

variable "db_port" {
  description = "Database Port"
  type        = number
}

variable "db_family" {
  description = "Database Family"
  type        = string
}

variable "domain" {
  description = "Top Level Domain"
  type        = string
}

variable "ami_owner" {
  description = "AMI Owner"
  type        = list(string)
}

variable "days" {
  type        = number
  description = "Number of days before transitioning to STANDARD_IA"
}

variable "sse_algorithm" {
  type        = string
  description = "Server-side encryption algorithm"
}

variable "storage_class" {
  type        = string
  description = "The storage class to transition to after the specified days"
}

# Auto-scaling Configuration
variable "min_size" {
  type        = number
  description = "Minimum number of instances in the auto-scaling group"
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in the auto-scaling group"
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity of instances in the auto-scaling group"
}

variable "health_check_type" {
  type        = string
  description = "Health check type for the auto-scaling group"
}

variable "health_check_grace_period" {
  type        = number
  description = "Health check grace period for the auto-scaling group, in seconds"
}

variable "default_cooldown" {
  type        = number
  description = "Cooldown period before another scaling activity is allowed"
}

variable "comparison_operator_greater" {
  type        = string
  description = "The operator used to compare the metric with the threshold (greater)"
}

variable "comparison_operator_less" {
  type        = string
  description = "The operator used to compare the metric with the threshold (lesser)"
}


variable "evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold"
}

variable "metric_name" {
  type        = string
  description = "The name of the metric to monitor"
}

variable "namespace" {
  type        = string
  description = "The namespace of the metric to monitor"
}

variable "period" {
  type        = number
  description = "The period, in seconds, over which the specified statistic is applied"
}

variable "statistic" {
  type        = string
  description = "The statistic to apply to the alarm's associated metric"
}

variable "threshold_greater" {
  type        = number
  description = "The threshold against which the specified greater statistic is compared"
}

variable "threshold_lesser" {
  type        = number
  description = "The threshold against which the specified lesser statistic is compared"
}

variable "mailgun_api_key" {
  type        = string
  description = "Mail Gun API Key"
}

variable "destination_cidr_ipv6" {
  type        = string
  description = "IPv6 CIDR block for outbound traffic"
  default     = "::/0" # Default IPv6 block for all traffic
}

variable "file_path" {
  type        = string
  description = "Lambda file path"
}

variable "handler" {
  type        = string
  description = "Lambda handler"
}

variable "function_name" {
  type        = string
  description = "Function Name"
}

variable "timeout" {
  type        = number
  description = "Timeout lambda"
  default     = 60
}