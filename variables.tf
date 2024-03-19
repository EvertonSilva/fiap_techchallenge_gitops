# Arquivo de variáveis

variable "RDS_PASSWD" {
  type = string
  description = "Senha RDS Master, deve ser definida via variável de ambiente TF_VAR_RDS_PASSWD"
}

variable "common_tags" {
  default = {
    Environment = "Production"
    Project     = "PosTechFiap"
    Source      = "terraform"
  }
  description = "Tags comuns a todos os recursos"
  type = map(string)
}