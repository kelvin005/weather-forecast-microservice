# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "main-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "task-manager-proj-igw" }
}

# Public Subnets
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name                          = "eks-public-subnet-1"
    "kubernetes.io/role/elb"          = "1"
    "kubernetes.io/cluster/task-manager-eks" = "shared"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name                          = "eks-public-subnet-2"
    "kubernetes.io/role/elb"          = "1"
    "kubernetes.io/cluster/task-manager-eks" = "shared"
  }
}

# Private Subnets
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name                                 = "eks-private-subnet-1"
    
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name                                 = "eks-private-subnet-2"

  }
}

# NAT Gateway
resource "aws_eip" "nat_1" {
  domain = "vpc"
  tags   = { Name = "nat-eip-1" }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public1.id
  tags          = { Name = "nat-gateway-1" }
}

# NAT Gatebastion hostway
resource "aws_eip" "nat_2" {
  domain = "vpc"
  tags   = { Name = "nat-eip-2" }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public2.id
  tags          = { Name = "nat-gateway-2" }
}


# Route Tables
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}


resource "aws_route_table" "route_table_private_1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
  tags = { Name = "private-rt_1" }
}
resource "aws_route_table" "route_table_private_2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }
  tags = { Name = "private-rt_2" }
}

# Route Table Associations
resource "aws_route_table_association" "route_table_association_public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_table_association_public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_table_association_private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.route_table_private_1.id
}

resource "aws_route_table_association" "route_table_association_private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.route_table_private_2.id
}

