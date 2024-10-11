provider "aws" {
  region = "us-east-1"  # Replace with your preferred region
}

# Create a Security Group for the Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Allow HTTP traffic for the ALB"
  vpc_id      = "vpc-12345678"  # Replace with your VPC ID

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
    Name = "ALB Security Group"
  }
}

# Create an Elastic Load Balancer (ALB)
resource "aws_lb" "app_alb" {
  name               = "my-app-load-balancer"
  internal           = false  # If true, makes the LB internal-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-12345678", "subnet-87654321"]  # Replace with your actual subnet IDs

  tags = {
    Name = "App Load Balancer"
  }
}

# Create a Target Group for the Load Balancer
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678"  # Replace with your VPC ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "App Target Group"
  }
}

# Create a Listener for the ALB to forward traffic to the Target Group
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Output the DNS name of the Load Balancer
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
