
output "log_group_name" {
  value = aws_cloudwatch_log_group.main.name
}

output "flow_log_id" {
  value = aws_flow_log.vpc_flow_log.id
}
output "logging_role_arn" {
  value = aws_iam_role.logging_role.arn
}
output "logs_bucket_name" {
  value = aws_s3_bucket.logs_bucket.bucket
}
output "logs_bucket_arn" {
  value = aws_s3_bucket.logs_bucket.arn
}
