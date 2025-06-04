# Create an SNS topic for pipeline notifications
resource "aws_sns_topic" "user_updates" {
  name         = var.sns_name
  display_name = var.sns_name
}

# Create an SNS topic policy to allow CodePipeline to publish messages
resource "aws_sns_topic_policy" "user_updates_policy" {
  arn = aws_sns_topic.user_updates.arn

  policy = data.aws_iam_policy_document.sns_user_updates.json
}
data "aws_iam_policy_document" "sns_user_updates" {
  statement {
    actions = [
      "SNS:Publish"
    ]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
    resources = [
      aws_sns_topic.user_updates.arn
    ]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.pipeline_name_arn]
    }
  }
}

# Create an SNS subscription for user updates
resource "aws_sns_topic_subscription" "user_updates_subscription" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = var.sns_endpoint
}

# Create an SNS topic for pipeline notifications