variable "vpc_id" {
  type = string
  description = "VPC Id"
}

variable "dmz_subnets" {
  type        = list(string)
  description = "List of public Subnets"
}

variable "project_name" {
  type = string
  description = "Project unique name"
  default = "mlops-mlflow"
}

variable "bucket_name" {
  type        = string
  description = "A unique name for this application (e.g. mlflow-team-name)"
  default = "americashealth-mlops-mlflow"
}

variable "db_name" {
  type        = string
  description = "Name of RDS DB"
  default = "mlflowdb"
}

variable "db_user" {
  type        = string
  description = "Name of RDS User"
  default = "master"
}

variable "db_port" {
  type        = number
  description = "Port of RDS Server"
  default = 3306
}