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

// security group for rds instance
resource "aws_security_group" "database_security_group" {
  name        = "database_security_group"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  # Ingress rule to allow Postgres (Port 5432)
  ingress {
    description     = "Allow PostgreSQL traffic from application security group"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = var.protocol
    security_groups = [aws_security_group.application_security_group.id]
  }

  tags = {
    Name = "database_security_group"
  }
}

# RDS Parameter Group for the database
resource "aws_db_parameter_group" "private_db_parameter_group" {
  name        = "custom-db-parameter-group"
  family      = var.db_family
  description = "Custom parameter group for the RDS instance"
  parameter {
    name  = "log_min_duration_statement"
    value = "1000" # Log queries that take longer than 1 second
  }

  tags = {
    Name = "custom-db-parameter-group"
  }
}

resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = "private_db_subnet_group"
  subnet_ids = [for i in aws_subnet.subnets_private : i.id]
}

data "aws_ami" "my_ami" {
  most_recent = true
  owners = var.ami_owner
  filter {
    name   = "name"
    values = ["csye6225*"]
  }
}

// Database Instance
resource "aws_db_instance" "db_instance" {
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  multi_az               = var.multi_az
  identifier             = var.identifier
  username               = var.username
  password               = var.password
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.private_db_subnet_group.name
  publicly_accessible    = var.publicly_accessible
  db_name                = var.db_name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  skip_final_snapshot    = var.skip_final_snapshot
  parameter_group_name   = aws_db_parameter_group.private_db_parameter_group.name
  tags = {
    Name = "My Database Instance"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
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

  # Attach IAM role
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  # EBS root volume configuration
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
  }

  user_data = <<-EOF
    #!/bin/bash
    cd /opt/csye6225/app/webapp
    touch .env
    echo "PORT=${var.port}" >> .env
    echo "DB_NAME=${aws_db_instance.db_instance.db_name}" >> .env
    echo "DB_USERNAME=${aws_db_instance.db_instance.username}" >> .env
    echo "DB_PASSWORD=${aws_db_instance.db_instance.password}" >> .env
    echo "host=${aws_db_instance.db_instance.address}" >> .env
    echo "dialect=${var.dialect}" >> .env
    echo "S3_BUCKET_NAME=${aws_s3_bucket.my_bucket.bucket}" >> .env
    sudo chown csye6225:csye6225 .env
    sudo chmod 755 .env
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/csye6225/app/webapp/cloudwatch-config.json -s
    sudo service amazon-cloudwatch-agent restart
    sudo systemctl start webapp.service
    sudo systemctl enable webapp.service
    
  EOF

  # Tag the instance
  tags = {
    Name = "my_ec2_instance"
  }
}
