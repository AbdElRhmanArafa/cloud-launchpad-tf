variable "subnets" {
  description = "A map of subnet objects to launch EC2 instances into."
  type = map(any)
}

variable "vpc_id" {
  description = "The VPC ID to launch EC2 instances into."
  type = string
}

variable "project_name" {
  description = "The name of the project, used for tagging resources."
  type        = string
}