terraform {
  required_version = ">= 1.3.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">2.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">3.4.4"
    }
  }
}
