variable "argocd_management_role_arn" {
  type        = string
  description = "IAM Role assumed by argocd to access clusters"
}
variable "cluster_endpoint" {
  type        = string
  description = "AWS Cluster url to be connected with ArgoCD"

}
variable "cluster_name" {
  type        = string
  description = "AWS Cluster Name to be connected with ArgoCD"
}
variable "cluster_certificate_authority_data" {
  type        = string
  description = "CA data of the AWS Cluster to be connected with ArgoCD"
}
variable "cluster_connect_secret_name" {
  type = string
  description = "Secret name created for connecting Cluster with ArgoCD"
}
variable "namespace" {
  type = string
  description = "The namespace to deploy secret in"
}