resource "random_password" "db_password" {
    length  = 20
    special = false
}

module "ecs"  {
    source = "./infra-modules/ecs"

    cluster_name = var.project_name
    vpc_id = var.vpc_id
    services = [
        {
            name = "${var.project_name}-tracker-${terraform.workspace}"
            memory = 512
            cpu = 256
            ports = [5000]
            subnet_ids = var.dmz_subnets
            environment_variables = [
                {
                    "name": "WORKSPACE",
                    "value": terraform.workspace
                },
                {
                    "name" = "BUCKET"
                    "value" = "s3://${var.bucket_name}"
                },
                {
                    "name" = "CONNECTION_STRING"
                    "value" = "mysql+pymysql://${var.db_user}:${random_password.db_password.result}@${aws_db_instance.rds.endpoint}/${var.db_name}"
                }
            ]
            security_options = {
                linux_parameters = null
                read_only = false
            }
            iam_policy = templatefile("${path.module}/policies/ecs/${var.project_name}/${var.project_name}-policie.json", {
                BUCKET_NAME = var.bucket_name
            })
            discovery_service = true
            load_balancers = {
                subnet_ids = var.dmz_subnets
                internal = true
                target_port = 5000
                health_check = {
                    enabled = true
                    port = 5000
                    matcher = "200-399"
                    path = "/"
                    timeout = 30
                    interval = 60
                }
            }
        },
        {
            name = "${var.project_name}-model-${terraform.workspace}"
            memory = 8192*2
            cpu = 4096*2
            ports = [8501]
            subnet_ids = var.dmz_subnets
            environment_variables = [
                {
                    "name": "WORKSPACE",
                    "value": terraform.workspace
                },
                {
                    "name" = "BUCKET"
                    "value" = "s3://${var.bucket_name}"
                }
            ]
            security_options = {
                linux_parameters = null
                read_only = false
            }
            iam_policy = templatefile("${path.module}/policies/ecs/${var.project_name}/${var.project_name}-policie.json", {
                BUCKET_NAME = var.bucket_name
            })
            discovery_service = true
            public_ip = true
            load_balancers = {
                subnet_ids = var.dmz_subnets
                internal = true
                target_port = 8501
                health_check = {
                    enabled = true
                    port = 8501
                    matcher = "200-399"
                    path = "/"
                    timeout = 30
                    interval = 60
                }
            }
        },
    ]
}