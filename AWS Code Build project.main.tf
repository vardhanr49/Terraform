# Define the AWS provider
provider "aws" {
  region = "us-west-2" # Specify your desired region
}

# Create an S3 bucket for storing build artifacts (optional)
resource "aws_s3_bucket" "codebuild_artifacts_bucket" {
  bucket = "my-codebuild-artifacts-bucket"

  tags = {
    Name = "codebuild-artifacts"
  }
}

# Create an IAM role for CodeBuild
resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

# Attach policies to the IAM role
resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

# Create a CodeBuild project
resource "aws_codebuild_project" "my_codebuild_project" {
  name          = "my-codebuild-project"
  service_role  = aws_iam_role.codebuild_service_role.arn

  # Source settings (Assume you're using a GitHub repository as source)
  source {
    type      = "GITHUB"
    location  = "https://github.com/my-repo/my-project"  # Replace with your repo
    buildspec = "buildspec.yml"  # Specify your buildspec file
  }

  # Environment settings
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0" # Example standard image
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true   # Set to true for Docker build
    environment_variable {
      name  = "ENVIRONMENT"
      value = "production"
    }
  }

  # Artifacts settings (Output stored in S3)
  artifacts {
    type      = "S3"
    location  = aws_s3_bucket.codebuild_artifacts_bucket.bucket
    packaging = "ZIP"
    path      = "builds/"
  }

  # Cache settings (optional)
  cache {
    type = "LOCAL"
    modes = ["LOCAL_SOURCE_CACHE", "LOCAL_DOCKER_LAYER_CACHE"]
  }

  # Tags
  tags = {
    Name = "my-codebuild-project"
  }
}

# Output the CodeBuild project name
output "codebuild_project_name" {
  value = aws_codebuild_project.my_codebuild_project.name
}
