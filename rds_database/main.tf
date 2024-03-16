
variable "eks_cluster_security_group_id" {}

# Recurso para criar o banco de dados RDS PostgreSQL
resource "aws_db_instance" "postech_fiap_db" {
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 40 
  identifier           = "postech_fiap_db"
  username             = "db_user"
  password             = "db_password"
  parameter_group_name = "default.postgres11"
  publicly_accessible  = false
  
  vpc_security_group_ids = [
    aws_security_group.eks_cluster_sg.id
  ]

  tags = {
    Ambiente = "Production"
    Projeto  = "PosTechFiap"
  }
}

resource "aws_db_subnet_group_association" "rds_subnet_association" {
  subnet_group_name = aws_db_subnet_group.private.name
  db_subnet_group_name = aws_db_instance.postech_fiap_db.subnet_group_name
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432  # Porta padrão do PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.eks_cluster_security_group_id}/32"]
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "rds-private-subnet-group"
  subnet_ids = [aws_subnet.private.*.id]
}
