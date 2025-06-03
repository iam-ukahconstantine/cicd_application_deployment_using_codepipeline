output "bucket_name" {
  value = aws_s3_bucket.s3_pipeline_artifacts.bucket
}

output "bucket_id" {
  value = aws_s3_bucket.s3_pipeline_artifacts.id
}
output "bucket_arn" {
  value = aws_s3_bucket.s3_pipeline_artifacts.arn
}