locals {
  tag_name = "${var.env}-${var.project_slug}"
  alarm_sns_topic_name = "Cloudwatch-Lambda-Topic"
  alarm_lambda_name = "cloudwatch_alarm_publisher"
}
