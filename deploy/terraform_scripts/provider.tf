# provider.tf

provider "aws" {
  region  = "ap-south-1" # specify the region you prefer
  access_key = var.aws_access_key
  secret_key = var.aws_secret_access_key
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
