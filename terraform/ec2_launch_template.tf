data "template_file" "user_data" {
  template = <<EOF
  #!/bin/bash
sudo apt update -y
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo apt install postgresql-client -y
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo apt -y install nodejs
sudo npm install pm2@latest -g
EOF
}


resource "aws_launch_template" "ec2_template" {
  count = var.lt_enabled ? var.lt_count : 0
  name = "${local.tag_name}-template-${count.index+1}"
 
  disable_api_termination = false
  
  block_device_mappings {
    device_name = var.lt_instance_disk_device_name
    ebs {
      delete_on_termination = var.lt_delete_disk_on_termination
      volume_size = var.lt_instance_volume_size
      volume_type = var.lt_instance_volume_type
    }
  }
  
user_data = "${base64encode(data.template_file.user_data.rendered)}"
#  iam_instance_profile {
#    name = aws_iam_instance_profile.ec2_s3_profile[0].name
#  }
 
  image_id = length(var.lt_instance_ami) == 1 ? var.lt_instance_ami[0] : var.lt_instance_ami[count.index]

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = length(var.lt_instance_type) == 1 ? var.lt_instance_type[0] : var.lt_instance_type[count.index]

  vpc_security_group_ids = var.sg_app_port != "" ? [aws_security_group.asg_login[0].id] : [aws_security_group.asg_login[0].id]
  key_name = aws_key_pair.deployer[0].id
  tags = {
    Name = "${local.tag_name}-launch-template-${count.index+1}"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.tag_name}-asg-instance-${count.index+1}"
      Created_through = "Launch_template"
      "Project Name" = var.project_name
      "Project Type" = var.project_type
      Environment = var.env
    }
  }
}
