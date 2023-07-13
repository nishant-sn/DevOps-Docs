// Provider Config
variable "region" {type = string}
variable "access_key" {type = string}  
variable "secret_key" {type = string}  

// Project Detail
variable "project_name" {type = string}  
variable "project_slug" {type = string}
variable "project_type" {type = string}  
variable "env" {type = string}  

// Network Config
variable "vpc_enabled" {type = bool}
variable "vpc_cidr" {type = string}
variable "pub_sub_enabled" {type = bool}
variable "pub_sub_cidr" {type = list(string)}  
variable "pvt_sub_enabled" {type = bool}
variable "pvt_sub_cidr" {type = list(string)}
variable "igw_enabled" {type = bool}
variable "nat_enabled" {type = bool}


// Instance Detail
variable "ec2_enabled" {type = bool}
variable "ec2_count" {type = number}
variable "ec2_ami" {
  type        = list(string)
  description = "The id of the machine image (AMI) to use for the server."
}  
variable "ec2_instance_type" {type = list(string)}  
//variable "ec2_monitoring" {}
variable "ec2_delete_disk_on_termination" {type = bool}
variable "ec2_instance_volume_size" {type = number}  
variable "ec2_instance_volume_type" {type = string}
variable "ec2_s3_allowed" {type = bool}
variable "ec2_eip_required" {type = bool}

//techstack
variable "node_enabled" {type = bool}
variable "node_version" {type = string}
variable "python_version" {type = string}
variable "python_enabled" {type = bool}

// PEM File
variable "pem_enabled" {type = bool}

// Security Group
variable "sg_enabled" {type = bool} 
variable "sg_app_enabled" {type = bool} 
variable "sg_app_port" {type = string}  

//S3
variable "s3_enabled" {type = bool}
variable "s3_bucket_name" {type = list(string)}  

// App Detail
//variable "angular_version" {type = number}  

// Launch Template
variable "lt_enabled" {type = bool}
variable "lt_count" {type = number}
variable "lt_instance_ami" {
  type        = list(string)
  description = "The id of the machine image (AMI) to use for the server."
}  
variable "lt_instance_type" {type = list(string)}
variable "lt_instance_disk_device_name" {type = string}
variable "lt_delete_disk_on_termination" {type = bool}
variable "lt_instance_volume_size" {type = number}  
variable "lt_instance_volume_type" {type = string}

// Autoscaling Group
variable "asg_enabled" {type = bool}
variable "asg_count" {type = number}
variable "asg_instance_desired_count" {type = number}  
variable "asg_instance_min_count" {type = number}  
variable "asg_instance_max_count" {type = number}  
variable "asg_time_zone" {type = string}
variable "asg_scheduled_actions_enabled" {type = bool}
variable "asg_on_time" {type = string}
variable "asg_off_time" {type = string}
variable "asg_on_cron" {type = string}
variable "asg_off_cron" {type = string}
variable "asg_threshold" {type = number}  

// Load Balancer
variable "lb_enabled" {type = bool}
variable "lb_count" {type = number}
variable "lb_internal" {type = list(bool)}
variable "lb_name" {type = list(string)}
variable "lb_type" {type = string}
variable "lb_listener_protocol" {type = string}

// RDS
variable "rds_enabled" {type = bool}
variable "rds_count" {type = number}
variable "rds_family" {type = string}
variable "rds_identifier" {type = list(string)}
variable "rds_instance_class" {type = string}
variable "rds_username" {type = list(string)}
variable "rds_password" {
  sensitive = true
  type = list(string)
}
variable "rds_port" {type = number}
variable "rds_public_accessibility" {type = bool}
variable "rds_skip_final_snapshot" {type = bool}
variable "rds_engine" {type = string}
variable "rds_engine_version" {type = string}
variable "rds_allocated_storage" {type = number}
variable "rds_max_allocated_storage" {type = number}
variable "rds_instant_changes" {type = bool}

// Cloudtrail
variable "trail_enabled" {type = bool}
variable "trail_name" {type = list(string)}
variable "trail_bucket" {type = string}

// CloudWatch
variable "cloudwatch_enabled" {type = bool}
variable "cloudwatch_log_group" {type = string}
variable "cloudwatch_log_stream" {type = list(string)}

//Cloudwatch Alarm
variable "cloudwatch_metric_alarm_enabled" {type = bool}
variable "cloudwatch_alert_subscribers_email" {type = list(string)}
variable "ec2_alerts_enabled" {type = bool}
variable "ec2_alert_rules" {
  type = list(object({
    alertname = string
    metrics = string
    desc = string
    statistics = string
    comparison_operator = string
    threshold = number
    period = string
  }))
}

variable "rds_alerts_enabled" {type = bool}
variable "rds_alert_rules" {
  type = list(object({
    alertname = string
    metrics = string
    desc = string
    statistics = string
    comparison_operator = string
    threshold = number
    period = string
  }))
}

//CloudFront
variable "cf_enabled" { type = bool }
variable "cf_bucket_name" {type = string}

// SQS
variable "sqs_enabled" { type = bool }
variable "sqs_queue_name" {type = list(string)}
variable "sqs_queue_type" {type = list(string)}

// SNS
variable "sns_enabled" { type = bool }
variable "sns_topic_name" {type = list(string)}
variable "sns_topic_type" {type = list(string)}
variable "sns_subscriber_email" {type = list(string)}

// API Gateway
variable "api_gateway_enabled" {type = bool}
variable "api_gateway_name" {type = string}
variable "api_gateway_type" {type = string}

//EventBridge
variable "eventbridge_enabled" {type = bool}
variable "event_bus_name" {type = list(string)}

//ServerLess
variable "serverless_enabled" {type = bool}
variable "serverless_iam_user_name" {type = string}
variable "serverless_ing_rules" {
  type = list(object({
    port = number
    cidr_block = list(string)
    desc = string    
  }))
}

//FE_CICD

variable "fe_build_enabled"{type = bool}
variable "fe_codebuild_name" {type = list(string)}
variable "fe_codepipeline_name"{type = list(string)}
variable "angular_build_enabled"{type = bool}
variable "angular_codebuild_name" {type = list(string)}
variable "angular_codepipeline_name"{type = list(string)}
variable "flutter_build_enabled" {type = bool}
variable "flutter_codebuild_name" {type = list(string)}
variable "flutter_codepipeline_name"{type = list(string)}


variable "fe_build_logs_bucket_name" {type = list(string)}
variable "fe_pipeline_source_bucket_name" {type = list(string)}
variable "fe_env_vars" {}
variable "fe_codstarconnection_name" {type = list(string)}
variable "fe_repository_name" {type = string}
variable "fe_repository_branch" {type = string}


//BE_CICD
variable "be_build_enabled"{type = bool}
variable "be_codebuild_name"{type = list(string)}
variable "be_build_logs_bucket_name" {type = list(string)}
variable "be_pipeline_source_bucket_name"{type = list(string)}
variable "be_env_vars" {}
variable "be_codestarconnection_name"{type = list(string)}
variable "be_codepipeline_name"{type = list(string)}
variable "deployment_gp_name"{type = list(string)}
variable "app_name"{type = list(string)}
variable "be_repository_name" {type = string}
variable "be_repository_branch" {type = string}

variable "cloudflare_enabled" {type=bool}


//MongoDB
variable "mongodb_enabled" {type = bool}
variable "mongodb_count" {type = number}
variable "mongodb_instance_type" {type = list(string)}
variable "mongodb_database" {type = string}
variable "mongodb_user" { type = string}
variable "mongodb_pass" {type = string}

//serverless deployment

variable "sl_deploy_enabled" {type = bool}

variable "sl_node_deploy" {type = bool}
variable "sl_python_deploy" {type = bool}

variable "sl_nodedeploy_name" {type = list(string)}
variable "sl_pythondeploy_name" {type = list(string)}

variable "sl_be_build_logs_bucket_name" {type = list(string)}
variable "sl_pipeline_source_bucket_name" {type = list(string)}
variable "sl_be_env_vars" {}
variable "sl_be_codestarconnection_name" {type = list(string)}

variable "sl_nodecodepipeline_name" {type = list(string)}
variable "sl_pythoncodepipeline_name" {type = list(string)}

variable "sl_repository_name" {type = string}
variable "sl_repository_branch" {type = string}


//wordpress
variable "ubuntu18" {type = bool}
variable "ubuntu20" {type = bool}
variable "wordpress_enabled" {type = bool }
variable "php_version" {type = string}
variable "php_enabled" {type = bool}
variable "rds_user" {type = string}
variable "rds_pass" {type = string}
variable "DB_NAME" {type = string}
variable "DB_USER" {type = string}
variable "DB_PASSWORD" {type = string}
variable "mysql_enabled" {type = bool}

