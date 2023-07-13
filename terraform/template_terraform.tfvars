// Provider Config
region = <region>
access_key = <access_key>
secret_key = <secret_key>

// Project Detail
project_name = <project_name>
project_slug = <project_slug>
project_type = "none"
env = <env>

//Network Config
vpc_enabled = <vpc_enabled>
vpc_cidr = <vpc_cidr>

pub_sub_enabled = <pub_sub_enabled>
pub_sub_cidr = <pub_sub_cidr>

pvt_sub_enabled = <pvt_sub_enabled>
pvt_sub_cidr = <pvt_sub_cidr>

igw_enabled = <igw_enabled>

nat_enabled = <nat_enabled>

// Instance Detail
ec2_enabled = <ec2_enabled>
ec2_count = <ec2_count>
ec2_ami = <ec2_ami>
ec2_instance_type = <ec2_instance_type>
ec2_delete_disk_on_termination = <ec2_delete_disk_on_termination>
ec2_instance_volume_size = <ec2_instance_volume_size>
ec2_instance_volume_type = <ec2_instance_volume_type>
ec2_s3_allowed = <ec2_s3_allowed>
ec2_eip_required = <ec2_eip_required>

//tech stack
node_enabled = <node_enabled>
python_enabled = <python_enabled>
node_version = <node_version>
python_version = <python_version>


// PEM File
pem_enabled = <pem_enabled>

// Security Group
sg_enabled = <sg_enabled>
sg_app_enabled = <sg_app_enabled>
sg_app_port = <sg_app_port>

// s3 Detail
s3_enabled = <s3_enabled>
s3_bucket_name = <s3_bucket_name>

//Launch Template
lt_enabled = <lt_enabled>
lt_count = <lt_count>
lt_instance_ami = <lt_instance_ami>
lt_instance_type = <lt_instance_type>
lt_instance_disk_device_name = <lt_instance_disk_device_name>
lt_delete_disk_on_termination = <lt_delete_disk_on_termination>
lt_instance_volume_size = <lt_instance_volume_size>
lt_instance_volume_type = <lt_instance_volume_type>

// Autoscaling Group detail
asg_enabled = <asg_enabled>
asg_count = <asg_count>
asg_instance_desired_count = <asg_instance_desired_count>
asg_instance_min_count = <asg_instance_min_count>
asg_instance_max_count = <asg_instance_max_count>
asg_time_zone = <asg_time_zone>
asg_scheduled_actions_enabled = <asg_scheduled_actions_enabled>
asg_off_time = <asg_off_time>
asg_on_time = <asg_on_time>
asg_off_cron = <asg_off_cron>
asg_on_cron = <asg_on_cron>
asg_threshold = <asg_threshold>

// Load Balancer
lb_enabled = <lb_enabled>
lb_count = <lb_count>
lb_internal =  <lb_internal>
lb_name = <lb_name>
lb_type = <lb_type>
lb_listener_protocol = <lb_listener_protocol>


// Relational DB Service 
rds_enabled = <rds_enabled>
rds_count = <rds_count>
rds_family = <rds_family>
rds_engine  = <rds_engine>
rds_engine_version  = <rds_engine_version>
rds_instance_class  = <rds_instance_class>
rds_identifier = <rds_identifier>
rds_username  = <rds_username>
rds_password  = <rds_password>
rds_port = <rds_port>
rds_public_accessibility  = <rds_public_accessibility>
rds_skip_final_snapshot = <rds_skip_final_snapshot>
rds_allocated_storage = <rds_allocated_storage>
rds_max_allocated_storage = <rds_max_allocated_storage>
rds_instant_changes = <rds_instant_changes>

// CloudTrail's Detail
trail_enabled = <trail_enabled>
trail_name = <trail_name>
trail_bucket = <trail_bucket>

// CloudWatch's Detail
cloudwatch_enabled = <cloudwatch_enabled>
cloudwatch_log_group = <cloudwatch_log_group>
cloudwatch_log_stream =  <cloudwatch_log_stream>

// CloudWatch Instance Metric
cloudwatch_metric_alarm_enabled = <cloudwatch_metric_alarm_enabled>
cloudwatch_alert_subscribers_email = <cloudwatch_alert_subscribers_email>
ec2_alerts_enabled = <ec2_alerts_enabled>
ec2_alert_rules = <ec2_alert_rules>
rds_alerts_enabled = <rds_alerts_enabled>
rds_alert_rules = <rds_alert_rules>

// CloudFront's Detail
cf_enabled = <cf_enabled>
cf_bucket_name = <cf_bucket_name>

// Simple Queue Service
sqs_enabled = <sqs_enabled>
sqs_queue_name = <sqs_queue_name>
sqs_queue_type = <sqs_queue_type>

// Simple Notification Service
sns_enabled = <sns_enabled>
sns_topic_name = <sns_topic_name>
sns_topic_type = <sns_topic_type>
sns_subscriber_email = <sns_subscriber_email>

// API Gateway
api_gateway_enabled = <api_gateway_enabled>
api_gateway_name = <api_gateway_name>
api_gateway_type = <api_gateway_type>

//EventBridge
eventbridge_enabled = <eventbridge_enabled>
event_bus_name = <event_bus_name>

//ServerLess
serverless_enabled = <serverless_enabled>
serverless_iam_user_name = <serverless_iam_user_name>
serverless_ing_rules = <serverless_ing_rules>

//frontend build pipelien

fe_build_enabled = <fe_build_enabled>
fe_codebuild_name = <fe_codebuild_name>
fe_codepipeline_name = <fe_codepipeline_name>
angular_build_enabled = <angular_build_enabled>
angular_codebuild_name = <angular_codebuild_name>
angular_codepipeline_name = <angular_codepipeline_name>
flutter_build_enabled = <flutter_build_enabled>
flutter_codebuild_name = <flutter_codebuild_name>
flutter_codepipeline_name = <flutter_codepipeline_name>

fe_pipeline_source_bucket_name = <fe_pipeline_source_bucket_name>
fe_build_logs_bucket_name = <fe_build_logs_bucket_name>
fe_codstarconnection_name = <fe_codstarconnection_name>
fe_env_vars = <fe_env_vars>
fe_repository_name = <fe_repository_name>
fe_repository_branch = <fe_repository_branch>



//backend build pipeline
be_build_enabled = <be_build_enabled>
be_codebuild_name = <be_codebuild_name>
be_build_logs_bucket_name = <be_build_logs_bucket_name>
be_pipeline_source_bucket_name = <be_pipeline_source_bucket_name>
be_codestarconnection_name = <be_codestarconnection_name>
be_codepipeline_name = <be_codepipeline_name>
be_env_vars = <be_env_vars>
deployment_gp_name = <deployment_gp_name>
app_name = <app_name>
be_repository_name = <be_repository_name>
be_repository_branch = <be_repository_branch>

//cloudflare
cloudflare_enabled = <cloudflare_enabled>

//mongoDB
mongodb_enabled = <mongodb_enabled>
mongodb_count = <mongodb_count>
mongodb_instance_type = <mongodb_instance_type>
mongodb_user = <mongodb_user>
mongodb_pass = <mongodb_pass>
mongodb_database = <mongodb_database>

//serverlessdeployment
sl_deploy_enabled = <sl_deploy_enabled>

sl_node_deploy = <sl_node_deploy>
sl_python_deploy = <sl_python_deploy>

sl_nodedeploy_name = <sl_nodedeploy_name>
sl_pythondeploy_name = <sl_pythondeploy_name>

sl_nodecodepipeline_name = <sl_nodecodepipeline_name>
sl_pythoncodepipeline_name = <sl_pythoncodepipeline_name>

sl_be_build_logs_bucket_name = <sl_be_build_logs_bucket_name>
sl_pipeline_source_bucket_name = <sl_pipeline_source_bucket_name>
sl_be_env_vars = <sl_be_env_vars>
sl_be_codestarconnection_name = <sl_be_codestarconnection_name>


sl_repository_name = <sl_repository_name>
sl_repository_branch = <sl_repository_branch>

//wordpress
ubuntu18 = <ubuntu18>
ubuntu20 = <ubuntu20>
wordpress_enabled = <wordpress_enabled>
php_version = <php_version>
php_enabled = <php_enabled>
rds_user = <rds_user>
rds_pass = <rds_pass>
DB_NAME = <DB_NAME>
DB_USER = <DB_USER>
DB_PASSWORD = <DB_PASSWORD>
mysql_enabled = <mysql_enabled>


>