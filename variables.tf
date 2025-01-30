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

variable "datasets_bucket_name" {
  type        = string
  description = "A unique name for this application (e.g. mlflow-team-name)"
  default = "amh-mlops-datasets"
}

variable "agent_openai_api_key" {
  type        = string
  description = "OpenAI API Key for Agent"
  sensitive   = true
}

variable "agent_data_path" {
  type        = string
  description = "Data path for embeddings"
  default     = "./data/embeddings_05_09_2024"
}

variable "agent_mistral_api_key" {
  type        = string
  description = "Mistral API Key"
  sensitive   = true
}

variable "agent_judge_model" {
  type        = string
  description = "Judge model name"
  default     = "GPT-4o-mini"
}

variable "agent_feedback_address" {
  type        = string
  description = "Feedback service address"
  default     = ""
}

variable "agent_feedback_port" {
  type        = number
  description = "Feedback service port"
  default     = 80
}

variable "agent_requisicoes_path" {
  type        = string
  description = "Requisicoes data path"
  default     = "s3://amh-mlops-datasets-development/2024/8"
}

variable "agent_requisicoes_port" {
  type        = number
  description = "Requisicoes service port"
  default     = 80
}

variable "agent_qdrant_api_key" {
  type        = string
  description = "Qdrant API Key"
  sensitive   = true
}

variable "agent_qdrant_url" {
  type        = string
  description = "Qdrant URL"
}

variable "firebase_api_key" {
  type        = string
  description = "Firebase API Key"
  sensitive   = true
}

variable "firebase_project_id" {
  type        = string
  description = "Firebase project ID"
  default     = "login-jair-amh-ceia"
}

variable "firebase_private_key_id" {
  type        = string
  description = "Firebase private key ID"
  sensitive   = true
}

variable "firebase_private_key" {
  type        = string
  description = "Firebase private key"
  sensitive   = true
}

variable "firebase_client_email" {
  type        = string
  description = "Firebase client email"
  default     = "firebase-adminsdk-fbsvc@login-jair-amh-ceia.iam.gserviceaccount.com"
}

variable "firebase_client_id" {
  type        = string
  description = "Firebase client ID"
  default     = "116412145785513528524"
}

variable "firebase_auth_uri" {
  type        = string
  description = "Firebase auth URI"
  default     = "https://accounts.google.com/o/oauth2/auth"
}

variable "firebase_token_uri" {
  type        = string
  description = "Firebase token URI"
  default     = "https://oauth2.googleapis.com/token"
}

variable "firebase_auth_provider_x509_cert_url" {
  type        = string
  description = "Firebase auth provider x509 cert URL"
  default     = "https://www.googleapis.com/oauth2/v1/certs"
}

variable "firebase_client_x509_cert_url" {
  type        = string
  description = "Firebase client x509 cert URL"
  default     = "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40login-jair-amh-ceia.iam.gserviceaccount.com"
}

variable "firebase_universe_domain" {
  type        = string
  description = "Firebase universe domain"
  default     = "googleapis.com"
}