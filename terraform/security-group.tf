## For Application traffic
resource "aws_security_group" "allow_app_traffic" {
  count       = var.sg_app_enabled ? 1 : 0
  name        = "app_traffic_sg"
  description = "allow application traffic"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    description      = "For accessing application"
    from_port        = var.sg_app_port
    to_port          = var.sg_app_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_app_traffic "
  }
}

## For SSH Login
resource "aws_security_group" "allow_login" {
  count       = var.sg_enabled ? 1 : 0
  name        = "login_sg"
  description = "allow ssh accessibility"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    description      = "ssh to server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["111.93.242.34/32","180.151.15.236/32","180.151.78.218/32","180.151.78.220/32","180.151.78.222/32","182.74.4.226/32","34.238.12.186/32"]
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

## For RDS
resource "aws_security_group" "rds_sg" {
  count	 = var.rds_enabled ? 1 : 0
  name   = "${local.tag_name}-rds-sg"
  vpc_id = aws_vpc.main[0].id
  description = "allow rds to accessible"

  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_login[0].id]
  }
  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${local.tag_name}-rds-sg"
  }
}

#For Serverless
resource "aws_security_group" "serverless_sg" {
  count       = var.serverless_enabled ? 1 : 0
  name        = "serverless_sg"
  description = "Security group for serverless resource"
  vpc_id      = aws_vpc.main[0].id
  
  dynamic "ingress" {
    for_each = var.serverless_ing_rules
    content {
      description      = ingress.value.desc
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = "tcp"
      cidr_blocks      = ingress.value.cidr_block
    }
  }  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.tag_name}-serverless-sg"
  }
}


//security group for loadbalancer only
resource "aws_security_group" "elb" {
  count	 = (var.lb_enabled || var.asg_enabled ) ? 1 : 0 
  name   = "${local.tag_name}-elb-sg"
  vpc_id = aws_vpc.main[0].id
  description = "allow application traffic for loadbalancer only"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.asg_login[0].id]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.asg_login[0].id]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.asg_login[0].id]
  }
  tags = {
    Name   = "${local.tag_name}-elb-sg"
  }
}

//security group for asg only 
resource "aws_security_group" "asg_login" {
  count = var.asg_enabled ? 1 : 0
  name        = "asg-sg"
  description = "ssh access from bastion server"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    description      = "ssh to server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.allow_login[0].id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_asg_ssh"
  }
}
//rds with asg group sg
resource "aws_security_group" "rds_asg" {
  count	 = (var.asg_enabled && var.rds_enabled) ? 1 : 0
  name   = "${local.tag_name}-rds-sg-asg"
  vpc_id = aws_vpc.main[0].id
  description = "rds accessbilty for asg instances"

  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
    //cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.asg_login[0].id]
  }

  egress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${local.tag_name}-rds-asg"
  }
}


resource "aws_security_group" "cloudflare" {
  count = var.cloudflare_enabled ? 1 : 0
  name        = "cloudflare-sg"
  description = "cloudflate port"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    description      = "ssh to server"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["173.245.48.0/20","103.21.244.0/22","103.21.244.0/22","103.21.244.0/22","141.101.64.0/18","108.162.192.0/18",
                        "190.93.240.0/20","188.114.96.0/20","188.114.96.0/20","188.114.96.0/20","162.158.0.0/15","162.158.0.0/15",
                        "162.158.0.0/15","172.64.0.0/13","172.64.0.0/13"]
  }
  
  ingress {
    description      = "ssh to server"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["173.245.48.0/20","103.21.244.0/22","103.21.244.0/22","103.21.244.0/22","141.101.64.0/18","108.162.192.0/18",
                        "190.93.240.0/20","188.114.96.0/20","188.114.96.0/20","188.114.96.0/20","162.158.0.0/15","162.158.0.0/15",
                        "162.158.0.0/15","172.64.0.0/13","172.64.0.0/13"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_cloudflare"
  }
}


//security group for mongo db
resource "aws_security_group" "mongo" {
  count	 = var.mongodb_enabled ? 1 : 0
  name   = "${local.tag_name}-mongo-sg"
  vpc_id = aws_vpc.main[0].id
  description = "mongo accessibility from local and ec2 instance"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["111.93.242.34/32"]
    //security_groups = [aws_security_group.asg_login[0].id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${local.tag_name}-mongo-sg"
  }
}
