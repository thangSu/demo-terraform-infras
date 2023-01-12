module "infra_vpc" {
    source = "./module/vpc"
    vpc_name = "infra_vpc"
}
# create sg 
resource "aws_security_group" "ec2_sg" {
    name = "thang test"
    vpc_id = module.infra_vpc.vpc_id
    #inbound
    ingress {
         description = "allow HTTP protocol"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        description = "allow HTTPs protocol"
        from_port = 433
        to_port = 433
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
     ingress {
        description = "allow HTTPs protocol"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    #outbound
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = {
      "Name" = "ec2-sg"
    }
}
resource "aws_key_pair" "ssh_key" {
  key_name   = "terra-key"
  public_key = file("tf-demo.pub")
}

resource "aws_security_group" "bastion_sg" {
    name = "bastion_sg"
    vpc_id = module.infra_vpc.vpc_id
     ingress {
        description = "allow ssh protocol"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    #outbound
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = {
      "Name" = "bastion-sg"
    }
}
module "bastion" {
    source = "./module/instance"
    security_list = [aws_security_group.bastion_sg.id]
    subnet = module.infra_vpc.subnet_id[0]
    key_pair = aws_key_pair.ssh_key.key_name
    name_ec2 = "bastion-host"
}

resource "aws_security_group" "database_sg" {
    name = "database_sg"
    vpc_id = module.infra_vpc.vpc_id
     ingress {
        description = "allow ssh protocol"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "10.0.1.0/24" ]
    }
    #outbound
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = {
      "Name" = "database-sg"
    }
}
module "database" {
    source = "./module/instance"
    security_list = [aws_security_group.database_sg.id]
    subnet = module.infra_vpc.subnet_id[2]
    key_pair = aws_key_pair.ssh_key.key_name
    name_ec2 = "database-host"
    ip_address =false
}