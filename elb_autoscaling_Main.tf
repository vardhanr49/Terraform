# elb_autoscaling.tf
resource "aws_elb" "web_elb" {
  name               = "web-elb"
  availability_zones = ["us-west-2a"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  instances = [aws_instance.web.id]

  tags = {
    Name = "WebELB"
  }
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.public.id]
  launch_configuration = aws_launch_configuration.web_lc.id
}

resource "aws_launch_configuration" "web_lc" {
  image_id      = aws_instance.web.ami
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "WebLaunchConfig"
  }
}
