provider "aws" {
  region = "us-east-1"  # Replace with your preferred region
}

# Create an ECS Cluster
resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "my-ecs-cluster"
}

# Create a Security Group for ECS Service to allow traffic
resource "aws_security_group" "ecs_sg" {
  name        = "ecs_service_sg"
  description = "Allow HTTP traffic for ECS Service"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "ECS Security Group"
  }
}
