output "rds_enpoint" {
  description = "Endpoint para conexão com o banco de dados"
  value = aws_db_instance.postechfiap_db.endpoint
}