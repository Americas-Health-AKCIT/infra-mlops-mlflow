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
            memory = 512*4
            cpu = 256*4
            ports = [5000, 80]
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
                BUCKET_NAME = "${var.bucket_name}-${terraform.workspace}"
            })
            discovery_service = true
            public_ip = true
            load_balancers = {
                subnet_ids = var.dmz_subnets
                internal = false
                target_port = 5000
                port = 80
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
            ports = [8501, 80]
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
                BUCKET_NAME = "${var.bucket_name}-${terraform.workspace}"
            })
            discovery_service = true
            public_ip = true
            load_balancers = {
                subnet_ids = var.dmz_subnets
                internal = false
                target_port = 8501
                port = 80
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
        {
            name = "agent-jair-${terraform.workspace}"
            memory = 8192*2
            cpu = 4096*2
            ports = [8501, 80]
            subnet_ids = var.dmz_subnets
            environment_variables = [
                {
                    "name": "WORKSPACE",
                    "value": terraform.workspace
                },
                {
                    "name": "BUCKET_DATASETS",
                    "value": "s3://${aws_s3_bucket.datasets_bucket.bucket}"
                },
                {
                    "name": "OPENAI_API_KEY",
                    "value": var.agent_openai_api_key
                },
                {
                    "name": "DATA_PATH",
                    "value": var.agent_data_path
                },
                {
                    "name": "MISTRAL_API_KEY",
                    "value": var.agent_mistral_api_key
                },
                {
                    "name": "JUDGE_MODEL",
                    "value": var.agent_judge_model
                },
                {
                    "name": "FEEDBACK_ADRESS",
                    "value": var.agent_feedback_address
                },
                {
                    "name": "FEEDBACK_PORT",
                    "value": tostring(var.agent_feedback_port)
                },
                {
                    "name": "REQUISICOES_ADRESS_OR_PATH",
                    "value": var.agent_requisicoes_path
                },
                {
                    "name": "REQUISICOES_PORT",
                    "value": tostring(var.agent_requisicoes_port)
                },
                {
                    "name": "QDRANT_API_KEY",
                    "value": var.agent_qdrant_api_key
                },
                {
                    "name": "MLFLOW_TRACK_URI",
                    "value": "http://${var.project_name}-tracker-${terraform.workspace}.${var.project_name}-tracker-${terraform.workspace}.local:5000"
                },
                {
                    "name": "QDRANT_URL",
                    "value": var.agent_qdrant_url
                },
                {
                    "name": "FIREBASE_WEB_API_KEY",
                    "value": var.firebase_api_key
                },
                {
                    "name": "FIREBASE_SERVICE_ACCOUNT_SECRET_ARN",
                    "value": aws_secretsmanager_secret.firebase_service_account.arn
                }
            ]
            security_options = {
                linux_parameters = null
                read_only = false
            }
            iam_policy = templatefile("${path.module}/policies/ecs/${var.project_name}/agent-jair-police.json", {
                BUCKET_NAME = "${aws_s3_bucket.artifact_bucket.bucket}"
                DATASETS_BUCKET_NAME = "${aws_s3_bucket.datasets_bucket.bucket}"
                PROJECT_NAME = "${var.project_name}"
            })
            discovery_service = true
            public_ip = true
            load_balancers = {
                subnet_ids = var.dmz_subnets
                internal = false
                target_port = 8501
                port = 80
                health_check = {
                    enabled = true
                    port = 8501
                    matcher = "200-399"
                    path = "/"
                    timeout = 30
                    interval = 60
                }
            }
        }
    ]
}