
variable "eks_cluster_security_group_id" {}
variable "postech_fiap_vpc_id" {}
variable "rds_master_passwd" {}
variable "common_tags" {}

resource "aws_db_instance" "postech_fiap_db" {
  engine               = "postgres"
  engine_version       = "16.2" 
  instance_class       = "db.t3.micro"
  allocated_storage    = 40 
  identifier           = "postechfiapdb"
  db_name              = "postgres" 
  username             = "postgres"
  password             = var.rds_master_passwd
  db_subnet_group_name = aws_db_subnet_group.private.name
  publicly_accessible  = false
  skip_final_snapshot  = true
  
  vpc_security_group_ids = [var.eks_cluster_security_group_id]

  lifecycle {
    ignore_changes = [ skip_final_snapshot ]
  }

  tags = merge(
    var.common_tags,
    { Name = "postech-fiap-postgres" }
  )
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Regras de acesso para o banco de dados"
  vpc_id      = var.postech_fiap_vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    { Name = "postech-fiap-rds-secgr" }
  )
}

resource "aws_subnet" "rds_subnet_a" {
  vpc_id = var.postech_fiap_vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = merge(
    var.common_tags,
    { Name = "postech-fiap-rds-subnet-az-A" }
  )
}

resource "aws_subnet" "rds_subnet_b" {
  vpc_id = var.postech_fiap_vpc_id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = merge(
    var.common_tags,
    { Name = "postech-fiap-rds-subnet-az-B" }
  )
}

resource "aws_db_subnet_group" "private" {
  subnet_ids = [
    aws_subnet.rds_subnet_a.id,
    aws_subnet.rds_subnet_b.id
  ]

  tags = merge(
    var.common_tags,
    { Name = "postech-fiap-rds-subnet-group" }
  )
}
