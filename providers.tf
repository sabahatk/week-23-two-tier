#Set terraform providers
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Week-23-Project"
    workspaces {
      prefix = "week-23-work"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = var.region_name
}
