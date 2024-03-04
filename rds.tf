#Creating subnet group for RDS
resource "aws_db_subnet_group" "DB_group" {
  name       = "database_subnet"
  subnet_ids = [aws_subnet.Private_subnet.id, aws_subnet.RDS_Private_subnet.id]
}


#Creating RDS
resource "aws_db_instance" "Database" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "myDB"
  username               = var.user_name
  password               = var.db_pass
  db_subnet_group_name   = aws_db_subnet_group.DB_group.name
  vpc_security_group_ids = [aws_security_group.RDS_sg.id]
  skip_final_snapshot    = true
}
