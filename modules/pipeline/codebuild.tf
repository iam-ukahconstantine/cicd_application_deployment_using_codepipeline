# Create a CodeBuild project for the pipeline
resource "aws_codebuild_project" "build_code" {
  name                   = var.codebuild_name
  service_role           = aws_iam_role.codebuild.arn
  concurrent_build_limit = 1


  environment {
    type                        = "LINUX_CONTAINER"
    image                       = "${var.code_repository_url}:latest"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "SERVICE_ROLE"
    privileged_mode             = false
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${var.build_path}/buildspec.yml")
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.pipeline_logs.name
      status     = "ENABLED"
    }
  }
}

# Create a CloudWatch log group for CodeBuild logs
resource "aws_cloudwatch_log_group" "pipeline_logs" {
  name              = "${var.codebuild_name}"
  retention_in_days = 5
}


# Create an IAM role for CodeBuild with the necessary permissions
resource "aws_iam_role" "codebuild" {
    name = "${var.codebuild_name}-build-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "codebuild.amazonaws.com"
                }
            }
        ]
    })
}

# resource "aws_iam_role_policy" "codebuild_policy" {
#   name = "${var.codebuild_name}-codebuild-policy"
#   role = aws_iam_role.codebuild.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid    = "ECRPullPush",
#         Effect = "Allow",
#         Action = [
#           "ecr:GetAuthorizationToken",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage",
#           "ecr:PutImage"
#         ],
#         Resource = "*"
#       },
#       #   {
#       #     Sid    = "S3ArtifactsAccess",
#       #     Effect = "Allow",
#       #     Action = [
#       #       "s3:GetObject",
#       #       "s3:PutObject"
#       #     ],
#       #     Resource = [
#       #       "arn:aws:s3:::${var.artifact_bucket}/*"
#       #     ]
#       #   },
#       {
#         Sid    = "CloudWatchLogs",
#         Effect = "Allow",
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         Resource = "*"
#       },
#       {
#         Sid    = "CodeBuildBasic",
#         Effect = "Allow",
#         Action = [
#           "codebuild:BatchGetBuilds",
#           "codebuild:StartBuild",
#           "codebuild:BatchGetProjects"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }
resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}