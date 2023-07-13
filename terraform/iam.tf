resource "aws_iam_role" "ec2_s3_role" {
  count = var.ec2_enabled && var.ec2_s3_allowed && var.s3_enabled ? 1 : 0
  name = "ec2_s3_role-new"
  assume_role_policy = file("iam-policy/ec2-s3-trusted-entity.json")
  tags = {
    Name = "ec2_s3_role-new"
  }
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  count = var.ec2_enabled && var.ec2_s3_allowed && var.s3_enabled ? 1 : 0  
  name = "ec2_s3_profile-new"
  role = aws_iam_role.ec2_s3_role[0].name
  tags = {
    Name = "ec2_s3_profile-new"
  }  
}

resource "aws_iam_role_policy" "ec2_s3_policy" {
  count  = var.ec2_enabled && var.ec2_s3_allowed && var.s3_enabled ? 1 : 0
  name = "ec2_s3_policy"
  role = aws_iam_role.ec2_s3_role[0].id
  #policy = file("iam-policy/ec2-s3-policy.json")
  policy = <<-EOF
            {
            "Version": "2012-10-17",
            "Statement": [
                {
                "Effect": "Allow",    
                "Action": [
                    "s3:GetBucketLocation",
                    "s3:ListAllMyBuckets"
                ],                
                "Resource": "arn:aws:s3:::*"
                },
                {
                "Effect": "Allow",
                "Action": [
                    "s3:*"
                ],
                "Resource": [
                    "arn:aws:s3:::${var.s3_bucket_name[0]}"                        
                ]
                }
            ]
            }
            EOF
}

#### SERVERLESS ####

resource "aws_iam_user" "serverless" {
  count = var.serverless_enabled ? 1 : 0
  name = var.serverless_iam_user_name
}

resource "aws_iam_access_key" "serverless" {
  count = var.serverless_enabled ? 1 : 0
  user = aws_iam_user.serverless[0].name
}

resource "aws_iam_user_policy" "serverless_policy" {
  count = var.serverless_enabled ? 1 : 0
  name = "serverless-policy"
  user = aws_iam_user.serverless[0].name
  policy = file("iam-policy/serverless-policy.json")
} 

#### Lambda Function ####

resource "aws_iam_role_policy" "lambda_alarm_policy" {
  count = var.cloudwatch_metric_alarm_enabled && (var.ec2_alerts_enabled || var.rds_alerts_enabled) ? 1 : 0
  name = "lambda_alarm_policy"
  role = aws_iam_role.lambda_alarm_role[0].id
  policy = file("iam-policy/lambda-alarm.json")
}

resource "aws_iam_role" "lambda_alarm_role" {
  count = var.cloudwatch_metric_alarm_enabled && (var.ec2_alerts_enabled || var.rds_alerts_enabled) ? 1 : 0 
  name = "lambda_alarm_role"
  assume_role_policy = file("iam-policy/lambda-alarm-trusted-entity.json")
}


#### CICD Roles & Policies ####
data "aws_iam_policy" "AmazonEC2RoleforAWSCodeDeploy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}
resource "aws_iam_role" "devops_ec2codedeploy_role" {
  count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  name = "temp"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "devops_ec2codedeploy_role"
  }

}

resource "aws_iam_role_policy_attachment" "ec2_fullaccess_attach" {
count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  role       = aws_iam_role.devops_ec2codedeploy_role[0].name
  policy_arn = data.aws_iam_policy.AmazonEC2RoleforAWSCodeDeploy.arn
}

resource "aws_iam_instance_profile" "ec2_cd_instance_profile" {
  count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  name = "ec2_cd_instance-"
  role = aws_iam_role.devops_ec2codedeploy_role[0].name
}

data "aws_iam_policy" "AWSCodeDeployRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role" "codedeploy-access" {
  count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  name               = "codedeploy-access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
}
  
resource "aws_iam_role_policy_attachment" "codedeploy-attach" {
  count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  role       = aws_iam_role.codedeploy-access[0].name
  policy_arn = data.aws_iam_policy.AWSCodeDeployRole.arn
}

resource "aws_iam_role" "codepipeline_role" {
  count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  name = "codepipeline-access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role[0].id
  policy = file("iam-policy/codepipeline-policy.json")
}

resource "aws_iam_role" "codebuild-role" {
  count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  name = "codebuild-access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild-policy" {
  count = (var.fe_build_enabled || var.be_build_enabled || var.angular_build_enabled || var.flutter_build_enabled) ? 1 : 0
  role = aws_iam_role.codebuild-role[0].name
  policy = file("iam-policy/codebuild-policy.json")
}


//serverless code build role and policy
resource "aws_iam_role" "codebuild-role-serverless" {
  count = var.sl_deploy_enabled ? 1 : 0
  name = "codebuild-access-serverless"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "codebuild-policy-serverless" {
  count = var.sl_deploy_enabled ? 1 : 0
  role = aws_iam_role.codebuild-role-serverless[0].name
  policy = file("iam-policy/codebuild-policy-serverless.json")
  }

//serverless code pipline role and policy
resource "aws_iam_role" "codepipeline_role_serverless" {
  count = var.sl_deploy_enabled ? 1 : 0
  name = "codepipeline-access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy_serverless" {
  count = var.sl_deploy_enabled ? 1 : 0
  name = "codepipeline_policy_serverless"
  role = aws_iam_role.codepipeline_role_serverless[0].id
  policy = file("iam-policy/codepipeline-policy-serverless.json")
}
