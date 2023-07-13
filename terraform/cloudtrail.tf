resource "aws_cloudtrail" "cloudtrail" {
  count                         = var.trail_enabled ? length(var.trail_name) : 0
  name                          = var.trail_name[count.index]
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket[0].id
  include_global_service_events = true
  //cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.yada.arn}:*"
  enable_logging                = true
  event_selector {
    read_write_type             = "All"
    include_management_events   = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }  
}

resource "aws_s3_bucket" "cloudtrail_bucket" { 
  count         = var.trail_enabled ? 1 : 0
  bucket        = var.trail_bucket
  force_destroy = true
  //acl    = "private"

  /*policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck20150319",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.trail_bucket}"
    },
    {
      "Sid": "AWSCloudTrailWrite20150319",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.trail_bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Condition": {
        "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
POLICY*/
}
