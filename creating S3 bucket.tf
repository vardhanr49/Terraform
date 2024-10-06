#this file contains creation of s3 bucket 
provider "aws" {
region = "us-east-1"
}
resource "aws_s3_bucket" "my_bucket" {
bucket = "my-unique-bucket-name"
acl = "private"
tags {
Name = "My s3 bucket"
Enivronment = "Dev"
}
}
