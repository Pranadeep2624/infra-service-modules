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
    tls = {
      source  = "hashicorp/tls"
      version = ">4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
provider "kubernetes" {
       host                   = module.eks.endpoint
     cluster_ca_certificate = base64decode(module.eks.eks_cluster_cert_authority)
     exec {
       api_version = "client.authentication.k8s.io/v1beta1"
       args        = ["eks", "get-token", "--cluster-name", module.eks.eks_cluster_name]
       command     = "aws"


     }
}