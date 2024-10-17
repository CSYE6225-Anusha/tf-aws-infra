# Terraform AWS Infrastructure

## What it does 🤖
This Terraform configuration sets up an EC2 instance with a security group for web applications, including ingress rules for necessary ports. It utilizes the custom Amazon Machine Image (AMI) built in the web application repository's GitHub Actions workflow, ensuring the instance is pre-configured with all the necessary application components. The infrastructure is managed within our custom VPC, providing secure access to the application and proper resource management.

## Features 🚀

- **Application Security Group**:
  - Creates a security group for EC2 instances hosting web applications.
  - Adds ingress rules to allow TCP traffic on ports 22 (SSH), 80 (HTTP), 443 (HTTPS), and the application-specific port from anywhere in the world.

- **EC2 Instance Configuration**:
  - Launches an EC2 instance with a specified Amazon Machine Image (AMI) and instance type.
  - Ensures EBS volumes are terminated when the EC2 instance is terminated.
  - Protects against accidental termination if configured.

- **Dynamic Resource Management**:
  - Automatically retrieves the latest custom AMI for the application.
  - Applies the appropriate security group to the EC2 instance.

## How to Use ⚙

- [x] Ensure you have Terraform installed and AWS credentials configured.

- [x] Clone the repository
  - `git clone git@github.com:CSYE6225-Anusha/tf-aws-infra.git`

- [x] Modify the variables as needed
  - `instance_type`: Specify the instance type for the EC2 instance.
  - `key-pair`: Specify the key pair name for SSH access.
  - `volume_size`: Set the root volume size (default is 25).
  - `volume_type`: Specify the root volume type (default is GP2).

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

- `instance_type`: Type of the EC2 instance.
- `key-pair`: Name of the key pair for SSH access.
- `volume_size`: Size of the root volume for the EC2 instance.
- `volume_type`: Type of the root volume (e.g., `gp2`).
- `disable_api_termination`: Flag to disable accidental termination protection.

## Contributing ✨

1. **Fork the repository** and create a new branch for your feature or bug fix.
2. **Commit your changes** and push them to your branch.
3. **Create a pull request** to propose your changes.
4. **Run the CI checks** to ensure all workflows pass before merging.

## Support the Project with a ⭐ 
```terraform
if (youEnjoyed) {
    starThisRepository();
}
