# Create an ECS Task Definition for a simple web app
resource "aws_ecs_task_definition" "web_task" {
  family                   = "web-app-task"
  network_mode             = "awsvpc"  # Using Fargate requires the network mode to be "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  # 0.25 vCPU
  memory                   = "512"  # 512 MiB memory

  container_definitions = jsonencode([{
    name  = "web-container"
    image = "nginx:latest"  # Replace with your desired container image
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}
