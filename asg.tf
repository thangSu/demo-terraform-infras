data "aws_ami""ami_linux" {

	most_recent = true
    owners = ["amazon"]
	filter {
	name = "name"
	values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
	}
	filter {
	name = "virtualization-type"
	values = ["hvm"]
  }
}
resource "aws_launch_configuration" "server" {
  name_prefix = "web-base"
  image_id        = data.aws_ami.ami_linux.id
  instance_type   = "t2.micro"
  user_data       = file("./base.sh")
  security_groups = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh_key.key_name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "infras_ag" {
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  health_check_type = "ELB"
  load_balancers = [
    aws_elb.infras_lb.id
  ]
  launch_configuration = aws_launch_configuration.server.name

  vpc_zone_identifier  =[
    module.infra_vpc.subnet_id[0], module.infra_vpc.subnet_id[1]
  ]
}

