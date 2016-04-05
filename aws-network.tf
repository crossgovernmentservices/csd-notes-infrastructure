# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "notes-${var.environment}"
    Environment = "${var.environment}"
  }
}

# Public subnet AZ: A
resource "aws_subnet" "public-a" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "notes-${var.environment}-public-a"
    Environment = "${var.environment}"
  }
}

# Public subnet AZ: B
resource "aws_subnet" "public-b" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags {
    Name = "notes-${var.environment}-public-b"
    Environment = "${var.environment}"
  }
}

# Public subnet AZ: C
resource "aws_subnet" "public-c" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.3.0/24"
  availability_zone = "eu-west-1c"
  tags {
    Name = "notes-${var.environment}-public-c"
    Environment = "${var.environment}"
  }
}

# Private subnet AZ: A
resource "aws_subnet" "private-a" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.10.0/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "notes-${var.environment}-private-a"
    Environment = "${var.environment}"
  }
}

# Private subnet AZ: B
resource "aws_subnet" "private-b" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.11.0/24"
  availability_zone = "eu-west-1b"
  tags {
    Name = "notes-${var.environment}-private-b"
    Environment = "${var.environment}"
  }
}

# Private subnet AZ: C
resource "aws_subnet" "private-c" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.12.0/24"
  availability_zone = "eu-west-1c"
  tags {
    Name = "notes-${var.environment}-private-c"
    Environment = "${var.environment}"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "notes-${var.environment}"
    Environment = "${var.environment}"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table" "private-nat-a" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw-a.id}"
  }

  tags {
    Name = "notes-${var.environment}-private-nat-a"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private-nat-b" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw-b.id}"
  }

  tags {
    Name = "notes-${var.environment}-private-nat-b"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private-nat-c" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw-c.id}"
  }

  tags {
    Name = "notes-${var.environment}-private-nat-c"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private-nat-a" {
  subnet_id = "${aws_subnet.private-a.id}"
  route_table_id = "${aws_route_table.private-nat-a.id}"
}

resource "aws_route_table_association" "private-nat-b" {
  subnet_id = "${aws_subnet.private-b.id}"
  route_table_id = "${aws_route_table.private-nat-b.id}"
}

resource "aws_route_table_association" "private-nat-c" {
  subnet_id = "${aws_subnet.private-c.id}"
  route_table_id = "${aws_route_table.private-nat-c.id}"
}

# NAT gateway elastic IP, AZ: A
resource "aws_eip" "nat-a" {
    vpc = true
}

# NAT gateway elastic IP, AZ: B
resource "aws_eip" "nat-b" {
    vpc = true
}

# NAT gateway elastic IP, AZ: C
resource "aws_eip" "nat-c" {
    vpc = true
}

# NAT gateway instance, AZ: A
resource "aws_nat_gateway" "gw-a" {
  allocation_id = "${aws_eip.nat-a.id}"
  subnet_id = "${aws_subnet.public-a.id}"
  depends_on = ["aws_internet_gateway.default"]
}

# NAT gateway instance, AZ: B
resource "aws_nat_gateway" "gw-b" {
  allocation_id = "${aws_eip.nat-b.id}"
  subnet_id = "${aws_subnet.public-b.id}"
  depends_on = ["aws_internet_gateway.default"]
}

# NAT gateway instance, AZ: C
resource "aws_nat_gateway" "gw-c" {
  allocation_id = "${aws_eip.nat-c.id}"
  subnet_id = "${aws_subnet.public-c.id}"
  depends_on = ["aws_internet_gateway.default"]
}
