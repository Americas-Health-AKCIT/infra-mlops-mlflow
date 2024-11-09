provider "aws" {
    default_tags {
        tags = {
            project = "MLOps"
            process = "MLOps"
            team = "AI"
            terraform = "true"
            environment = terraform.workspace
        }
    }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.75.0"
    }
  }
  backend "s3" {
      key = "terraform.tfstate"
      workspace_key_prefix = "infra/aws/tfstate/development"
  }
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to main resources"
}

locals {
  default_tags = {
    Environment = terraform.workspace
    Terraform   = "true"
    Project     = var.project_name
  }
  
  # Merge default tags with user provided tags
  tags = merge(local.default_tags, var.tags)
}
