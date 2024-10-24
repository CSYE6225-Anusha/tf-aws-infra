# Terraform AWS Infrastructure

## What it does 🤖
This Terraform configuration sets up an EC2 instance with a security group for web applications, utilizing a custom Amazon Machine Image (AMI) built in the web application's GitHub Actions workflow. It provisions an Amazon RDS (Relational Database Service) instance with a dedicated security group, allowing secure communication with the application and enabling traffic on the specified database port (default: PostgreSQL 5432). The RDS configuration also includes a custom parameter group. All infrastructure is managed within a custom VPC, ensuring secure access and proper resource management.

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

- **Amazon RDS Configuration:**:
  - Provisions an Amazon RDS instance with a dedicated security group for secure communication.
  - Configures ingress rules to allow traffic on the specified database port from the application security group.
  - Utilizes a custom parameter group for managing database settings.

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
Ensure to set the following variables either in a `terraform.tfvars` file or pass them via the command line:

- `profile`: AWS CLI profile to use for authentication.
- `region`: AWS region to deploy resources.
- `vpc_cidr_block`: CIDR block for the custom VPC.
- `total_private_subnets`: Number of private subnets to create.
- `total_public_subnets`: Number of public subnets to create.
- `subnet_size`: Size of the subnets.
- `destination_cidr_zero`: CIDR block for allowing traffic.
- `port`: Application-specific port.
- `volume_size`: Size of the root volume for the EC2 instance.
- `volume_type`: Type of the root volume.
- `delete_on_termination`: Flag to delete EBS volumes on instance termination.
- `disable_api_termination`: Flag to disable accidental termination protection.
- `key-pair`: Name of the key pair for SSH access.
- `db_name`: Name of the database.
- `engine`: Database engine type.
- `engine_version`: Version of the database engine.
- `instance_class`: RDS instance class.
- `multi_az`: Flag to enable multi-AZ deployment.
- `identifier`: Identifier for the RDS instance.
- `username`: Database username.
- `password`: Database password.
- `publicly_accessible`: Flag to make the database publicly accessible.
- `allocated_storage`: Allocated storage for the RDS instance.
- `skip_final_snapshot`: Flag to skip the final snapshot on deletion.
- `db_port`: Database port.
- `db_family`: Family for the RDS parameter group.


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
