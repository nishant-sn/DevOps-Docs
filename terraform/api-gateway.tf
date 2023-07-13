resource "aws_apigatewayv2_api" "api_gateway" {
  count                  = var.api_gateway_enabled ? 1 : 0
  name                   = var.api_gateway_name
  protocol_type          = var.api_gateway_type
}