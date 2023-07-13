resource "aws_autoscaling_group" "asg" {
  count = var.asg_enabled ? var.asg_count : 0
  name = "${local.tag_name}-asg-${count.index+1}"
  vpc_zone_identifier = aws_subnet.pvt_sub[*].id
  desired_capacity   = var.asg_instance_desired_count
  max_size           = var.asg_instance_max_count
  min_size           = var.asg_instance_min_count

  launch_template {
    id      = aws_launch_template.ec2_template[count.index].id
    version = aws_launch_template.ec2_template[count.index].latest_version
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_schedule" "non_prod_asg_down" {
  count = var.asg_enabled && var.asg_scheduled_actions_enabled ? var.asg_count : 0
  scheduled_action_name  = "${local.tag_name}-asg-scalein"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  start_time             = var.asg_off_time
  time_zone              = var.asg_time_zone
  recurrence             = var.asg_off_cron //"0 22 * * *"
  autoscaling_group_name = aws_autoscaling_group.asg[count.index].id
}

resource "aws_autoscaling_schedule" "non_prod_asg_up" {
  count = var.asg_enabled && var.asg_scheduled_actions_enabled ? var.asg_count : 0
  scheduled_action_name  = "${local.tag_name}-asg-scaleout"
  min_size               = var.asg_instance_min_count
  max_size               = var.asg_instance_max_count
  desired_capacity       = var.asg_instance_desired_count
  start_time             = var.asg_on_time
  time_zone              = var.asg_time_zone
  recurrence             = var.asg_on_cron  //"0 8 * * *"
  autoscaling_group_name = aws_autoscaling_group.asg[count.index].id
}

resource "aws_autoscaling_policy" "asg-policy" {
  count = var.asg_enabled ? var.asg_count : 0
  name                        = "asg-policy"
  policy_type                 = "TargetTrackingScaling"
  adjustment_type             = "ChangeInCapacity"
  estimated_instance_warmup   = "60"
  autoscaling_group_name      = aws_autoscaling_group.asg[count.index].name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.asg_threshold
  }
}
