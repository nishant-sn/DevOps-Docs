resource "aws_s3_bucket" "s3_bucket" {
  count  = var.s3_enabled ? length(var.s3_bucket_name) : 0
  bucket = var.s3_bucket_name[count.index]
  //acl    = "private"

  tags = {
    Name        = var.s3_bucket_name[count.index]
  }
}


//frontend codebuild logs bucket
resource "aws_s3_bucket" "fe_build_logs" {
count = (var.fe_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) && var.cf_enabled ? length(var.fe_build_logs_bucket_name) : 0
  bucket = var.fe_build_logs_bucket_name[count.index]
  //acl    = "private"
}

//backend codebuild logs bucket

resource "aws_s3_bucket" "be_build_logs" {
  count  = var.be_build_enabled && var.asg_enabled && var.lb_enabled ? length(var.be_build_logs_bucket_name) : 0
  bucket = var.be_build_logs_bucket_name[count.index]
  //acl    = "private"

}

//serverless codebuild logs bucket
resource "aws_s3_bucket" "sl_be_build_logs" {
  count  = var.sl_deploy_enabled  ? length(var.sl_be_build_logs_bucket_name) : 0
  bucket = var.sl_be_build_logs_bucket_name[count.index]
  //acl    = "private"

}

//bucker for wordpress
resource "aws_s3_bucket" "wordpress_s3_bucket" {
bucket = "${var.project_name}-wordpress-${var.env}"
tags = {
Name = "${var.project_name}-wordpress-${var.env}"
}
}