####################FrontEndCodebuild######################
resource "aws_codebuild_project" "code_build_fe" {
  count = var.fe_build_enabled && var.cf_enabled ? length(var.fe_codebuild_name) : 0
  badge_enabled  = false
  name           = var.fe_codebuild_name[count.index]
  service_role   = aws_iam_role.codebuild-role[0].arn

  artifacts {
    encryption_disabled    = false
    name                   = "hello-codebuild"
    override_artifact_name = true
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"

    dynamic "environment_variable" {
      for_each = var.fe_env_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

  }
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "ENABLED"
      location            = "${aws_s3_bucket.fe_build_logs[0].bucket}/build-logs}"
    }
  }

  source {
    buildspec = templatefile("${path.module}/buildspecs/buildspec-reactjs.yaml",{bucket_name = var.cf_bucket_name ,cloudfront_distribution_id = aws_cloudfront_distribution.cf[0].id})
    git_clone_depth = 0
    insecure_ssl = false
    report_build_status = false
    type = "CODEPIPELINE"
  }
}



//codepipeline source bucket 
resource "aws_s3_bucket" "codepipeline_bucket_fe" {
  count = (var.fe_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) && var.cf_enabled ? length(var.fe_pipeline_source_bucket_name) : 0
  bucket = var.fe_pipeline_source_bucket_name[count.index] //"codepipeline-fe-source-algoworks"
  //acl    = "private"
}
//codepipeline codestarconnection
resource "aws_codestarconnections_connection" "csc_fe" {
  count = (var.fe_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) && var.cf_enabled ? length(var.fe_codstarconnection_name) : 0
  name          = var.fe_codstarconnection_name[count.index]
  provider_type = "Bitbucket"
}


####################BackEndCodebuild######################
resource "aws_codebuild_project" "code_build_be" {
  count = var.be_build_enabled && var.asg_enabled && var.lb_enabled ? length(var.be_codebuild_name) : 0
  badge_enabled  = false
  name           = var.be_codebuild_name[count.index]
  service_role   = aws_iam_role.codebuild-role[0].arn

  artifacts {
    encryption_disabled    = false
    name                   = "hello-codebuild"
    override_artifact_name = true
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"

    dynamic "environment_variable" {
      for_each = var.be_env_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

  }
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "ENABLED"
      location            = "${aws_s3_bucket.be_build_logs[0].bucket}/build-logs}"
    }
  }

  source {
    buildspec = file("buildspecs/buildspec-be.yaml")
    git_clone_depth = 0
    insecure_ssl = false
    report_build_status = false
    type = "CODEPIPELINE"
  }
}

//codepipeline source bucket 
resource "aws_s3_bucket" "codepipeline_bucket_be" {
  count = var.be_build_enabled && var.asg_enabled && var.lb_enabled ? length(var.be_pipeline_source_bucket_name) : 0
  bucket = var.be_pipeline_source_bucket_name[count.index] //"codepipeline-be-source-algoworks"
  //acl    = "private"
}
//codepipeline codestarconnection
resource "aws_codestarconnections_connection" "csc_be" {
  count = var.be_build_enabled && var.asg_enabled && var.lb_enabled ? length(var.be_codestarconnection_name) : 0
  name          = var.be_codestarconnection_name[count.index]
  provider_type = "Bitbucket"
}


####################FrontEndCodebuildAngular######################
resource "aws_codebuild_project" "code_build_angular" {
  count = var.angular_build_enabled && var.cf_enabled ? length(var.angular_codebuild_name) : 0
  badge_enabled  = false
  name           = var.angular_codebuild_name[count.index]
  service_role   = aws_iam_role.codebuild-role[0].arn

  artifacts {
    encryption_disabled    = false
    name                   = "hello-codebuild"
    override_artifact_name = true
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"

    dynamic "environment_variable" {
      for_each = var.fe_env_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

  }
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "ENABLED"
      location            = "${aws_s3_bucket.fe_build_logs[0].bucket}/build-logs}"
    }
  }

  source {
    buildspec = templatefile("${path.module}/buildspecs/buildspec-angular.yaml",{bucket_name = var.cf_bucket_name ,cloudfront_distribution_id = aws_cloudfront_distribution.cf[0].id})
    git_clone_depth = 0
    insecure_ssl = false
    report_build_status = false
    type = "CODEPIPELINE"
  }
}

####################FrontEndCodebuildflutter######################
resource "aws_codebuild_project" "code_build_flutter" {
  count = var.flutter_build_enabled && var.cf_enabled ? length(var.flutter_codebuild_name) : 0
  badge_enabled  = false
  name           = var.flutter_codebuild_name[count.index]
  service_role   = aws_iam_role.codebuild-role[0].arn

  artifacts {
    encryption_disabled    = false
    name                   = "hello-codebuild"
    override_artifact_name = true
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"

    dynamic "environment_variable" {
      for_each = var.fe_env_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

  }
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "ENABLED"
      location            = "${aws_s3_bucket.fe_build_logs[0].bucket}/build-logs}"
    }
  }

  source {
    buildspec = templatefile("${path.module}/buildspecs/buildspec-flutter.yaml",{bucket_name = var.cf_bucket_name ,cloudfront_distribution_id = aws_cloudfront_distribution.cf[0].id})
    git_clone_depth = 0
    insecure_ssl = false
    report_build_status = false
    type = "CODEPIPELINE"
  }
}