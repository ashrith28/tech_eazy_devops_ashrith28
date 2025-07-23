provider "aws" {
  region = var.region
}

resource "aws_iam_role" "s3_read_role" {
  name = "S3ReadOnlyRole-${var.stage}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_read_policy" {
  name = "S3ReadPolicy-${var.stage}"
  role = aws_iam_role.s3_read_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:ListBucket", "s3:GetObject"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role" "s3_write_role" {
  name = "S3WriteOnlyRole-${var.stage}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_write_policy" {
  name = "S3WritePolicy-${var.stage}"
  role = aws_iam_role.s3_write_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:CreateBucket"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2S3WriteProfile-${var.stage}"
  role = aws_iam_role.s3_write_role.name
}

resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name  = "DevOpsLogs"
    Stage = var.stage
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "log-expiry-rule"
    status = "Enabled"

    expiration {
      days = 7
    }

    filter {}
  }
}


resource "aws_security_group" "web_sg" {
  name        = "EC2WebSecurityGroup-${var.stage}"
  description = "Allow HTTP traffic on port 80"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data              = file("${path.module}/../Scripts/user_data.sh")
  tags = {
    Name = "DevOpsEC2-${var.stage}"
  }
}
