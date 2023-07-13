resource "aws_db_subnet_group" "rds_subnet_group" {
  count = var.rds_enabled ? 1 : 0
  name       = "${local.tag_name}-rds-subnet-group"
  subnet_ids = [aws_subnet.pvt_sub[0].id,aws_subnet.pvt_sub[1].id,aws_subnet.pub_sub[0].id,aws_subnet.pub_sub[1].id]

  tags = {
    Name = "${local.tag_name}-rds-subnet-group"
  }
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  count	 = var.rds_enabled ? 1 : 0
  name   = "${local.tag_name}-rds-parameter-group"
  family = var.rds_family

  /*parameter {
    name  = "log_connections"
    value = "1"
  }*/
}

resource "aws_db_instance" "rds_instance" {
  count			             = var.rds_enabled ? var.rds_count : 0
  identifier             = var.rds_identifier[count.index]
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  max_allocated_storage  = var.rds_max_allocated_storage
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  username               = var.rds_username[count.index]
  password               = var.rds_password[count.index]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group[0].name
  //vpc_security_group_ids = [aws_security_group.rds_sg[0].id,aws_security_group.rds_asg[0].id]
  vpc_security_group_ids = var.asg_enabled == true ?  [aws_security_group.rds_asg[0].id] : [aws_security_group.rds_sg[0].id]
  parameter_group_name   = aws_db_parameter_group.rds_parameter_group[0].name
  publicly_accessible    = var.rds_public_accessibility
  skip_final_snapshot    = var.rds_skip_final_snapshot
  apply_immediately      = var.rds_instant_changes
}



