resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

data "aws_ssm_parameter" "db_password" {
    name = "/myapp/db/password"
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-postgres"

  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_encrypted  = true

  db_name  = "appdb"
  username = "postgres"

  password = data.aws_ssm_parameter.db_password.value

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  skip_final_snapshot = true
  publicly_accessible  = true

  multi_az = false
}