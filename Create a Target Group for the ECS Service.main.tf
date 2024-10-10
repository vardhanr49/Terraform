# Create a Target Group for the ECS Service
resource "aws_lb_target_group" "ecs_tg" {
  name     = "ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678"  # Replace with your actual VPC ID

  health_check {
    path = "/"
  }

  tags = {
    Name = "ECS Target Group"
  }
}
