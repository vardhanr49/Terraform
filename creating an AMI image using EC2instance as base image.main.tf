#creating an AMI image using EC2instance as base image
#creating a provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# EC2 Instance to create AMI from
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Base AMI, e.g., Amazon Linux 2
  instance_type = "t2.micro"

  # Instance Tags
  tags = {
    Name = "Example Instance"
  }
}

# Create an AMI from the instance
resource "aws_ami_from_instance" "example_ami" {
  name               = "example-custom-ami"
  source_instance_id = aws_instance.example.id
  snapshot_without_reboot = true  # Optional: If set to true, the instance won't reboot.

  # AMI Tags
  tags = {
    Name = "Custom AMI from Example Instance"
  }
}

# Optionally, terminate the instance after AMI creation
resource "aws_instance" "terminate_instance" {
  depends_on = [aws_ami_from_instance.example_ami]
  count      = 0  # Instance no longer needed after AMI creation.
}
