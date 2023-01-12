resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = var.vpc_name
  }
}
resource "aws_internet_gateway" "ig1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    "Name" = "infra gateway"
  }
}
resource "aws_subnet" "subnet" {
    count = length(var.subnet_list)
    vpc_id = aws_vpc.vpc1.id
    availability_zone = var.zone_list[count.index]
    cidr_block = var.subnet_list[count.index]
    tags = {
        "Name" = "infra subnet ${count.index}"
    }
}
resource "aws_route_table" "rt1" {
    vpc_id = aws_vpc.vpc1.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig1.id
    }
    route {
        ipv6_cidr_block  = "::/0"
        gateway_id = aws_internet_gateway.ig1.id
    }
    tags = {
      "Name" = "infra rt - public"
    }
}
resource "aws_route_table_association" "rta0" {
  route_table_id = aws_route_table.rt1.id
  subnet_id = aws_subnet.subnet[0].id
}
resource "aws_route_table_association" "rta1" {
  route_table_id = aws_route_table.rt1.id
  subnet_id = aws_subnet.subnet[1].id
}
resource "aws_eip" "ip" {
    vpc = true
    tags ={
      Name = "elasticIP"
    }
}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.ip.id
    subnet_id = aws_subnet.subnet[2].id
    tags = {
      "Name" = "Nat-subnet 2"
    }
}
resource "aws_route_table" "rt2" {
    vpc_id = aws_vpc.vpc1.id
    tags = {
      "Name" = "infra rt-private"
    }
}
resource "aws_route_table_association" "rta2" {
  route_table_id = aws_route_table.rt1.id
  subnet_id = aws_subnet.subnet[2].id
}
resource "aws_route_table_association" "rta3" {
  route_table_id = aws_route_table.rt1.id
  subnet_id = aws_subnet.subnet[3].id
}