provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "VPC_Terraform" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames= "true"

  tags = {
    Name = "VPC_Terraform"
  }
}

resource "aws_internet_gateway" "VPC_IGW" {
  vpc_id = aws_vpc.VPC_Terraform.id

  tags = {
    Name = "VPC_IGW"
  }
}

resource "aws_subnet" "VPC_subnet" {
  vpc_id     = aws_vpc.VPC_Terraform.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "VPC_subnet"
  }
}

resource "aws_route_table" "VPC_Route" {
  vpc_id = aws_vpc.VPC_Terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPC_IGW.id
  }

  tags = {
    Name = "VPC_Route"
  }
}

resource "aws_route_table_association" "VPC_Route_association" {
  subnet_id      = aws_subnet.VPC_subnet.id
  route_table_id = aws_route_table.VPC_Route.id
}

resource "aws_security_group" "VPC_Allow_all" {
  name        = "VPC_Allow_all"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.VPC_Terraform.id

  ingress{
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks =["0.0.0.0/0"]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks =["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC_Allow_all"
  }
}