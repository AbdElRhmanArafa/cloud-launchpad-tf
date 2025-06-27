resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "main" {
    for_each = {for subnet in var.subnets_list : subnet.name => subnet}
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = each.value.type == "public" ? true : false
    tags = {
      Name = "${each.value.name}"
    }

}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "${var.project_name}-public-route-table"
        }
}

resource "aws_route_table_association" "public_subnet1_association" {
    subnet_id      =  aws_subnet.main["public_subnet1"].id
    route_table_id = aws_route_table.public_route_table.id
}