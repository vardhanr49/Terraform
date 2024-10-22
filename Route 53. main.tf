#Define the aws provider
provider "aws"{
  region = "us-east-1"
  }
resource "aws_route_53_zone" "my_zone" {
  name = "ramaseetha.com"

  tags = {
    Name = "my_route_53_zone"
    }
  }
# Output the Hosted Zone ID
output "route53_zone_id" {
  value = aws_route53_zone.my_zone.id
}


# To add DNS records such as an A record pointing to an IP address, extend the file like this:
# Create an A record in the Route 53 zone
resource "aws_route53_record" "my_a_record" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "www"  # Subdomain (e.g., www.example.com)
  type    = "A"
  ttl     = 300
  records = ["12.34.56.78"]  # Replace with your IP address

  tags = {
    Name = "my-a-record"
  }
}

