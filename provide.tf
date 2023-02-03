provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "saophaixoa"
    key    = "/"
    region = "us-east-1"
  }
}
