module "code_pipeline" {
  source              = "../modules/pipeline"
  codebuild_name      = var.codebuild_name
  build_path          = var.build_path
  code_repository_url = module.ecr.code_repository_url
  codestar_connection_name = var.codestar_connection_name
  codestar_provider_type = var.codestar_provider_type
  pipeline_name       = var.pipeline_name
  bucket_name = module.s3_bucket.bucket_name
  key_arn = module.kms.key_arn
  sns_update_arn = module.notifications.sns_update_arn
  key_id = module.kms.key_id
  bucket_id = module.s3_bucket.bucket_id
  bucket_arn = module.s3_bucket.bucket_arn
}

module "ecr" {
  source              = "../modules/repo"
  pipeline_name       = var.pipeline_name
  code_repository_url = var.code_repository_url

}
module "notifications" {
  source       = "../modules/notification"
  sns_name     = var.sns_name
  sns_endpoint = var.sns_endpoint
  pipeline_name_arn = module.code_pipeline.pipeline_name_arn
}

module "kms" {
  source     = "../modules/key"
  key_id = var.key_id
  key_arn = var.key_arn

}

module "s3_bucket" {
  source     = "../modules/storage"
  bucket_name = var.bucket_name
  key_id = module.kms.key_id
  pipeline_name_arn = module.code_pipeline.pipeline_name_arn
  codebuild_project_arn = module.code_pipeline.codebuild_project_arn
  
}