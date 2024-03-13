# Provisiona bucket S3 para armazenar tfstate
resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket  = var.tfstate_bucket_name
}