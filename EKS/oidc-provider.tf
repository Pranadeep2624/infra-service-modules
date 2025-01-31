data "tls_certificate" "eks_cluster_tls_certificate" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_openid_connect" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.eks_cluster_tls_certificate.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.eks_cluster_tls_certificate.url
  depends_on      = [aws_eks_cluster.eks_cluster]
  lifecycle {
    ignore_changes = [thumbprint_list]
  }
}
