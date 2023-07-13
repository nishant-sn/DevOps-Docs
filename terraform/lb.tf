resource "aws_autoscaling_attachment" "asg_lb_attachment" {
  count = var.asg_enabled && var.lb_enabled ? min(length(var.lb_name),var.asg_count) : 0
  autoscaling_group_name = aws_autoscaling_group.asg[count.index].id  
  lb_target_group_arn   = aws_lb_target_group.tg[count.index].arn
}

resource "aws_lb" "alb" {
  count = var.lb_enabled && var.lb_type == "application" ? length(var.lb_name) : 0
  name = var.lb_name[count.index]
  internal = var.lb_internal[count.index]
  load_balancer_type = var.lb_type
  subnets            = var.lb_internal[count.index] == true ? [aws_subnet.pvt_sub[0].id,aws_subnet.pvt_sub[1].id] : [aws_subnet.pub_sub[0].id,aws_subnet.pub_sub[1].id]
  security_groups = [aws_security_group.elb[0].id]
}

resource "aws_lb" "nlb" {
  count = var.lb_enabled && var.lb_type == "network" ? length(var.lb_name) : 0 
  name = var.lb_name[count.index]
  internal = var.lb_internal[count.index]
  load_balancer_type = var.lb_type
  subnets            = var.lb_internal[count.index] == true ? [aws_subnet.pvt_sub[0].id,aws_subnet.pvt_sub[1].id] : [aws_subnet.pub_sub[0].id,aws_subnet.pub_sub[1].id]
}

resource "aws_lb_listener" "lb_listener" {
  count             = var.lb_enabled ? length(var.lb_name) : 0
  load_balancer_arn = var.lb_type == "application" ? aws_lb.alb[count.index].arn : aws_lb.nlb[count.index].arn
  port              = "80"
  protocol          = var.lb_listener_protocol
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[count.index].arn
  }
  tags = {
    Name  = "${local.tag_name}-listener"
  }
}

resource "aws_lb_target_group" "tg" {
  count    = var.lb_enabled ? length(var.lb_name) : 0
  name     = "${local.tag_name}-tg"
  port     = var.sg_app_port
  target_type = "instance"
  protocol = var.lb_listener_protocol
  vpc_id   = aws_vpc.main[0].id
}

//resource "aws_lb_target_group_attachment" "lb_tg_attachment" {
//  target_group_arn = aws_lb_target_group.tg.arn
//  target_id        = aws_instance.ec2_node.id
//  port             = var.app_port
//}
