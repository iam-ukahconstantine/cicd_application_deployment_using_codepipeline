output "pipeline_name_arn" {
  value = aws_codepipeline.tf_code_deployment.arn
}

output "codebuild_project_arn" {
  value = aws_codebuild_project.build_code.arn
}