resource "aws_cloudwatch_event_bus" "eventbus" {
  count = var.eventbridge_enabled ? length(var.event_bus_name) : 0
  name = var.event_bus_name[count.index]
} 
