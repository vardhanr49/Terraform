#Using this file we can create AWS_RDS instance using Mysql database

provider "aws" {
  region = "us-east-1"  # Replace with your preferred region
}

# Create a Security Group for the RDS Instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow MySQL traffic"

  ingress {
    description = "Allow MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # For testing; restrict this for production use
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

# Create a Subnet Group for the RDS instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  description = "RDS Subnet Group"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]  # Replace with your actual subnet IDs

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Create an RDS MySQL Database Instance
resource "aws_db_instance" "mydb" {
  allocated_storage    = 20  # Storage size in GB
  engine               = "mysql"
  engine_version       = "8.0"  # Version of MySQL
  instance_class       = "db.t3.micro"  # Free tier eligible instance type
  name                 = "mydb"
  username             = "admin"  # Master username
  password             = "yourpassword"  # Master password (replace with a secure password)
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true  # Skip snapshot for quick deletion (not recommended in production)

  tags = {
    Name = "My RDS Database"
    Environment = "Dev"
  }
}

# Output the RDS Endpoint
output "rds_endpoint" {
  value = aws_db_instance.mydb.endpoint
}

# Output the Database Name
output "rds_db_name" {
  value = aws_db_instance.mydb.name
}
