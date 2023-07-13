resource "aws_cloudwatch_log_group" "log_group" {
  count = var.cloudwatch_enabled ? 1 : 0
  name = var.cloudwatch_log_group
  retention_in_days = 1
  tags = {
    Name = "${local.tag_name}-log-group-${count.index+1}"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  count = var.cloudwatch_enabled ? length(var.cloudwatch_log_stream) : 0
  name           = var.cloudwatch_log_stream[count.index]
  log_group_name = aws_cloudwatch_log_group.log_group[0].name
}

