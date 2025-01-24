# MLFLOW

resource "aws_db_subnet_group" "rds" {
    name = "subnetgroup-rds-${var.project_name}"
    subnet_ids = var.dmz_subnets
}

resource "aws_security_group" "sg_rds" {
    name = "sg_${var.project_name}_rds"
    description = "RDS security group MLFlow"
    vpc_id = var.vpc_id

    ingress {
        from_port   = var.db_port
        to_port     = var.db_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_db_instance" "rds" {
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "8.0.34"
    instance_class       = "db.t3.micro"
    db_name              = var.db_name
    identifier           = var.db_name
    username             = var.db_user
    password             = random_password.db_password.result
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true
    vpc_security_group_ids = [aws_security_group.sg_rds.id]
    db_subnet_group_name = aws_db_subnet_group.rds.name
}