

resource "argocd_cluster" "eks" {

  server = var.cluster_endpoint
  name   = var.cluster_name

  config {
    aws_auth_config {
      cluster_name = var.cluster_name
      role_arn     = aws_iam_role.argocd_role.arn
    }
    tls_client_config {
      ca_data = var.cluster_certificate_authority_data
    }
  }

  metadata {
    labels = {
      clusterName = var.cluster_name
      cloud       = "aws"
    }
  }
}
