# Terraform AWS Infrastructure

## Overview 🤖

This Terraform configuration provisions a scalable AWS infrastructure for a web application. Key components include EC2 instances managed by an auto-scaling group, a load balancer, Amazon RDS for database storage, and security groups to control access. DNS is configured via Route 53, enabling easy access to the application through a custom domain.

## Features 🚀

### Security Groups 🔒
- **Application Security Group**: 
  - Configures access restrictions for EC2 instances in the auto-scaling group.
  
- **Load Balancer Security Group**:
  - Manages ingress rules to allow HTTPS traffic on port 443 from any IP, ensuring secure traffic routing to the web application.

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
  - Sets up a Type A record in Route 53, pointing the domain to the load balancer. This makes the web application accessible at `https://(dev|demo).your-domain-name.tld`.

## AWS Key Management Service (KMS) 🔐

### Encryption Keys:
- Separate KMS keys created for:
  - **EC2 Instances**
  - **RDS Database**
  - **S3 Buckets**
  - **Secrets Manager** (for storing credentials and database passwords)
- Keys rotate every 90 days for enhanced security.
- Resources leverage these keys for encryption.

---

## Secrets Management 🔏

### Database Password:
- Auto-generated password stored in **AWS Secrets Manager**, encrypted with a custom KMS key.
- Retrieved during instance initialization via a **user-data script**.

### Email Service Credentials:
- Lambda function fetches credentials securely from **AWS Secrets Manager** using KMS encryption.

---

## SSL Certificates ✅

### Development Environment:
- **AWS Certificate Manager** provides SSL certificates.

### Demo Environment:
- Import third-party SSL certificates (e.g., from Namecheap) into **AWS Certificate Manager**. 
- Follow these steps to import certificates:

```bash
aws acm import-certificate --certificate fileb://demo_anushakadali_me.crt
--certificate-chain fileb://demo_anushakadali_me.ca-bundle --private-key fileb://private.key
```

### SNS and Lambda Integration 📩

This setup enables automated email verification for new user accounts using Amazon SNS and AWS Lambda:

1. **SNS Topic**: Publishes user verification events.
2. **Lambda Function**: Sends verification emails securely using Mailgun. Automatically retrieves email service credentials from Secrets Manager.
3. **IAM Role**: Grants permissions for SNS, RDS, and CloudWatch.
4. **Trigger**: SNS automatically invokes the Lambda function when a new message is published.

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
