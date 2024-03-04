#Creating VPC, name, CIDR and Tags
resource "aws_vpc" "Dev" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Dev"
  }
}

#Creating Public Subnets in VPC
resource "aws_subnet" "Public_subnet" {
  vpc_id                  = aws_vpc.Dev.id
  cidr_block              = var.publicsub_cidr
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Public_subnet"
  }
}

#Creating Private Subnet in VPC
resource "aws_subnet" "Private_subnet" {
  vpc_id            = aws_vpc.Dev.id
  cidr_block        = var.privatesub_cidr
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Private_subnet"
  }
}

#Creating Private Subnet for RDS
resource "aws_subnet" "RDS_Private_subnet" {
  vpc_id            = aws_vpc.Dev.id
  cidr_block        = var.rdssub_cidr
  availability_zone = "ap-south-1b"
  tags = {
    Name = "RDS_Private_subnet"
  }
}

#Creating Elasticip
resource "aws_eip" "Nat_ip" {
  domain = "vpc"
  tags = {
    Name = "Nat_ip"
  }
}

#Creating NAT Gateway
resource "aws_nat_gateway" "Nat_gw" {
  allocation_id = aws_eip.Nat_ip.id
  subnet_id     = aws_subnet.Public_subnet.id
  tags = {
    Name = "Nat_gw"
  }
}

#Crearing Internet Gateway
resource "aws_internet_gateway" "Internet_gw" {
  vpc_id = aws_vpc.Dev.id

  tags = {
    Name = "Internet_gw"
  }
}

#Creating Public route table
resource "aws_route_table" "Public_Route_table" {
  vpc_id = aws_vpc.Dev.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.Internet_gw.id
  }

  tags = {
    Name = "Public_Route_table"
  }
}

#Creating Private route table
resource "aws_route_table" "Private_Route_table" {
  vpc_id = aws_vpc.Dev.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_nat_gateway.Nat_gw.id
  }
  tags = {
    Name = "Private_Route_table"
  }
}

#Creating Route table associations
resource "aws_route_table_association" "Dev-public" {
  subnet_id      = aws_subnet.Public_subnet.id
  route_table_id = aws_route_table.Public_Route_table.id
}

resource "aws_route_table_association" "Dev-private" {
  subnet_id      = aws_subnet.Private_subnet.id
  route_table_id = aws_route_table.Private_Route_table.id
}

