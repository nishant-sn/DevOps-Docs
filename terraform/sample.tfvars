// Provider Config
region = "us-east-1"
access_key = ""
secret_key = ""

// Project Detail
project_name = "test"
project_slug = "node"
project_type = "backend"
env = "dev"

//Network Config
vpc_enabled = true
vpc_cidr = "10.0.0.0/16"

pub_sub_enabled = true
pub_sub_cidr = ["10.0.1.0/24","10.0.3.0/24"]

pvt_sub_enabled = true
pvt_sub_cidr = ["10.0.2.0/24", "10.0.0.0/24"]

igw_enabled = true

nat_enabled = false

// Instance Detail
ec2_enabled = false
ec2_count = 1
ec2_ami = ["ami-04505e74c0741db8d"]
ec2_instance_type = ["t2.micro"]
ec2_delete_disk_on_termination = true
ec2_instance_volume_size = 20
ec2_instance_volume_type = "gp2"
ec2_s3_allowed = false
ec2_eip_required = false

//techstack
node_enabled = false
python_enabled = false
python_version = "3.8"
node_version = "14"
// PEM File
pem_enabled = true

// Security Group
sg_enabled = false
sg_app_enabled = false
sg_app_port = "80"

// s3 Detail
s3_enabled = false
s3_bucket_name = ["test-suraj-20211004"]

//Launch Template
lt_enabled = false
lt_count = 1
lt_instance_ami = ["ami-0851b76e8b1bce90b"]
lt_instance_type = ["t2.micro"]
lt_instance_disk_device_name = "/dev/sda2"
lt_delete_disk_on_termination = true
lt_instance_volume_size = 8
lt_instance_volume_type = "gp2"

// Autoscaling Group detail
asg_enabled = false
asg_count = 1
asg_instance_desired_count = 1
asg_instance_min_count = 1
asg_instance_max_count = 2
asg_time_zone = "Asia/Kolkata"
asg_scheduled_actions_enabled = false
asg_off_time = "2022-01-29T22:00:00Z"
asg_on_time = "2022-01-27T08:00:00Z"
asg_off_cron = "0 22 * * *"
asg_on_cron = "0 8 * * *"
asg_threshold = 70

// Load Balancer
lb_enabled = false
lb_count = 1
lb_internal = [false]
lb_name = ["my-alb"]
lb_type = "application"
lb_listener_protocol = "HTTP"


// Relational DB Service 
rds_enabled = false
rds_count = 1
rds_family = "postgres12"//"mysql5.7" //"mariadb10.6"
rds_engine  = "postgres" //"mysql" //"mariadb"
rds_engine_version  = "5.7" //"12.7" //"5.7" //"10.6"
rds_instance_class  = "db.t2.micro"
rds_identifier = ["algoworks"]
rds_username  = ["algoworks"]
rds_password  = ["algoworks"]
rds_port =  5432//3306
rds_public_accessibility  = true
rds_skip_final_snapshot = true
rds_allocated_storage = 5
rds_max_allocated_storage = 10
rds_instant_changes = true

// CloudTrail's Detail
trail_enabled = false
trail_name = []
trail_bucket = "cloudtrail-bucket-suraj-test"

// CloudWatch's Detail
cloudwatch_enabled = false
cloudwatch_log_group = "cw-lg"
cloudwatch_log_stream = ["log1","log2","log3"]

// CloudWatch Instance Metric
cloudwatch_metric_alarm_enabled = false
cloudwatch_alert_subscribers_email = []
ec2_alerts_enabled=false
ec2_alert_rules=[{alertname = "OverUtilization", desc = "To monitor CPU Utilization of ec2", metrics = "CPUUtilization", statistics = "Average", comparison_operator = "GreaterThanOrEqualToThreshold", threshold = 5, period = "60" }]
rds_alerts_enabled=false
rds_alert_rules=[{alertname = "Connection Count", desc = "To determines the number of database connections in use", metrics = "DatabaseConnection", statistics = "Average", comparison_operator = "GreaterThanOrEqualToThreshold", threshold = 200, period = "60" }]

// CloudFront's Detail
cf_enabled = false
cf_bucket_name = "hp-web-panel"

// Simple Queue Service
sqs_enabled = false
sqs_queue_name = ["my-queue-1"]
sqs_queue_type = ["standard"]

// Simple Notification Service
sns_enabled = false
sns_topic_name = ["my-topic-1"]
sns_topic_type = ["standard"]
sns_subscriber_email = ["suraj.singh@algoworks.com"]

// API Gateway
api_gateway_enabled = false
api_gateway_name = "ag-1"
api_gateway_type = "HTTP"

//EventBridge
eventbridge_enabled = false
event_bus_name = ["chat-messages"]

//ServerLess
serverless_enabled = false
serverless_iam_user_name = "serverless"
serverless_ing_rules = [{port = 8000,cidr_block = ["0.0.0.0/0"],desc = "For accessing application"}]

//frontend build pipeline
fe_build_enabled = false
fe_codebuild_name = ["frontend"]
fe_build_logs_bucket_name = ["frontend-buildlogs-bucket-algoworks"]
fe_pipeline_source_bucket_name = ["frontend-source-bucket-algoworks"]
fe_env_vars = {
        key1 = "value"
        key2 = "value"
        }
fe_codstarconnection_name = ["frontend"]
fe_codepipeline_name = ["Hp-webpanel-prod-codepipeline"]
fe_repository_name = "algoworks-dev/equine-flutter-frontend"
fe_repository_branch = "ajeet_dev_web"

angular_build_enabled = false
angular_codebuild_name = ["angular"]
angular_codepipeline_name = ["angular"]
flutter_build_enabled = false
flutter_codebuild_name = ["Hp-webpanel-prod-codebuild"]
flutter_codepipeline_name = ["Hp-webpanel-prod-codepipeline"]


//backend build pipeline
be_build_enabled = false
be_codebuild_name = ["backend"]
be_build_logs_bucket_name = ["backend-buildlogs-bucket-algoworks"]
be_pipeline_source_bucket_name = ["backend-source-bucket-algoworks"]
be_env_vars = {
        key1 = "value"
        key2 = "value"
        }
be_codestarconnection_name = ["backend"]
be_codepipeline_name = ["backend"]
deployment_gp_name = ["backend"]
app_name = ["backend"]
be_repository_name = "ram-jangra/angular1"
be_repository_branch = "nodejs"

//cloudflare
cloudflare_enabled = false

//mongodb
mongodb_enabled = false
mongodb_count = 1
mongodb_instance_type = ["t2.micro"]
mongodb_user = "algoworks"
mongodb_pass = "algoworks"
mongodb_database = "algoworks"

//serverless deployment
sl_deploy_enabled = false

sl_node_deploy = false
sl_python_deploy = false

sl_nodedeploy_name = ["serverless-node"]
sl_pythondeploy_name = ["serverless-python"]

sl_nodecodepipeline_name = ["serverless-nodepipeline"]
sl_pythoncodepipeline_name = ["serverless-pythonpipeline"]

sl_be_build_logs_bucket_name = ["serverless-algoworks-bucket"]
sl_pipeline_source_bucket_name = ["sercerless-algoworks-pipeline"]
sl_be_env_vars = {
        key1 = "value"
        key2 = "value"
        }
sl_be_codestarconnection_name = ["serverless-codestart-connection"]


sl_repository_name = "algoworks"
sl_repository_branch = "master"



//ami
ubuntu18 = false
ubuntu20 = true

//wordpress
wordpress_enabled = true
php_version = "8.0"
php_enabled = true
rds_user = "test"
rds_pass = "algoworks"
DB_NAME = "algoworks"
DB_USER = "algoworks"
DB_PASSWORD = "algoworks"
mysql_enabled = true

