resource "aws_instance" "wordpress_server" {
  count             = var.wordpress_enabled && var.php_enabled ? var.ec2_count : 0
  ami               = var.ubuntu18 == true && var.ubuntu20 ==false ? data.aws_ami.ubuntu18.id : data.aws_ami.ubuntu20.id
  instance_type     = length(var.ec2_instance_type) == 1 ? var.ec2_instance_type[0] : var.ec2_instance_type[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  subnet_id         = aws_subnet.pub_sub[count.index % length(var.pub_sub_cidr)].id
  root_block_device {    
    delete_on_termination = var.ec2_delete_disk_on_termination
    volume_size = var.ec2_instance_volume_size
    volume_type = var.ec2_instance_volume_type
    tags = {
      Name = "${local.tag_name}-ebs-${count.index+1}"
    }
  }

  iam_instance_profile = aws_iam_instance_profile.wordpress_s3_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg[0].id]
  user_data       = templatefile("userdata/wordpress.sh",
  {
      php_version = var.php_version
      DB_NAME     = var.DB_NAME
      DB_USER     = var.DB_USER
      DB_PASSWORD = var.DB_PASSWORD
      DB_HOST     = aws_db_instance.mysql[0].address
      rds_pass    = var.rds_pass
      rds_user    = var.rds_user
  })
  tags = {
    Name = "${var.project_name}-wordpress-${count.index+1}"
    Created_through = "terraform"
  }
  key_name = aws_key_pair.deployer[0].id
  depends_on = [aws_db_instance.mysql]
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  count = var.mysql_enabled ? 1 : 0
  name       = "${local.tag_name}-rds-subnet-group"
  subnet_ids = [aws_subnet.pvt_sub[0].id,aws_subnet.pvt_sub[1].id,aws_subnet.pub_sub[0].id,aws_subnet.pub_sub[1].id]

  tags = {
    Name = "${local.tag_name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
   count = var.wordpress_enabled && var.php_enabled ? var.ec2_count : 0
   allocated_storage    = var.rds_allocated_storage
   storage_type         = "gp2"
   engine               = "mysql"
   engine_version       = var.rds_engine_version
   instance_class       = var.rds_instance_class
   username             = var.rds_user
   password             = var.rds_pass
   db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group[0].name
   vpc_security_group_ids = [aws_security_group.mysql_sg[0].id]
   publicly_accessible = "false"
   apply_immediately = "true"
   identifier = "${var.project_name}-${var.env}-rds"
   skip_final_snapshot = "true"
   parameter_group_name = "default.mysql5.7"
}

resource "aws_security_group" "mysql_sg" {
  count = var.wordpress_enabled && var.php_enabled ? var.ec2_count : 0
  name   = "${local.tag_name}-rds-sg"
  vpc_id = aws_vpc.main[0].id
  description = "allow rds to accessible"

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    security_groups = var.wordpress_enabled && var.php_enabled ? [aws_security_group.ec2_sg[0].id] : []
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${local.tag_name}-rds-sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  count = var.wordpress_enabled && var.php_enabled ? var.ec2_count : 0
  name        = "ec2_sg"
  description = "allow ssh accessibility"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    description      = "ssh to server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["111.93.242.34/32","180.151.15.236/32","180.151.78.218/32","180.151.78.220/32","180.151.78.222/32","182.74.4.226/32","34.238.12.186/32"]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_iam_role" "wordpress_s3_role" {
  name = "wordpress_s3_role-new"
  assume_role_policy = file("iam-policy/wordpress-s3-trusted-entity.json")
  tags = {
    Name = "wordpress_s3_role-new"
  }
}

resource "aws_iam_instance_profile" "wordpress_s3_profile" { 
  name = "wordpress_s3_profile-new"
  role = aws_iam_role.wordpress_s3_role.name
  tags = {
    Name = "ec2_s3_profile-new"
  }  
}

resource "aws_iam_role_policy" "wordpress_s3_policy" {
  name = "wordpress_s3_policy"
  role = aws_iam_role.wordpress_s3_role.id
  #policy = file("iam-policy/ec2-s3-policy.json")
  policy = <<-EOF
            {
            "Version": "2012-10-17",
            "Statement": [
                {
                "Effect": "Allow",    
                "Action": [
                    "s3:GetBucketLocation",
                    "s3:ListAllMyBuckets"
                ],                
                "Resource": "arn:aws:s3:::*"
                },
                {
                "Effect": "Allow",
                "Action": [
                    "s3:*"
                ],
                "Resource": [
                    "arn:aws:s3:::${aws_s3_bucket.wordpress_s3_bucket.bucket}"                        
                ]
                }
            ]
            }
            EOF
}
