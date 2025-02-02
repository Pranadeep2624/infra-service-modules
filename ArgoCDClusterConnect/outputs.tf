output "argocd_role_arn" {
  value       = aws_iam_role.argocd_role.arn
  description = "ARN of IAM Role with which ArgoCD carry out operations inside Cluster"
}
output "argocd_role_name" {
  value       = aws_iam_role.argocd_role.name
  description = "IAM Role Name with which ArgoCD carry out operation inside Cluster"
}
