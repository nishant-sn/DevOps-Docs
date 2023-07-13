resource "aws_s3_bucket" "website" {
  count         = var.cf_enabled ? 1 : 0
  bucket        = var.cf_bucket_name
  //acl           = "private"
  force_destroy = true
  tags = {
    Name        = var.cf_bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "s3block" {
  count			  = var.cf_enabled ? 1 : 0
  bucket                  = aws_s3_bucket.website[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_distribution" "cf" {
  count               = var.cf_enabled ? 1 : 0
  enabled             = true
  //aliases             = [var.cf_endpoint]
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.website[0].bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website[0].bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai[0].cloudfront_access_identity_path
    }

    //origin_shield {
    //  enabled = false
    //}
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.website[0].bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
        error_caching_min_ttl = 10
        error_code = 403
        response_code = 200
        response_page_path = "/index.html"
    }
  custom_error_response {
        error_caching_min_ttl = 10
        error_code = 404
        response_code = 200
        response_page_path = "/index.html"
    }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  count         = var.cf_enabled ? 1 : 0
  comment = "OAI for S3 bucket - ${var.cf_bucket_name}"
}

resource "aws_s3_bucket_policy" "s3policy" {
  count         = var.cf_enabled ? 1 : 0
  bucket = aws_s3_bucket.website[0].id
  policy = data.aws_iam_policy_document.s3policy[0].json
}

data "aws_iam_policy_document" "s3policy" {
  count         = var.cf_enabled ? 1 : 0
  statement {
    actions = ["s3:GetObject"]

    resources = [
      aws_s3_bucket.website[0].arn,
      "${aws_s3_bucket.website[0].arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai[0].iam_arn]
    }
  }
}
