# Provider configuration
provider "aws" {
  region = "us-west-2" # Specify your AWS region
}

# Create a CloudWatch Log Group
resource "aws_cloudwatch_log_group" "my_log_group" {
  name              = "/aws/ecs/my-log-group" # Name of the log group
  retention_in_days = 7                       # Log retention period in days
}

# Create a CloudWatch Metric Alarm for EC2 CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "HighCPUUtilizationAlarm" # Name of the alarm
  comparison_operator = "GreaterThanThreshold"    # Trigger condition
  evaluation_periods  = 2                         # Number of periods for evaluation
  metric_name         = "CPUUtilization"          # Metric to monitor
  namespace           = "AWS/EC2"                 # Namespace of the metric
  period              = 300                       # Period in seconds (5 minutes)
  statistic           = "Average"                 # Type of statistic to track
  threshold           = 80                        # Threshold for the alarm (80% CPU)
  alarm_description   = "This alarm monitors EC2 CPU utilization and triggers if usage exceeds 80%."

  # Dimensions to apply the metric alarm (filter by EC2 instance ID)
  dimensions = {
    InstanceId = "i-0123456789abcdef0" # Replace with your EC2 instance ID
  }

  # Define the actions to take when the alarm is triggered or cleared
  alarm_actions          = ["arn:aws:sns:us-west-2:123456789012:my-sns-topic"] # Replace with your SNS topic ARN
  ok_actions             = ["arn:aws:sns:us-west-2:123456789012:my-sns-topic"]
  insufficient_data_actions = []

  # Optional, set the number of evaluation periods during which the alarm state must change
  datapoints_to_alarm = 2
}

# Create SNS topic for alarm notifications (optional)
resource "aws_sns_topic" "alarm_topic" {
  name = "my-sns-topic" # Name of the SNS topic
}

# Subscribe to the SNS topic for email notifications (optional)
resource "aws_sns_topic_subscription" "alarm_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = "your-email@example.com" # Replace with your email address
}
