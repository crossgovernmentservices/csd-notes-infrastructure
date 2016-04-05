resource "aws_db_parameter_group" "main" {
  name = "notes-main-postgres-${var.environment}"
  family = "postgres9.4"
  description = "RDS main postgres parameter group"
}

resource "aws_db_subnet_group" "main" {
  name = "notes-main-${var.environment}"
  description = "Main postgres instance subnet group"
  subnet_ids = [
    "${aws_subnet.private-a.id}",
    "${aws_subnet.private-b.id}",
    "${aws_subnet.private-c.id}"
  ]
  tags {
    Name = "main-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage    = "${var.rds_allocated_storage}"
  engine               = "postgres"
  engine_version       = "9.4.5"
  instance_class       = "${var.rds_instance_class}"
  name                 = "notes"
  username             = "${var.rds_username}"
  password             = "${var.rds_password}"
  db_subnet_group_name = "notes-main-${var.environment}"
  parameter_group_name = "notes-main-postgres-${var.environment}"
  vpc_security_group_ids = [
    "${aws_security_group.web-to-main-postgres.id}"
  ]
  storage_encrypted = "${var.rds_storage_encrypted}"
  multi_az = "${var.rds_multi_az}"
  publicly_accessible = false
  copy_tags_to_snapshot = true

  depends_on = [
    "aws_db_parameter_group.main",
    "aws_db_subnet_group.main"
  ]

  tags {
    Name = "notes-main-${var.environment}"
    Environment = "${var.environment}"
  }
}
