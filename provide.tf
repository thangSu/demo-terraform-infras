provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "saophaixoa"
    region = "us-east-1"
  }
}
