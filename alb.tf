# resource "aws_lb_target_group" "test_group" {
#   health_check {
#     interval = 10
#     path = "/"
#     protocol = "HTTP"
#     timeout = 5
#     healthy_threshold = 5
#     unhealthy_threshold = 2
#   }
#   name = "testApp"
#   port = 80
#   protocol = "HTTP"
#   target_type = "instance"
#   vpc_id = module.infra_vpc.vpc_id
# }
# //sgs


# // create lb
# resource "aws_lb" "test_lb" {
#   name               = "test-lb"
#   internal           = false
#   ip_address_type = "ipv4"
#   load_balancer_type = "application"
#   security_groups = [ aws_security_group.ec2_sg.id  ]
#   subnets            = [module.infra_vpc.subnet_id[0], module.infra_vpc.subnet_id[2]]
#   tags = {
#     Environment = "test"
#   }
# }
# // create listener
# resource "aws_lb_listener" "test_listener" {
#   load_balancer_arn = aws_lb.test_lb.arn
#   port = 80
#   protocol = "HTTP"
#   default_action {
#     target_group_arn = aws_lb_target_group.test_group.arn
#     type = "forward"
#   }
# }
# resource "aws_lb_target_group_attachment" "test_target" {
#   count = length(var.instance_name)
#   target_group_arn = aws_lb_target_group.test_group.arn
#   target_id = module.thang_instance[count.index].ec2_id
# }


resource "aws_elb" "infras_lb" {
  name               = "infras-lb"
  security_groups = [ aws_security_group.ec2_sg.id  ]
  subnets            = [module.infra_vpc.subnet_id[0], module.infra_vpc.subnet_id[1]]
  cross_zone_load_balancing   = true
    health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
  tags = {
    Environment = "test"
  }
}





