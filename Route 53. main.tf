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
