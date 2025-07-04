resource "aws_vpc" "kimit" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
     Name = "${local.env}-kimit"}
}
resource "aws_subnet" "private_zone1" {
  vpc_id = aws_vpc.kimit.id
  cidr_block = "10.0.0.0/19"
  availability_zone = local.zone1
  tags = {
    "Name" = "${local.env}-private-${local.zone1}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.eks_name}" = "owned"
  }
}
resource "aws_subnet" "private_zone2" {
  vpc_id = aws_vpc.kimit.id
  cidr_block = "10.0.32.0/19"
  availability_zone = local.zone2
  tags = {
    "Name" = "${local.env}-private-${local.zone2}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.eks_name}" = "owned"

  }
}
resource "aws_subnet" "public_zone1" {
  vpc_id = aws_vpc.kimit.id
  cidr_block = "10.0.64.0/19"
  availability_zone = local.zone1
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${local.env}-public-${local.zone1}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.eks_name}" = "owned"

  }
}
resource "aws_subnet" "public_zone2" {
  vpc_id = aws_vpc.kimit.id
  cidr_block = "10.0.96.0/19"
  availability_zone = local.zone2
  map_public_ip_on_launch =   true
  tags = {
    "Name" = "${local.env}-public-${local.zone2}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.eks_name}" = "owned"
  }
}
resource "aws_eip" "nat-eip" {
  domain = "vpc"
  tags = {Name= "${local.env}-nat"}
}
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.public_zone1.id #change here

 tags = {Name= "${local.env}-nat-gw"}
 depends_on = [ aws_internet_gateway.public-igw ]
}
resource "aws_internet_gateway" "public-igw" {
    vpc_id = aws_vpc.kimit.id
    
    tags = { Name = "${local.env}-igw" }
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.kimit.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "${local.env}-private"
  }
}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.kimit.id  

  route {  
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public-igw.id  
  }

  tags = {
    Name = "${local.env}-public"
  }
}
resource "aws_route_table_association" "private_zone1" {
    
  subnet_id = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private-rt.id

}
resource "aws_route_table_association" "private_zone2" {
  subnet_id = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "public_zone1" {
    
  subnet_id = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public-rt.id

}
resource "aws_route_table_association" "public_zone2" {
  subnet_id = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public-rt.id
}

