resource "aws_sqs_queue" "sqs_queue" {
  count = var.sqs_enabled ? length(var.sqs_queue_name) : 0
  name = var.sqs_queue_type[count.index] == "fifo" ? "${var.sqs_queue_name[count.index]}.fifo" : var.sqs_queue_name[count.index]
  fifo_queue = var.sqs_queue_type[count.index] == "fifo" ? true : false
  visibility_timeout_seconds = 30
  message_retention_seconds = 345600
  max_message_size = 262144
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  count = var.sqs_enabled ? length(var.sqs_queue_name) : 0
  queue_url = aws_sqs_queue.sqs_queue[count.index].id
  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "sqs_policy",
  "Statement": [
    {
      "Sid": "allow_${aws_sns_topic.sns_topic[count.index].name}_to_send_msg_to_${aws_sqs_queue.sqs_queue[count.index].name}",
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": [
        "SQS:SendMessage"
      ],
      "Resource": "${aws_sqs_queue.sqs_queue[count.index].arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.sns_topic[count.index].arn}"
        }
      }      
    }
  ]
}
POLICY  
}
