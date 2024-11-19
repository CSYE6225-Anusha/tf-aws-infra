resource "aws_sns_topic" "user_verification" {
  name = "user-verification-topic"
  
  tags = {
    Name = "user-verification-topic"
  }
}

# Security Group for Lambda function to connect to RDS
# resource "aws_security_group" "lambda_security_group" {
#   name        = "lambda_security_group"
#   description = "Security group for Lambda function to access RDS"
#   vpc_id      = aws_vpc.main.id

#   # Allow Lambda to connect to the RDS instance
#   ingress {
#     from_port       = var.db_port
#     to_port         = var.db_port
#     protocol        = var.protocol
#     security_groups = [aws_security_group.database_security_group.id]
#   }

#   # Allow outbound traffic for the Lambda function
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"  # All protocols
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "lambda_security_group"
#   }
# }

# # Security group for RDS database
# resource "aws_security_group" "database_security_group" {
#   name        = "database_security_group"
#   description = "Security group for RDS instance"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "database_security_group"
#   }
# }

# Security group for Lambda function
# resource "aws_security_group" "lambda_security_group" {
#   name        = "lambda_security_group"
#   description = "Security group for Lambda function"
#   vpc_id      = aws_vpc.main.id

#   egress {
#     from_port   = var.outbound_port
#     to_port     = var.outbound_port
#     protocol    = var.outbound_protocol
#     cidr_blocks = [var.destination_cidr_zero]
#   }

#   tags = {
#     Name = "lambda_security_group"
#   }
# }

# # Allow inbound traffic to RDS from Application and Lambda Security Groups
# resource "aws_security_group_rule" "allow_application_to_rds" {
#   type              = "ingress"
#   from_port         = var.db_port
#   to_port           = var.db_port
#   protocol          = "tcp"
#   security_group_id = aws_security_group.database_security_group.id
#   source_security_group_id = aws_security_group.application_security_group.id
# }

# resource "aws_security_group_rule" "allow_lambda_to_rds" {
#   type              = "ingress"
#   from_port         = var.db_port
#   to_port           = var.db_port
#   protocol          = "tcp"
#   security_group_id = aws_security_group.database_security_group.id
#   source_security_group_id = aws_security_group.lambda_security_group.id
# }

# Additional rules for other traffic, if needed
# You can add any egress rules or other configuration within each security group separately



resource "aws_lambda_function" "user_verification_lambda" {
  filename         = "C:\\Users\\anush\\OneDrive\\Desktop\\Cloud\\serverless\\user.zip"  # Relative path to the local file
  function_name    = "user_verification_lambda"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"

  environment {
    variables = {
      # DB_NAME             = aws_db_instance.db_instance.db_name
      # DB_USER         = aws_db_instance.db_instance.username
      # DB_PASSWORD         = aws_db_instance.db_instance.password
      # host                = aws_db_instance.db_instance.address
      # dialect             = var.dialect
      MAILGUN_API_KEY     = var.mailgun_api_key
      DOMAIN              = "${var.profile}.${var.domain}"
    }
  }

  timeout = 60

  source_code_hash = filebase64sha256("C:\\Users\\anush\\OneDrive\\Desktop\\Cloud\\serverless\\user.zip")  # Ensures function updates if zip changes
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "snsLambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "snsLambdaPolicy"
  description = "Allows Lambda to access SNS, RDS, and send emails through Mailgun and write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["sns:Publish"],
        Effect = "Allow",
        Resource = aws_sns_topic.user_verification.arn
      },
      {
        Action = ["rds:Connect", "rds:DescribeDBInstances"],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = ["ses:SendEmail"], # For SES email support if needed alongside Mailgun
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy" "ec2_sns_publish_policy" {
  name = "ec2SNSPublishPolicy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sns:Publish",
        Effect = "Allow",
        Resource = aws_sns_topic.user_verification.arn
      }
    ]
  })
}


resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.user_verification.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.user_verification_lambda.arn
}

resource "aws_lambda_permission" "allow_sns_invocation" {
  statement_id  = "AllowSNSInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_verification_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.user_verification.arn
}
