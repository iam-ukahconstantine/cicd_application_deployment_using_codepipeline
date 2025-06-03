

resource "aws_s3_bucket" "s3_pipeline_artifacts" {
  bucket_prefix = var.bucket_name
  force_destroy = true
}




resource "aws_s3_bucket_policy" "s3_pipeline_artifacts_policy" {
  bucket = aws_s3_bucket.s3_pipeline_artifacts.id

  policy = data.aws_iam_policy_document.s3.json
}




resource "aws_s3_bucket_server_side_encryption_configuration" "s3_sse_config" {
  bucket = aws_s3_bucket.s3_pipeline_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.key_id
      sse_algorithm     = "aws:kms"
    }
  }
}


data "aws_iam_policy_document" "s3" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [aws_s3_bucket.s3_pipeline_artifacts.arn, "${aws_s3_bucket.s3_pipeline_artifacts.arn}/*"]

    condition {
      test     = "ArnEquals"
      variable = "AWS:SourceArn"
      values   = [var.pipeline_name_arn, var.codebuild_project_arn]
    }
  }
}
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.s3_pipeline_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.s3_pipeline_artifacts.id

  block_public_acls       = "true"
  block_public_policy     = "true"
  ignore_public_acls      = "true"
  restrict_public_buckets = "true"

}