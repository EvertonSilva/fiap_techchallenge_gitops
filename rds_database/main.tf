
variable "eks_cluster_security_group_id" {}
variable "postech_fiap_vpc_id" {}
variable "rds_master_passwd" {}

resource "aws_db_instance" "postech_fiap_db" {
  engine               = "postgres"
  engine_version       = "16.2" 
  instance_class       = "db.t3.micro"
  allocated_storage    = 40 
  identifier           = "postechfiapdb"
  db_name              = "postgres" 
  username             = "postgres"
  password             = var.rds_master_passwd
  parameter_group_name = "default.postgres16.2"
  db_subnet_group_name = aws_db_subnet_group.private.name
  publicly_accessible  = false
  
  vpc_security_group_ids = [var.eks_cluster_security_group_id]

  tags = {
    Ambiente = "Production"
    Projeto  = "PosTechFiap"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Regras de acesso para o banco de dados"
  vpc_id      = var.postech_fiap_vpc_id

  ingress {
    from_port   = 5432  # Porta padrão do PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.eks_cluster_security_group_id}/32"]
  }
}

resource "aws_subnet" "private" {
  vpc_id = var.postech_fiap_vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_db_subnet_group" "private" {
  name       = "postech-fiap-rds-sg"
  subnet_ids = [aws_subnet.private.*.id]
}
