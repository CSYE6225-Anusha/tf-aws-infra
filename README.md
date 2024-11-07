# Terraform AWS Infrastructure

## Overview 🤖

This Terraform configuration provisions a scalable AWS infrastructure for a web application. Key components include EC2 instances managed by an auto-scaling group, a load balancer, Amazon RDS for database storage, and security groups to control access. DNS is configured via Route 53, enabling easy access to the application through a custom domain.

## Features 🚀

### Security Groups 🔒
- **Application Security Group**: 
  - Configures access restrictions for EC2 instances in the auto-scaling group. Direct internet access is blocked; only port 22 (SSH) traffic is allowed from the load balancer security group.
  
- **Load Balancer Security Group**:
  - Manages ingress rules to allow HTTP and HTTPS traffic on ports 80 and 443 from any IP, ensuring secure traffic routing to the web application.

### Auto-Scaling and Load Balancing ⚖️
- **Auto-Scaling Group**:
  - Launches and scales EC2 instances based on demand, with a minimum of 3 instances and a maximum of 5 or more based on load. Instances are automatically started and configured, ensuring seamless application availability.
  - **Load Testing**: You can simulate load changes to trigger auto-scaling events, demonstrating the addition or termination of instances based on application demand.

- **Application Load Balancer**:
  - Distributes incoming traffic to EC2 instances in the auto-scaling group. Listens for HTTP traffic on port 80 and forwards it to the application instances.

### Amazon RDS Configuration 🗄️
- **Database Instance**:
  - Provisions an Amazon RDS instance within a dedicated security group to securely manage the database for the web application.
  - Configures ingress rules to allow traffic on the database port from the application security group only.

### CloudWatch Monitoring 📊
- **Unified CloudWatch Agent Setup**:
  - Configures CloudWatch to monitor logs and metrics for EC2 instances. The CloudWatch Agent is installed in the AMI and starts automatically upon instance launch to monitor log and metric data.

### DNS Configuration 🌐
- **Route 53**:
  - Sets up a Type A record in Route 53, pointing the domain to the load balancer. This makes the web application accessible at `http://(dev|demo).your-domain-name.tld`.

## How to Use ⚙

1. **Ensure Terraform installed and AWS credentials configured**:
   - [x] Install Terraform and configure AWS credentials with sufficient permissions.

2. **Clone the repository**:
   - `git clone git@github.com:CSYE6225-Anusha/tf-aws-infra.git`

3. **Initialize Terraform**:
   - `terraform init`

4. **Create an Execution Plan**:
   - `terraform plan`

5. **Apply the configuration**:
   - `terraform apply`

6. **Destroy the Infrastructure**:
   - `terraform destroy`

## IAM Role and CloudWatch Agent Setup 🛠

- **IAM Role for EC2**: 
  - A custom IAM role is attached to the EC2 instance, allowing it to use the CloudWatch Agent to publish logs and metrics.
  - Policies are included for S3 access (for application needs) and CloudWatch (for logging and monitoring).

- **User Data Script**:
  - The user data script sets up and restarts the CloudWatch Agent on EC2 instance launch, ensuring it begins monitoring as soon as the instance is live.

## Variables

1. Create a `terraform.tfvars` file in the root directory of the project.
2. Include all required variables with the appropriate values, which are given in variables.tf


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
