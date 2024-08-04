resource "aws_db_subnet_group" "postecfiap_db_subnetgroup" {
    subnet_ids = [ var.private_subnet_id ]

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

  lifecycle {
    ignore_changes = [ skip_final_snapshot ]
  }

  tags = {
    Name = "PosTechFiapDatabase"
    Projeto = "PosTechFiap"
  }
}