variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}
variable "subnet_list" {
  type = list
  default = ["10.0.1.0/24","10.0.3.0/24","10.0.2.0/24","10.0.4.0/24"]
}
variable "zone_list" {
  type =list
  default = ["us-east-1a","us-east-1b","us-east-1a","us-east-1b"]
}
variable "vpc_name" {
  type = string
}