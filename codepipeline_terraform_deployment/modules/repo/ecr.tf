# This creates an ECR repository for storing Docker images.
resource "aws_ecr_repository" "image_repository" {
  name                 = var.pipeline_name
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}