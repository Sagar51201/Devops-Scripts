#Creating VPC endpoints for EC2
resource "aws_ec2_instance_connect_endpoint" "Endpoint" {
  subnet_id          = aws_subnet.Private_subnet.id
  security_group_ids = [aws_security_group.EC2_Security_groups.id]
  tags = {
    Name = "EC2_Endpoint"
  }
}

#Creating EC2
resource "aws_instance" "Web_app" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.Private_subnet.id
  vpc_security_group_ids = [aws_security_group.EC2_Security_groups.id]
  count                  = 1
  tags = {
    Name = "Web_app"
  }
}
