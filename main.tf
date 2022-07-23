provider "aws" {
  region = "eu-west-3"
}

variable "subnet_cidr" {
  description = "subnet cidr block"
}

  resource "aws_vpc" "dev-vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
      name: "vpc-development"
      vpc_env: "dev"
    }
  }
  
  resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = "eu-west-3a"
    tags = {
      name: "sub-mysub"
    }
  }
  
 output "dev-vpc-id" {
   value = aws_vpc.dev-vpc.id 
 }
   output "dev-subnet-1" {
   value = aws_subnet.dev-subnet-1.id 
 }
  

