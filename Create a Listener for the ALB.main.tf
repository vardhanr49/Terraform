# Create a Listener for the ALB
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

# Output the Load Balancer DNS Name
output "load_balancer_dns" {
  value = aws_lb.ecs_lb.dns_name
}
