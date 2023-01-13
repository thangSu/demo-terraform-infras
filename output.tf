output "elb_ip" {
  value = aws_elb.infras_lb.dns_name
}
output "bastion_ip" {
  value = module.bastion.ec2_ip
}
