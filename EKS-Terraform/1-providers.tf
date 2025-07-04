terraform {
   backend "s3" {
    bucket = "ams-s3-bucket-kimit"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-file"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = local.region
}