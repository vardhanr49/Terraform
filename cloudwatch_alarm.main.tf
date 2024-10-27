# Provider configuration
provider "aws" {
  region = "us-west-2"  # Change to your preferred AWS region
}

# Define variables for the instance ID and CPU threshold
variable "instance_id" {
  description = "ID of the EC2 instance to monitor"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization threshold to trigger the alarm"
  type        = number
  default     = 80  # Trigger alarm if CPU utilization exceeds 80%
}

# Create a CloudWatch Alarm for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # In seconds (5 minutes)
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "This alarm triggers if CPU utilization is higher than 80% for two consecutive periods of 5 minutes."
  actions_enabled     = true

  # Specify the EC2 instance ID to monitor
  dimensions = {
    InstanceId = var.instance_id
  }

  # Optional: Add notification action (SNS topic)
  alarm_actions = [
    "arn:aws:sns:us-west-2:123456789012:my-sns-topic"  # Replace with your SNS ARN
  ]

  # Optional: Add actions for alarm state changes
  ok_actions    = []
  insufficient_data_actions = []
}
