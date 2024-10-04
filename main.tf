#main.tf
#This file contains the creation of resources to require for a vpc.

#specifying the provider
provider "aws" {
region = "us-east-1"
}
#create a vpc
resource "aws_vpc" "my_vpc" {
 cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
  Name = "my_vpc"
  }
  }
  #create a subnet
  resource "aws_subnet" "my_subnet" {
  vpc_id   = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1"

  tags = {
  Name = "my_subnet"
  }
  }
  #create a internet gateway
  resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
  Name = "my_internet_gateway"
  }
  }
  #create a route table
  resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_route_table"
  }
}
#create route table association
resource "aws_route_table_association" "my_route_table_association" {
subnet_id = aws_subnet.my_subnet.id
route_table_id = aws_route_table.my_route_table.id
}
#create security group
resource "aws_security_group" "my_security_group" {
vpc_id = aws_vpc.my_vpc.id

ingress{
from_port = 22
to_port   = 22
protocol  = "tcp"
cidr      = ["0.0.0.0/0"]
}
ingress{
from_port = 80
to_port   = 80
protocol  = "tcp"
cidr      = ["0.0.0.0/0"]
}
egress{
from_port = 0
to_port   = 0
protocol  = "-1"
cidr      = ["0.0.0.0/0"]
}
tags = {
Name = "my_security_group"
}
}

