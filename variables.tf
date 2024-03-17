# Arquivo de variáveis

variable "RDS_PASSWD" {
  type = string
  description = "Senha RDS Master, deve ser definida via variável de ambiente TF_VAR_RDS_PASSWD"
}