resource "aws_ecr_repository" "postech_fiap_ecr" {
  name                 = "postechfiapecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Environment = "Production"
    Project     = "PosTechFiap"
  }
}