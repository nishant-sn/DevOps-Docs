## SNS for Alarm Connection
resource "aws_sns_topic" "alarm_sns" {
  count = var.cloudwatch_metric_alarm_enabled && (var.ec2_alerts_enabled || var.rds_alerts_enabled) ? 1 : 0 
  name  = "${local.alarm_sns_topic_name}"
  fifo_topic = false
  content_based_deduplication = false
  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:Receive",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${local.alarm_sns_topic_name}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${data.aws_caller_identity.current.account_id}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "alarm_sns_lambda_subscription" {
  count     = var.cloudwatch_metric_alarm_enabled && (var.ec2_alerts_enabled || var.rds_alerts_enabled) ? 1 : 0
  topic_arn = aws_sns_topic.alarm_sns[0].arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.alarm_publisher[0].arn 
}

resource "aws_sns_topic_subscription" "alarm_sns_email_subscription" {
  count     = length(var.cloudwatch_alert_subscribers_email) > 0 && var.cloudwatch_metric_alarm_enabled && ( var.ec2_alerts_enabled || var.rds_alerts_enabled ) ? length(var.cloudwatch_alert_subscribers_email) : 0
  topic_arn = aws_sns_topic.alarm_sns[0].arn
  protocol  = "email"
  endpoint  = var.cloudwatch_alert_subscribers_email[count.index]
}

## EC2 ALARM

resource "aws_cloudwatch_metric_alarm" "ec2_alarm" {
  count                     = var.cloudwatch_metric_alarm_enabled && var.ec2_alerts_enabled ? length(var.ec2_alert_rules) : 0
  alarm_name                = var.ec2_alert_rules[count.index].alertname
  comparison_operator       = var.ec2_alert_rules[count.index].comparison_operator
  evaluation_periods        = "1"
  metric_name               = var.ec2_alert_rules[count.index].metrics
  namespace                 = "AWS/EC2"
  period                    = var.ec2_alert_rules[count.index].period
  statistic                 = var.ec2_alert_rules[count.index].statistics
  threshold                 = var.ec2_alert_rules[count.index].threshold
  alarm_description         = var.ec2_alert_rules[count.index].desc
  actions_enabled           = true
  alarm_actions		    = [aws_sns_topic.alarm_sns[0].arn]
  ok_actions		    = [aws_sns_topic.alarm_sns[0].arn]
  datapoints_to_alarm       = "1"
  treat_missing_data        = "ignore"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = "${element(aws_instance.node_server.*.id, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_alarm" {
  count                     = var.cloudwatch_metric_alarm_enabled && var.rds_alerts_enabled ? length(var.rds_alert_rules) : 0
  alarm_name                = var.rds_alert_rules[count.index].alertname
  comparison_operator       = var.rds_alert_rules[count.index].comparison_operator
  evaluation_periods        = "1"
  metric_name               = var.rds_alert_rules[count.index].metrics
  namespace                 = "AWS/RDS"
  period                    = var.rds_alert_rules[count.index].period
  statistic                 = var.rds_alert_rules[count.index].statistics
  threshold                 = var.rds_alert_rules[count.index].threshold
  alarm_description         = var.rds_alert_rules[count.index].desc
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.alarm_sns[0].arn]
  ok_actions                = [aws_sns_topic.alarm_sns[0].arn]
  datapoints_to_alarm       = "1"
  treat_missing_data        = "ignore"
  insufficient_data_actions = []
  dimensions = {
	DBInstanceIdentifier    = "${element(aws_db_instance.rds_instance.*.identifier, count.index)}"
  }
}

## Lambda for publishing Alert details to DB

resource "aws_lambda_permission" "sns_trigger_in_lambda" {
  count     = var.cloudwatch_metric_alarm_enabled && (var.ec2_alerts_enabled || var.rds_alerts_enabled) ? 1 : 0
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alarm_publisher[0].function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alarm_sns[0].arn
}

resource "aws_lambda_function" "alarm_publisher" {
  count     = var.cloudwatch_metric_alarm_enabled && (var.ec2_alerts_enabled || var.rds_alerts_enabled) ? 1 : 0
  filename      = "./lambda-pubisher.zip"
  function_name = "${local.alarm_lambda_name}"
  role          = aws_iam_role.lambda_alarm_role[0].arn
  handler       = "alert_publisher.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  #source_code_hash = filebase64sha256("./lambda_function_payload.zip")

  runtime = "python3.9"
#  depends_on = [
#    aws_cloudwatch_log_group.alarm_lambda_log_group,
#  ]
  environment {
    variables = {
        project = "${var.project_name}"
        env = "${var.env}"
	domain = "cloud.algoworks.com"
    }
  }
}
