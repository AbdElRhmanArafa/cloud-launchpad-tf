# create a ec2 instance for each subnet in the my vpc
resource "aws_instance" "name" {
  for_each = var.subnets
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = each.value.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  tags = {
    Name = " ${var.project_name}-${each.key}-ec2"
  }
}

# Add security group to allow SSH access
resource "aws_security_group" "ssh_access" {
  name        = "${var.project_name}-ssh-access"
  description = "Allow SSH access"
  vpc_id      = var.vpc_id  
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0/0"]
    }
}
    