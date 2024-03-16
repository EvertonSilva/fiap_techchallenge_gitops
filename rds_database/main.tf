
variable "eks_cluster_security_group_id" {}
variable "postech_fiap_vpc_id" {}

resource "aws_db_instance" "postech_fiap_db" {
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 40 
  identifier           = "postech_fiap_db"
  username             = "db_user"
  password             = "db_password"
  parameter_group_name = "default.postgres11"
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
  name       = "rds-private-subnet-group"
  subnet_ids = [aws_subnet.private.*.id]
}
