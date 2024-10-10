# Create an ECS Service
resource "aws_ecs_service" "web_service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.my_ecs_cluster.id
  task_definition = aws_ecs_task_definition.web_task.arn
  desired_count   = 1  # Number of tasks to run
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678", "subnet-87654321"]  # Replace with your actual VPC subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "web-container"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.http_listener,
  ]
}
