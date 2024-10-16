resource "aws_security_group" "application_security_group" {
  name        = "application_security_group"
  description = "Security group for web application"
  vpc_id      = aws_vpc.main.id

  # Ingress rule to allow SSH (Port 22)
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule to allow HTTP (Port 80)
  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule to allow HTTPS (Port 443)
  ingress {
    description = "Allow HTTPS traffic from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule to allow traffic on my application port 
  ingress {
    description = "Allow application traffic from anywhere"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  key_name               = "my-key-pair"
  vpc_security_group_ids = [aws_security_group.application_security_group.id]
  subnet_id              = aws_subnet.subnets_public[0].id

  # Disable accidental termination protection
  disable_api_termination = false

  # EBS root volume configuration
  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  # Tag the instance
  tags = {
    Name = "my_ec2_instance"
  }
}
