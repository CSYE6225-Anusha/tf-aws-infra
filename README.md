# Terraform AWS Infrastructure

## What it does 🤖
This Terraform configuration sets up public and private subnets within a VPC, assigns route tables, and manages routing between subnets. It configures both public and private subnets in the available zones, ensuring proper internet access for public subnets via an Internet Gateway.

## Features 🚀

- **Subnet Creation**: 
  - Automatically creates public and private subnets across all available zones.
  - Dynamically adjusts the number of subnets based on availability zone count.
  
- **Public Subnet Configuration**:hgi
  - Associates public subnets with an Internet Gateway, enabling external internet access.
  - Applies a public route table that routes traffic to the internet.

- **Private Subnet Configuration**:
  - Private subnets are isolated from direct internet access, enhancing security.
  - Applies a private route table for internal communication.

- **Routing**:
  - Creates and associates route tables for public and private subnets.
  - Configures a route for public subnets to access the internet via the Internet Gateway.

## How to Use ⚙

- [x] Ensure you have Terraform installed and AWS credentials configured.

- [x] Clone the repository
  - `git clone git@github.com:CSYE6225-Anusha/tf-aws-infra.git`

- [x] Modify the variables as needed
  - `total_public_subnets`: Number of public subnets to create.
  - `total_private_subnets`: Number of private subnets to create.
  - `vpc_cidr_block`: CIDR block for the VPC.
  - `subnet_size`: Size of the subnets.
  - `destination_cidr_zero`: CIDR for internet access (typically `0.0.0.0/0`).

- [x] Initialize Terraform
  - `terraform init`
  
- [x] Create an Execution Plan
  - `terraform plan`

- [x] Apply the configuration
  - `terraform apply`
  
- [x] Destroy Terraform
  - `terraform destroy`

## Variables
Ensure to set the following variables either in a `terraform.tfvars` file or pass them via command line:

- `vpc_cidr_block`: CIDR block of your VPC.
- `total_public_subnets`: Number of public subnets.
- `total_private_subnets`: Number of private subnets.
- `subnet_size`: CIDR size for each subnet.
- `destination_cidr_zero`: CIDR for public internet routing (usually `0.0.0.0/0`).

## Support the Project with a ⭐ 
```terraform
if (youEnjoyed) {
    starThisRepository();
}
