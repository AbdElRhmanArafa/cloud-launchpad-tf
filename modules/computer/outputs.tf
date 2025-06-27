output "instance_ids" {
  value = { for k, inst in aws_instance.name : k => inst.id }
}
