#Using this file we can create an IAM user, group and policies for allowing only EC2, S3.
provider "aws" {
  region = "us-east-1"  # Replace with your preferred region
}

# Create an IAM Group
resource "aws_iam_group" "devops_group" {
  name = "devops_group"

  tags = {
    Name = "DevOps Group"
  }
}

# Create an IAM Policy
resource "aws_iam_policy" "devops_policy" {
  name        = "devops_policy"
  description = "A policy granting full access to EC2 and S3"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:*",
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

# Attach the policy to the group
resource "aws_iam_group_policy_attachment" "attach_policy_to_group" {
  group      = aws_iam_group.devops_group.name
  policy_arn = aws_iam_policy.devops_policy.arn
}

# Create an IAM User
resource "aws_iam_user" "devops_user" {
  name = "devops_user"
  
  tags = {
    Name = "DevOps User"
  }
}

# Add the user to the group
resource "aws_iam_user_group_membership" "add_user_to_group" {
  user = aws_iam_user.devops_user.name
  groups = [aws_iam_group.devops_group.name]
}

# Optional: Create IAM Access Key for the user
resource "aws_iam_access_key" "devops_access_key" {
  user = aws_iam_user.devops_user.name
}

# Output the access key and secret key
output "access_key_id" {
  value = aws_iam_access_key.devops_access_key.id
}

output "secret_access_key" {
  value = aws_iam_access_key.devops_access_key.secret
  sensitive = true
}
