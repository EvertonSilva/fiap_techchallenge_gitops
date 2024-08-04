resource "aws_security_group" "postechfiap_db_sg" {
  name = "rds-secgroup"
  vpc_id = var.vpc_id

  ingress {
    from_port     = 5432
    to_port       = 5432
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PostechFiapDbSecGroup"
    Projeto = "PosTechFiap"
  }
}

resource "aws_db_subnet_group" "postecfiap_db_subnetgroup" {
  subnet_ids = var.private_subnets

  tags = {
    Name = "PosTechFiapDbSubnetGroup"
  }
}

resource "aws_db_instance" "postechfiap_db" {
  engine                    = "postgres"
  engine_version            = "16.2" 
  instance_class            = "db.t3.micro"
  allocated_storage         = 40 
  identifier                = "postechfiapdb"
  db_name                   = "postgres" 
  username                  = "postgres"
  db_subnet_group_name      = aws_db_subnet_group.postecfiap_db_subnetgroup.name
  publicly_accessible       = false
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.postechfiap_db_sg.id]

  lifecycle {
    ignore_changes = [ skip_final_snapshot ]
  }

  tags = {
    Name = "PosTechFiapDatabase"
    Projeto = "PosTechFiap"
  }
}
