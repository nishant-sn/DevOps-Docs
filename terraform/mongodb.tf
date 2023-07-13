data "aws_ami" "ubuntu18" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]

  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

 data "template_file" "mongo"{
  template = file("userdata/mongo.sh")
  vars = {
    mongodb_user = var.mongodb_user
    mongodb_pass = var.mongodb_pass
    mongodb_database = var.mongodb_database
  }
  }

resource "aws_instance" "mongo" {
  count         = var.mongodb_enabled ? var.mongodb_count : 0
  ami           = var.ubuntu18 == true && var.ubuntu20 == false ? data.aws_ami.ubuntu18.id : data.aws_ami.ubuntu20.id
  instance_type = length(var.mongodb_instance_type) == 1 ? var.mongodb_instance_type[0] : var.mongodb_instance_type[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  subnet_id = aws_subnet.pub_sub[count.index % length(var.pub_sub_cidr)].id
  root_block_device {    
    delete_on_termination = true
    volume_size = 20
    volume_type = "gp2"
    tags = {
      Name = "mongo-${count.index+1}"
    }
  }

  
  vpc_security_group_ids = [aws_security_group.allow_login[0].id, aws_security_group.mongo[0].id]

  
  user_data = data.template_file.mongo.rendered

  tags = {
    Name = "${local.tag_name}-mongoDB-${count.index+1}"
    Created_through = "terraform"
  }
  key_name = aws_key_pair.deployer[0].id
}

resource "aws_eip" "mongo" {
  count = var.mongodb_enabled ? 1 : 0
  vpc = true
  instance = aws_instance.mongo[count.index].id
  tags = {
    Name = "mongo-${count.index+1}-eip"
  }
}

