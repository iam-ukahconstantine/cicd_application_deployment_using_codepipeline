resource "aws_codestarconnections_connection" "github" {
  name          = var.codestar_connection_name
  provider_type = var.codestar_provider_type
}
