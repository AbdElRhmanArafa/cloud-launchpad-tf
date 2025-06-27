# create a logging module for AWS VPC flow logs
resource "aws_cloudwatch_log_group" "logs" {
  name = "${var.project_name}-logs"
}

resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.logging_role.arn
  log_destination = aws_cloudwatch_log_group.logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
  tags = {
    Name        = "${var.project_name}-vpc-flow-log"
    Environment = terraform.workspace
  }
  
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "logging_role" {
  name               = "${var.project_name}-logging-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "policy-logging" {
  name   = "${var.project_name}-logging-policy"
  role   = aws_iam_role.logging_role.id
  policy = data.aws_iam_policy_document.logs.id
}

# create a module for logging to s3 bucket
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "${var.project_name}-logs-bucket"
    tags = {
        Name        = "${var.project_name}-logs-bucket"
        Environment = terraform.workspace
    }
}   
# create a flow log for the s3 bucket
resource "aws_flow_log" "s3_flow_log" {
  log_destination      = aws_s3_bucket.logs_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  tags = {
    Name        = "${var.project_name}-s3-flow-log"
    Environment = terraform.workspace
  }
}


