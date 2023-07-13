#########################frontend pipeline##########################
resource "aws_codepipeline" "codepipeline" {
count = var.fe_build_enabled && var.cf_enabled ? length(var.fe_codepipeline_name) : 0
  name     = var.fe_codepipeline_name[count.index]
  role_arn = aws_iam_role.codepipeline_role[0].arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_fe[0].bucket
    type     = "S3"
  }
  
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.csc_fe[0].arn
        FullRepositoryId = var.fe_repository_name
        BranchName       = var.fe_repository_branch
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
          
        ProjectName = aws_codebuild_project.code_build_fe[0].name
      }
    }
  }
}

#########################backend pipeline asg##########################

//code deploy app for backend
resource "aws_codedeploy_app" "codedeploy_app" {
  count = var.be_build_enabled && var.asg_enabled && var.lb_enabled ? length(var.app_name) : 0
  compute_platform = "Server"
  name             = var.app_name[count.index]
}

//code deployment group for backend
resource "aws_codedeploy_deployment_group" "deployment_group" {
  count = var.be_build_enabled && var.asg_enabled && var.lb_enabled ? length(var.deployment_gp_name)  : 0
  app_name              = aws_codedeploy_app.codedeploy_app[0].name
  deployment_group_name = var.deployment_gp_name[count.index]
  service_role_arn      = aws_iam_role.codedeploy-access[0].arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb.alb[0].name
    }
  }

   deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  autoscaling_groups = [aws_autoscaling_group.asg[0].id]

}

//code pipeline for backend
resource "aws_codepipeline" "codepipeline-be" {
  count = var.be_build_enabled && var.asg_enabled && var.lb_enabled ? length(var.be_codepipeline_name)  : 0
  name = var.be_codepipeline_name[count.index]
  role_arn = aws_iam_role.codepipeline_role_serverless[0].arn
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_be[0].bucket
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
            ConnectionArn = aws_codestarconnections_connection.csc_be[0].arn
            FullRepositoryId = var.be_repository_name
            BranchName = var.be_repository_branch
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
            ProjectName = aws_codebuild_project.code_build_be[0].name
        }
    }
  }
stage {
  name = "Deploy"
  action {
    name            = "Deploy"
    category        = "Deploy"
    owner           = "AWS"   
    provider        = "CodeDeploy"
    input_artifacts = ["build_output"]
    version         = "1"
    configuration = {
        ApplicationName = aws_codedeploy_app.codedeploy_app[0].name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group[0].deployment_group_name
  }
}
  
}
}


#########################frontend pipeline##########################
resource "aws_codepipeline" "codepipeline-angular" {
count = var.angular_build_enabled && var.cf_enabled ? length(var.angular_codepipeline_name) : 0
  name     = var.angular_codepipeline_name[count.index]
  role_arn = aws_iam_role.codepipeline_role[0].arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_fe[0].bucket
    type     = "S3"
  }
  
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.csc_fe[0].arn
        FullRepositoryId = var.fe_repository_name
        BranchName       = var.fe_repository_branch
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
          
        ProjectName = aws_codebuild_project.code_build_angular[0].name
      }
    }
  }
}

//flutter frontend pipeline
resource "aws_codepipeline" "codepipeline-flutter" {
count = var.flutter_build_enabled && var.cf_enabled ? length(var.flutter_codepipeline_name) : 0
  name     = var.flutter_codepipeline_name[count.index]
  role_arn = aws_iam_role.codepipeline_role[0].arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_fe[0].bucket
    type     = "S3"
  }
  
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.csc_fe[0].arn
        FullRepositoryId = var.fe_repository_name
        BranchName       = var.fe_repository_branch
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
          
        ProjectName = aws_codebuild_project.code_build_flutter[0].name
      }
    }
  }
}