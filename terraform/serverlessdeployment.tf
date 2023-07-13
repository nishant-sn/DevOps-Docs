
####################ServerlessCodebuild for node ###################################
resource "aws_codebuild_project" "sl_code_build_be_node" {
  count = var.sl_deploy_enabled && var.sl_node_deploy ? length(var.sl_nodedeploy_name) : 0
  badge_enabled  = false
  name           = var.sl_nodedeploy_name[count.index]
  service_role   = aws_iam_role.codebuild-role-serverless[0].arn

  artifacts {
    encryption_disabled    = false
    name                   = "serverless-codebuild"
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
      for_each = var.sl_be_env_vars
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
      location            = "${aws_s3_bucket.sl_be_build_logs[0].bucket}/build-logs}"
    }
  }

  source {
    buildspec = file("buildspecs/buildspec-serverless-node.yaml")
    git_clone_depth = 0
    insecure_ssl = false
    report_build_status = false
    type = "CODEPIPELINE"
  }
}

//code build for python 
resource "aws_codebuild_project" "sl_code_build_be_python" {
  count = var.sl_deploy_enabled && var.sl_python_deploy ? length(var.sl_pythondeploy_name) : 0
  badge_enabled  = false
  name           = var.sl_pythondeploy_name[count.index]
  service_role   = aws_iam_role.codebuild-role-serverless[0].arn

  artifacts {
    encryption_disabled    = false
    name                   = "serverless-codebuild"
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
      for_each = var.sl_be_env_vars
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
      location            = "${aws_s3_bucket.sl_be_build_logs[0].bucket}/build-logs}"
    }
  }

  source {
    buildspec = file("buildspecs/buildspec-serverless-python.yml")
    git_clone_depth = 0
    insecure_ssl = false
    report_build_status = false
    type = "CODEPIPELINE"
  }
}

//serverless codepipeline source bucket 
resource "aws_s3_bucket" "sl_codepipeline_bucket_be" {
  count = var.sl_deploy_enabled  ? length(var.sl_pipeline_source_bucket_name) : 0
  bucket = var.sl_pipeline_source_bucket_name[count.index] //"codepipeline-be-source-algoworks"
  //acl    = "private"
}
//codepipeline codestarconnection
resource "aws_codestarconnections_connection" "sl_csc_be" {
  count = var.sl_deploy_enabled ? length(var.sl_be_codestarconnection_name) : 0
  name          = var.sl_be_codestarconnection_name[count.index]
  provider_type = "Bitbucket"
}



#########################serverless pipeline ##########################

//code pipeline for serverless for node
resource "aws_codepipeline" "sl_codepipeline-be_node" {
  count = var.sl_deploy_enabled && var.sl_node_deploy ? length(var.sl_nodecodepipeline_name)  : 0
  name = var.sl_nodecodepipeline_name[count.index]
  role_arn = aws_iam_role.codepipeline_role_serverless[0].arn
  artifact_store {
    location = aws_s3_bucket.sl_codepipeline_bucket_be[0].bucket
    type = "S3"
  }
  stage {
    name = "Source"

    action {
        name = "Source"
        category = "Source"
        owner = "AWS"
        provider = "CodeStarSourceConnection"
        version = "1"
        output_artifacts = ["source_output"]
        configuration = {
            ConnectionArn = aws_codestarconnections_connection.sl_csc_be[0].arn
            FullRepositoryId = var.sl_repository_name
            BranchName = var.sl_repository_branch
            OutputArtifactFormat = "CODE_ZIP"
        }
    }
  }
  stage {
    name = "Build"

    action {
        name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"


        configuration = {
            ProjectName = aws_codebuild_project.sl_code_build_be_node[0].name
        }
    }
  }

  
}



//code pipeline for serverless for python
resource "aws_codepipeline" "sl_codepipeline-be-python" {
  count = var.sl_deploy_enabled && var.sl_python_deploy ? length(var.sl_pythoncodepipeline_name)  : 0
  name = var.sl_pythoncodepipeline_name[count.index]
  role_arn = aws_iam_role.codepipeline_role_serverless[0].arn
  artifact_store {
    location = aws_s3_bucket.sl_codepipeline_bucket_be[0].bucket
    type = "S3"
  }
  stage {
    name = "Source"

    action {
        name = "Source"
        category = "Source"
        owner = "AWS"
        provider = "CodeStarSourceConnection"
        version = "1"
        output_artifacts = ["source_output"]
        configuration = {
            ConnectionArn = aws_codestarconnections_connection.sl_csc_be[0].arn
            FullRepositoryId = var.sl_repository_name
            BranchName = var.sl_repository_branch
            OutputArtifactFormat = "CODE_ZIP"
        }
    }
  }
  stage {
    name = "Build"

    action {
        name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"


        configuration = {
            ProjectName = aws_codebuild_project.sl_code_build_be_python[0].name
        }
    }
  }

  
}
