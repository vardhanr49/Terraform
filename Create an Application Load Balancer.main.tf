# Create an Application Load Balancer (ALB)
resource "aws_lb" "ecs_lb" {
  name               = "ecs-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = ["subnet-12345678", "subnet-87654321"]  # Replace with your actual VPC subnets

  tags = {
    Name = "ECS Load Balancer"
  }
}
