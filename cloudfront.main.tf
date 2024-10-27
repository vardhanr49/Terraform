# Provider configuration
provider "aws" {
  region = "us-west-2"  # Change to your preferred AWS region
}

# S3 bucket to be used as the origin
resource "aws_s3_bucket" "origin_bucket" {
  bucket = "my-cloudfront-origin-bucket"  # Change to a unique bucket name

  acl = "public-read"  # Grant public read access to the S3 bucket
  tags = {
    Name = "CloudFront-Origin-Bucket"
  }
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = aws_s3_bucket.origin_bucket.bucket_regional_domain_name
    origin_id   = "S3-my-cloudfront-origin-bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront Distribution"
  default_root_object = "index.html"  # Define the default object to serve

  # Default Cache Behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-my-cloudfront-origin-bucket"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Price Class (Optional: controls cost by restricting edge locations)
  price_class = "PriceClass_100"  # Options: PriceClass_All, PriceClass_200, PriceClass_100

  # Viewer Certificate (Set to default certificate for HTTPS access)
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "MyCloudFrontDistribution"
  }
}

# CloudFront Origin Access Identity for private S3 content access
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Origin Access Identity for CloudFront to access S3 bucket"
}

# S3 Bucket Policy to allow CloudFront access
resource "aws_s3_bucket_policy" "origin_bucket_policy" {
  bucket = aws_s3_bucket.origin_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.origin_bucket.arn}/*"
      }
    ]
  })
}
