data "aws_caller_identity" "current" {}

resource "aws_kms_key" "code_pipeline" {
  description             = "Encryption key for secure AWS CodePipeline"
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  deletion_window_in_days = 7
 
}

resource "aws_kms_key_policy" "code_pipeline_policy" {
  key_id = aws_kms_key.code_pipeline.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}