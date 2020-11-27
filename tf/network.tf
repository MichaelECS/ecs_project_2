# create the VPC
resource "aws_vpc" "mike_al_VPC_dev" {
  cidr_block = var.vpcCIDRblock

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ma-acad-VPC-dev"
  }
}

# create the Subnet
resource "aws_subnet" "mike_al_VPC_SubnetOne_dev" {
  vpc_id                  = aws_vpc.mike_al_VPC_dev.id
  cidr_block              = var.subnetOneCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneOne

  tags = {
    Name = "ma-acad-VPC-subnet-dev"
  }
}

# create secondary subnet
resource "aws_subnet" "mike_al_VPC_SubnetTwo_dev" {
  vpc_id                  = aws_vpc.mike_al_VPC_dev.id
  cidr_block              = var.subnetTwoCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneTwo

  tags = {
    Name = "ma-acad-VPC-subnet-dev"
  }
}

# Create the Security Group
resource "aws_security_group" "mike_al_VPC_Security_Group_dev" {
  vpc_id      = aws_vpc.mike_al_VPC_dev.id
  name        = "Mike-Al VPC Security Group - dev"
  description = "Mike-Al VPC Security Group"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    security_groups = [aws_security_group.mike_al_alb_sg.id]
  }

  # allow ingress of port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow ingress of port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Mike-Al VPC Security Group - dev"
    Description = "Mike-Al VPC Security Group"
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "mike_al_VPC_GW_dev" {
  vpc_id = aws_vpc.mike_al_VPC_dev.id
  tags = {
    Name = "Mike-Al VPC Internet Gateway - dev"
  }
}

# Create the Route Table
resource "aws_route_table" "mike_al_VPC_route_table_dev" {
  vpc_id = aws_vpc.mike_al_VPC_dev.id

  tags = {
    Name = "Mike-Al VPC Route Table - dev"
  }
}

# Create the Internet Access
resource "aws_route" "mike_al_VPC_internet_access_dev" {
  route_table_id         = aws_route_table.mike_al_VPC_route_table_dev.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.mike_al_VPC_GW_dev.id
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "mike_al_VPC_association_one_dev" {
  subnet_id      = aws_subnet.mike_al_VPC_SubnetOne_dev.id
  route_table_id = aws_route_table.mike_al_VPC_route_table_dev.id
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "mike_al_VPC_association_two_dev" {
  subnet_id      = aws_subnet.mike_al_VPC_SubnetTwo_dev.id
  route_table_id = aws_route_table.mike_al_VPC_route_table_dev.id
}

output "subnet_one_id" {
  value = aws_subnet.mike_al_VPC_SubnetOne.id
}

output "subnet_two_id" {
  value = aws_subnet.mike_al_VPC_SubnetTwo.id
}

output "vpc_security_group_id" {
  value = aws_security_group.mike_al_VPC_Security_Group.id
}
