data "aws_ami" "ubuntu20" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

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



resource "aws_instance" "node_server" {
  count         = var.ec2_enabled && var.node_enabled ? var.ec2_count : 0
  ami           = var.ubuntu18 == true && var.ubuntu20 ==false ? data.aws_ami.ubuntu18.id : data.aws_ami.ubuntu20.id
  instance_type = length(var.ec2_instance_type) == 1 ? var.ec2_instance_type[0] : var.ec2_instance_type[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  subnet_id = aws_subnet.pub_sub[count.index % length(var.pub_sub_cidr)].id
  root_block_device {    
    delete_on_termination = var.ec2_delete_disk_on_termination
    volume_size = var.ec2_instance_volume_size
    volume_type = var.ec2_instance_volume_type
    tags = {
      Name = "${local.tag_name}-ebs-${count.index+1}"
    }
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile[0].name

  //length(var.s3_bucket_name) != 0 ? iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile[0].name : ""
  vpc_security_group_ids = var.sg_app_enabled ? [aws_security_group.allow_login[0].id, aws_security_group.allow_app_traffic[0].id] : [aws_security_group.allow_login[0].id]
  user_data       = templatefile("userdata/node.sh",{node_version = var.node_version})
  tags = {
    Name = "${local.tag_name}-instance-${count.index+1}"
    Created_through = "terraform"
  }
  key_name = aws_key_pair.deployer[0].id
}

resource "aws_instance" "python_server" {
  count             = var.ec2_enabled && var.python_enabled ? var.ec2_count : 0
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

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile[0].name

  //length(var.s3_bucket_name) != 0 ? iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile[0].name : ""
  vpc_security_group_ids = var.sg_app_enabled ? [aws_security_group.allow_login[0].id, aws_security_group.allow_app_traffic[0].id] : [aws_security_group.allow_login[0].id]
  user_data       = templatefile("userdata/python.sh",{python_version = var.python_version})
  tags = {
    Name = "${local.tag_name}-instance-${count.index+1}"
    Created_through = "terraform"
  }
  key_name = aws_key_pair.deployer[0].id
}



resource "aws_eip" "ec2_node_eip" {
  count = var.ec2_enabled && var.ec2_eip_required && var.node_enabled  ? var.ec2_count : 0
  vpc = true
  instance = aws_instance.node_server[count.index].id
  tags = {
    Name = "${local.tag_name}-instance-${count.index+1}-eip"
  }
}

resource "aws_eip" "ec2_python_eip" {
  count = var.ec2_enabled && var.ec2_eip_required && var.python_enabled ? var.ec2_count : 0
  vpc = true
  instance = aws_instance.python_server[count.index].id
  tags = {
    Name = "${local.tag_name}-instance-${count.index+1}-eip"
  }
}

