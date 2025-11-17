resource "aws_db_subnet_group" "rds_subnet" {
  name       = "inventory-rds-subnet"
  subnet_ids = [for s in aws_subnet.private : s.id]
}

resource "aws_db_instance" "postgres" {
  identifier = "inventory-postgres"
  engine = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  name = "inventory"
  username = var.db_username
  password = var.db_password
  port = 5432
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true
  publicly_accessible = false
  tags = { Name = "inventory-rds" }
}
