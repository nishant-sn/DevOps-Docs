/*resource "aws_instance" "laravel_server" {
  count             = var.ec2_enabled && var.php_enabled ? var.ec2_count : 0
  #ami               = length(var.ec2_ami) == 1 ? var.ec2_ami[0] : var.ec2_ami[count.index]
  ami = data.aws_ami.ubuntu.id
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
  user_data       = templatefile("laravel.sh",{php_version = var.php_version})
  tags = {
    Name = "${local.tag_name}-instance-${count.index+1}"
    Created_through = "terraform"
  }
  key_name = aws_key_pair.deployer[0].id
}*/

/*resource "aws_eip" "ec2_laravel_eip" {
  count = var.ec2_enabled && var.ec2_eip_required ? var.ec2_count : 0
  vpc = true
  instance = aws_instance.laravel_server[count.index].id
  tags = {
    Name = "${local.tag_name}-instance-${count.index+1}-eip"
  }
}*/