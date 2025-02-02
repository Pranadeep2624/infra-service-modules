terraform {
  required_version = ">= 1.3.2"
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = ">=7.0.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
  }
}
