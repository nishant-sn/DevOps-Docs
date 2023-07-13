resource "aws_sns_topic" "sns_topic" {
  count = var.sns_enabled ? length(var.sns_topic_name) : 0
  name = var.sns_topic_type[count.index] == "fifo" ? "${var.sns_topic_name[count.index]}.fifo" : var.sns_topic_name[count.index]
  fifo_topic = var.sns_topic_type[count.index] == "fifo" ? true : false
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
      "Resource": "",
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

resource "aws_sns_topic_subscription" "sns_sqs_subscription" {
  count     = var.sns_enabled && var.sqs_enabled ? 1 : 0
  topic_arn = aws_sns_topic.sns_topic[0].arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_queue[0].arn  
}

resource "aws_sns_topic_subscription" "sns_email_subscription" {
  count = var.sns_enabled ? length(var.sns_topic_name) : 0
  topic_arn = aws_sns_topic.sns_topic[count.index].arn
  protocol = "email"
  endpoint = var.sns_subscriber_email[0]
}


