resource "aws_security_group" "application_security_group" {
  name        = "application_security_group"
  description = "Security group for web application"
  vpc_id      = aws_vpc.main.id

  # Ingress rule to allow SSH (Port 22)
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = [var.destination_cidr_zero]
  }

  # Ingress rule to allow HTTP (Port 80)
  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.protocol
    cidr_blocks = [var.destination_cidr_zero]
  }

  # Ingress rule to allow HTTPS (Port 443)
  ingress {
    description = "Allow HTTPS traffic from anywhere"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = var.protocol
    cidr_blocks = [var.destination_cidr_zero]
  }

  # Ingress rule to allow traffic on my application port 
  ingress {
    description = "Allow application traffic from anywhere"
    from_port   = var.port
    to_port     = var.port
    protocol    = var.protocol
    cidr_blocks = [var.destination_cidr_zero]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = var.outbound_protocol
    cidr_blocks = [var.destination_cidr_zero]
  }

  tags = {
    Name = "application_security_group"
  }
}

data "aws_ami" "my_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["csye6225*"]
  }
}

# Create EC2 instance
resource "aws_instance" "app_instance" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = var.instance_type
  key_name               = var.key-pair
  vpc_security_group_ids = [aws_security_group.application_security_group.id]
  subnet_id              = aws_subnet.subnets_public[0].id

  # Disable accidental termination protection
  disable_api_termination = var.disable_api_termination

  # EBS root volume configuration
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
  }

  # Tag the instance
  tags = {
    Name = "my_ec2_instance"
  }
}
