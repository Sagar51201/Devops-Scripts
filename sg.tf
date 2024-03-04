#Creating security groups for EC2
resource "aws_security_group" "EC2_Security_groups" {
  name        = "EC2_Security_groups"
  description = "Security EC2"
  vpc_id      = aws_vpc.Dev.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.internet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr]
  }
}
#Creating security group for RDS
resource "aws_security_group" "RDS_sg" {
  name        = "RDS_sg"
  description = "security rds"
  vpc_id      = aws_vpc.Dev.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr]
  }
}
