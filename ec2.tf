resource "aws_security_group" "application_security_group" {
  name        = "application_security_group"
  description = "Security group for web application"
  vpc_id      = aws_vpc.main.id

  # Ingress rule to allow SSH (Port 22)
  # ingress {
  #   description = "Allow SSH from anywhere"
  #   from_port   = var.ssh_port
  #   to_port     = var.ssh_port
  #   protocol    = var.protocol
  #   cidr_blocks = [var.destination_cidr_zero]
  # }

  # Ingress rule to allow traffic on my application port 
  ingress {
    description     = "Allow application traffic from load balancer"
    from_port       = var.port
    to_port         = var.port
    protocol        = var.protocol
    security_groups = [aws_security_group.lb_sg.id]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port        = var.outbound_port
    to_port          = var.outbound_port
    protocol         = var.outbound_protocol
    cidr_blocks      = [var.destination_cidr_zero]
    ipv6_cidr_blocks = [var.destination_cidr_ipv6]
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
  owners      = var.ami_owner
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
  password               = random_password.db_password.result
  allocated_storage      = var.allocated_storage
  storage_encrypted      = var.storage_encrypted
  kms_key_id             = aws_kms_key.rds_kms_key.arn
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
# resource "aws_instance" "app_instance" {
#   ami                    = data.aws_ami.my_ami.id
#   instance_type          = var.instance_type
#   key_name               = var.key-pair
#   vpc_security_group_ids = [aws_security_group.application_security_group.id]
#   subnet_id              = aws_subnet.subnets_public[0].id

#   # Disable accidental termination protection
#   disable_api_termination = var.disable_api_termination

#   # Attach IAM role
#   iam_instance_profile = aws_iam_instance_profile.instance_profile.name

#   # EBS root volume configuration
#   root_block_device {
#     volume_size           = var.volume_size
#     volume_type           = var.volume_type
#     delete_on_termination = var.delete_on_termination
#   }

#   user_data = <<-EOF
#     #!/bin/bash
#     cd /opt/csye6225/app/webapp
#     touch .env
#     echo "PORT=${var.port}" >> .env
#     echo "DB_NAME=${aws_db_instance.db_instance.db_name}" >> .env
#     echo "DB_USERNAME=${aws_db_instance.db_instance.username}" >> .env
#     echo "DB_PASSWORD=${aws_db_instance.db_instance.password}" >> .env
#     echo "host=${aws_db_instance.db_instance.address}" >> .env
#     echo "dialect=${var.dialect}" >> .env
#     echo "S3_BUCKET_NAME=${aws_s3_bucket.my_bucket.bucket}" >> .env
#     sudo chown csye6225:csye6225 .env
#     sudo chmod 755 .env
#     sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/csye6225/app/webapp/cloudwatch-config.json -s
#     sudo service amazon-cloudwatch-agent restart
#     sudo systemctl start webapp.service
#     sudo systemctl enable webapp.service

#   EOF

#   # Tag the instance
#   tags = {
#     Name = "my_ec2_instance"
#   }
# }

resource "aws_security_group" "lb_sg" {
  name        = "load_balancer"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.main.id

  # ingress {
  #   description = "Allow HTTP traffic from anywhere"
  #   from_port   = var.http_port
  #   to_port     = var.http_port
  #   protocol    = var.protocol
  #   cidr_blocks = [var.destination_cidr_zero]
  # }

  ingress {
    description = "Allow HTTPS traffic from anywhere"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = var.protocol
    cidr_blocks = [var.destination_cidr_zero]
  }

  egress {
    from_port        = var.outbound_port
    to_port          = var.outbound_port
    protocol         = var.outbound_protocol
    cidr_blocks      = [var.destination_cidr_zero]
    ipv6_cidr_blocks = [var.destination_cidr_ipv6]
  }


  tags = {
    Name = "load_balancer_security_group"
  }
}

# Launch Template Auto Scaling
resource "aws_launch_template" "app_lt" {
  name          = "csye6225_asg"
  image_id      = data.aws_ami.my_ami.id
  instance_type = var.instance_type
  key_name      = var.key-pair

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.application_security_group.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = var.delete_on_termination
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_kms.arn
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  disable_api_termination = false

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo snap install aws-cli --classic
    cd /opt/csye6225/app/webapp
    DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id db-password --query 'SecretString' --output text)
    echo "DB_PASSWORD is: $DB_PASSWORD"
    echo "DB_PASSWORD is: $DB_PASSWORD" >> /var/log/cloud-init-output.log
    touch .env
    echo "PORT=${var.port}" >> .env
    echo "DB_NAME=${aws_db_instance.db_instance.db_name}" >> .env
    echo "DB_USERNAME=${aws_db_instance.db_instance.username}" >> .env
    echo "DB_PASSWORD=$DB_PASSWORD" >> .env
    echo "host=${aws_db_instance.db_instance.address}" >> .env
    echo "dialect=${var.dialect}" >> .env
    echo "S3_BUCKET_NAME=${aws_s3_bucket.my_bucket.bucket}" >> .env
    echo "SNS_TOPIC_ARN=${aws_sns_topic.user_verification.arn}" >> .env
    echo "AWS_REGION=${var.region}" >> .env
    sudo chown csye6225:csye6225 .env
    sudo chmod 755 .env
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/csye6225/app/webapp/cloudwatch-config.json -s
    sudo service amazon-cloudwatch-agent restart
    sudo systemctl start webapp.service
    sudo systemctl enable webapp.service
  EOF
  )
}

//Auto scaling group
resource "aws_autoscaling_group" "webapp_asg" {
  name                = "webapp-asg"
  vpc_zone_identifier = [for s in aws_subnet.subnets_public : s.id]
  target_group_arns   = [aws_lb_target_group.app_target_group.arn]
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.default_cooldown
  tag {
    key                 = "Name"
    value               = "WebApp EC2 Instance"
    propagate_at_launch = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_high"
  comparison_operator = var.comparison_operator_greater
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_greater

  alarm_description = "Alarm when CPU exceeds"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

# CloudWatch Alarm for Scaling Down (CPU < 3%)
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu_low"
  comparison_operator = var.comparison_operator_less
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_lesser

  alarm_description = "Alarm when CPU is below 3% to scale down"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  # Links the alarm to the scale-down policy
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}


# Auto Scaling Policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

# Application load balancer
resource "aws_lb" "app-lb" {
  name               = "${var.profile}-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for s in aws_subnet.subnets_public : s.id]
  security_groups    = [aws_security_group.lb_sg.id]

  tags = {
    Name = "${var.profile}-app-load-balancer"
  }
}

# Target Group
resource "aws_lb_target_group" "app_target_group" {
  name     = "app-target-group"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/healthz"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "app-target-group"
  }
}

data "aws_acm_certificate" "ssl_certificate" {
  domain   = "${var.profile}.${var.domain}"
  statuses = ["ISSUED"]
}


# Load Balancer Listener
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.ssl_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}