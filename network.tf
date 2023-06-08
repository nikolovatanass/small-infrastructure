# Create a VPC ----------------------------------------------------------------
resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc
  tags = {
    Name = "vpc-for-autoscale-with-loadbalncer"
  }
}

# Create 4 Subnets ------------------------------------------------------------
resource "aws_subnet" "terraform_sub1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = lookup(var.cidr_ranges, "public1")
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${lookup(var.subnet_type, "public")}-subnet1"
  }
}

resource "aws_subnet" "terraform_sub2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = lookup(var.cidr_ranges, "public2")
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${lookup(var.subnet_type, "public")}-subnet2"
  }
}

resource "aws_subnet" "terraform_sub3" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = lookup(var.cidr_ranges, "private1")
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${lookup(var.subnet_type, "private")}-subnet1"
  }
}

resource "aws_subnet" "terraform_sub4" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = lookup(var.cidr_ranges, "private2")
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${lookup(var.subnet_type, "private")}-subnet2"
  }
}

# Create a IGW ----------------------------------------------------------------
resource "aws_internet_gateway" "terraform_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

# Create 2 ElasticIP ---------------------------------------------------------
resource "aws_eip" "terraform_elip" {
  domain = "vpc"
  tags = {
    Name = "elip-for-nat1"
  }
}

resource "aws_eip" "terraform_elip2" {
  domain = "vpc"
  tags = {
    Name = "elip-for-nat2"
  }
}

# Create 2 NAT Gateway --------------------------------------------------------
resource "aws_nat_gateway" "terraform_nat" {
  allocation_id = aws_eip.terraform_elip.id
  subnet_id     = aws_subnet.terraform_sub1.id
  tags = {
    Name = "nat-to-pub-sub-gateway"
  }
}

resource "aws_nat_gateway" "terraform_nat2" {
  allocation_id = aws_eip.terraform_elip2.id
  subnet_id     = aws_subnet.terraform_sub2.id
  tags = {
    Name = "nat-to-pub-sub-gateway2"
  }
}

# Create 4 Routing Tables -----------------------------------------------------
resource "aws_route_table" "terraform_route_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }
  tags = {
    Name = "public-sub-to-igw"
  }
}

resource "aws_route_table" "route_nat" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform_nat.id
  }
  tags = {
    Name = "private-sub-to-nat"
  }
}

resource "aws_route_table" "route_nat2" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform_nat2.id
  }
  tags = {
    Name = "private-sub-to-nat2"
  }
}

# Assosiate Routing Tables ----------------------------------------------------
resource "aws_route_table_association" "terraform_associate1" {
  subnet_id      = aws_subnet.terraform_sub1.id
  route_table_id = aws_route_table.terraform_route_gateway.id
}

resource "aws_route_table_association" "terraform_associate2" {
  subnet_id      = aws_subnet.terraform_sub2.id
  route_table_id = aws_route_table.terraform_route_gateway.id
}

resource "aws_route_table_association" "terraform_associate3" {
  subnet_id      = aws_subnet.terraform_sub3.id
  route_table_id = aws_route_table.route_nat.id
}

resource "aws_route_table_association" "terraform_associate4" {
  subnet_id      = aws_subnet.terraform_sub4.id
  route_table_id = aws_route_table.route_nat2.id
}
