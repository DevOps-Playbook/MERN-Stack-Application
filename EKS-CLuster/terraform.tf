# Configure required providers for AWS and Docker to manage infrastructure
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }

}

# Configure AWS provider with region specified in variables
provider "aws" {
  region = var.aws_region
}

