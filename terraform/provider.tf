/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38.0"
    }
  }
}*/

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
    "Project Name" = var.project_name
    "Project Type" = var.project_type
    Environment = var.env
    }
  }  
}
