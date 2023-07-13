//Required for subnet creation
data "aws_availability_zones" "available" {}

//Required for Cloudtrail
data "aws_caller_identity" "current" {}

