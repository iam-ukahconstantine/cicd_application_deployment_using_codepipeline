output "key_id" {
  value = aws_kms_key.code_pipeline.id
}
output "key_arn" {
  value = aws_kms_key.code_pipeline.arn
}