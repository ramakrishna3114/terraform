resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block_subnet-1
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block_subnet-2
  availability_zone = "us-east-1b"
}
resource "aws_security_group" "lambda" {
  name   = "lambda-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "rds" {
  name   = "rds-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "endpoint" {
  name   = "endpoint-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "lambda_to_rds" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.lambda.id

  ip_protocol = "tcp"
  from_port   = 3306
  to_port     = 3306
}

resource "aws_vpc_security_group_ingress_rule" "lambda_to_endpoint" {
  security_group_id            = aws_security_group.endpoint.id
  referenced_security_group_id = aws_security_group.lambda.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}
resource "aws_secretsmanager_secret" "db" {
  name = "rds-secret"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = var.username
    password = var.password
  })
}
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]

  private_dns_enabled = true
}
resource "aws_db_subnet_group" "rds" {
  name = "rds-subnet-group"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]
}
resource "aws_db_instance" "mysql" {
  identifier = "mysql-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  username = jsondecode(
    aws_secretsmanager_secret_version.db.secret_string
  ).username

  password = jsondecode(
    aws_secretsmanager_secret_version.db.secret_string
  ).password

  db_subnet_group_name = aws_db_subnet_group.rds.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false
  skip_final_snapshot = true
}
resource "aws_iam_role" "lambda" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"

      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "secret" {
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "secretsmanager:GetSecretValue"
      ]

      Resource = aws_secretsmanager_secret.db.arn
    }]
  })
}
resource "aws_lambda_function" "app" {
  function_name = "db-lambda"

  s3_bucket = "sweety-sweety-bucket"
  s3_key    = "lambda.zip"

  role    = aws_iam_role.lambda.arn
  runtime = "python3.12"
  handler = "lambda_function.lambda_handler"

  vpc_config {
    subnet_ids = [
      aws_subnet.private1.id,
      aws_subnet.private2.id
    ]

    security_group_ids = [
      aws_security_group.lambda.id
    ]
  }
}