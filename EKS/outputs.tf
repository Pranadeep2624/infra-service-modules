output "endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
  description = "Endpoint of the EKS Cluster"
}


output "eks_cluster_name" {
  value       = aws_eks_cluster.eks_cluster.name
  description = "EKS cluster name"
}

output "eks_cluster_cert_authority" {
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  description = "EKS Cluster certificate authority"
}
output "eks_cluster_oidc_issuer" {
  value       = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  description = "EKS Cluster OIDC Issuer"
}
output "eks_node_iam_role_arn" {
  value       = aws_iam_role.eks_node_role.arn
  description = "IAM role assumed by EKS nodes"
}

output "oidc_url" {
  value       = aws_iam_openid_connect_provider.eks_openid_connect.url
  description = "OIDC url of EKS Cluster"
}
output "oidc_arn" {
  value       = aws_iam_openid_connect_provider.eks_openid_connect.arn
  description = "OIDC Arn of EKS cluster"
}
