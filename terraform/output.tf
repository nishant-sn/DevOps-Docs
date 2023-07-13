// VPC
output "VPC_Details" {
  description = "List of VPC's along with CIDR Block"
  value = var.vpc_enabled ? formatlist("%s - %s", aws_vpc.main[*].tags.Name, aws_vpc.main[*].cidr_block) : []
}

output "Public_Subnet" {
  description = "List of Public Subnets"
  value = var.pub_sub_enabled ? aws_subnet.pub_sub[*].tags.Name : []
}

output "Private_Subnet" {
  description = "List of Private Subnets"
  value = var.pvt_sub_enabled ? aws_subnet.pvt_sub[*].tags.Name : []
}

output "NAT_IP" {
 description = "The IP for NAT Gateway(s)"
 value = var.nat_enabled ? formatlist("%s - %s", aws_nat_gateway.ngw[*].tags.Name, aws_nat_gateway.ngw[*].public_ip) : []
}

// PEM File
output "pem_key" {
  description = "PEM file for accessing instance"
  value = var.pem_enabled ? nonsensitive(tls_private_key.pem[0].private_key_pem) : ""
  #sensitive = true
  depends_on = [
    aws_key_pair.deployer
  ]
}

// EC2
output "EC2_public_ip" {
  description = "Public IP of EC2 node(s)"
  value = var.ec2_enabled && !var.ec2_eip_required && (var.node_enabled || var.python_enabled)? formatlist("%s - %s", aws_instance.node_server[*].tags.Name, aws_instance.node_server[*].public_ip) : formatlist("%s - %s", aws_instance.node_server[*].tags.Name, aws_eip.ec2_node_eip[*].public_ip)
}

/*output "EC2_EIP" {
  description = "Elastic IP of EC2 node(s)"
  value = var.ec2_eip_required && var.ec2_eip_required ? formatlist("%s - %s", aws_instance.ec2_node[*].tags.Name, aws_eip.ec2_eip[*].public_ip) : []
  depends_on = [
    aws_eip.ec2_eip
  ]
}*/


// S3
output "S3" {
  description = "Bucket linked with EC2 instances / Launch template"
  value = var.ec2_s3_allowed ? aws_s3_bucket.s3_bucket[*].bucket_domain_name : []
}

// Launch Template
output "Launch_Template" {
  description = "Name, Latest Version of launch template"
  value = var.lt_enabled ? formatlist("%s - %s", aws_launch_template.ec2_template[*].tags.Name, aws_launch_template.ec2_template[*].latest_version) : []
}

// ASG
output "AutoScaling_Group_Detail" {
  description = "Name of ASG"
  value = var.asg_enabled ? aws_autoscaling_group.asg[*].name : []
}

// LB
output "Load_Balancer" {
  value = var.lb_enabled && var.lb_type == "application" ? aws_lb.alb[*].dns_name : var.lb_enabled && var.lb_type == "network" ? aws_lb.nlb[*].dns_name : []
}

//RDS
output "RDS_Info" {
  description = "RDS Endpoint, DB Engine, Username"
  value = var.rds_enabled ? formatlist("Endpoint - %s \n DB Engine - %s \n Username - %s", aws_db_instance.rds_instance[*].endpoint, aws_db_instance.rds_instance[*].engine, aws_db_instance.rds_instance[*].username ) : []
}

output "RDS_ARN" {
  description = "RDS ARN"
  value = var.rds_enabled ? aws_db_instance.rds_instance[*].arn : [] 
}

output "RDS_PG_Connection_String" {
  description = "Connection string for RDS PG Instance"
  value = var.rds_enabled && var.rds_engine == "postgres" ? formatlist("-h %s -p %s -U %s postgres", aws_db_instance.rds_instance[*].address, aws_db_instance.rds_instance[*].port, aws_db_instance.rds_instance[*].username) : []
}

//CloudTrail
output "CloudTrail" {
  description = "CloudTrail Name"
  value = var.trail_enabled ? aws_cloudtrail.cloudtrail[*].id : []
}
//CloudFront
output "CloudFront_Domain" {
  description = "CloudFront's Domain"
  value = var.cf_enabled ? aws_cloudfront_distribution.cf[*].domain_name : []
}
//CloudWatch
output "CloudWatch" {
  description = "CloudWatch's log group name"
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.log_group[*].tags.Name : []
}

//Alarm


//SNS  
output "SNS_Topic" {
  description = "SNS Topic Names"
  value = var.sns_enabled ? var.sns_topic_name : []
  depends_on = [
    aws_sns_topic.sns_topic
  ] 
}

output "SNS_ARN" {
  description = "SNS Topic Names"
  value = var.sns_enabled ? aws_sns_topic.sns_topic[*].arn : [] 
}

//SQS
output "SQS_URL" {
  description = "URL of SQS Queues"
  value = var.sqs_enabled ? aws_sqs_queue.sqs_queue[*].url : []
}

output "SQS_ARN" {
  description = "ARN of SQS Queues"
  value = var.sqs_enabled ? aws_sqs_queue.sqs_queue[*].arn : []
}

//API
output "API_Gateway_Endpoint" {
  description = "API Gateway Endpoint"
  value = var.api_gateway_enabled ? aws_apigatewayv2_api.api_gateway[*].api_endpoint : []
}

output "API_Gateway_ARN" {
  description = "API Gateway ARN"
  value = var.api_gateway_enabled ? aws_apigatewayv2_api.api_gateway[*].arn : []
}

//EventBridge
output "EventBridge_arn" {
  value = var.eventbridge_enabled ? aws_cloudwatch_event_bus.eventbus[*].arn : []
}

//ServerLess
output "Details_for_Serverless"{
  value = var.serverless_enabled ? "The access key, secret key for user ${var.serverless_iam_user_name} is ${aws_iam_access_key.serverless[0].id} and ${nonsensitive(aws_iam_access_key.serverless[0].secret)} respectively.\nThe id for serverless security group is ${aws_security_group.serverless_sg[0].id}" : ""
}

output "pvt_subnet_id" {
  description = "The id for available private subnets"
  value = var.vpc_enabled ? aws_subnet.pvt_sub[*].id : []
}

output "MongoDB_Host" {
  description = "Host of mongodb"
  value = var.mongodb_enabled  ? formatlist("%s - %s", aws_instance.mongo[*].tags.Name, aws_eip.mongo[*].public_ip) : formatlist("%s - %s", aws_instance.mongo[*].tags.Name, aws_eip.mongo[*].public_ip)
}