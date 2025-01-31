variable "oidc_url" {
  type        = string
  description = "OIDC issuer of the EKS cluster"
}
variable "namespace" {
  type        = string
  description = "Namespace to which Controller will be deployed"
}
variable "service_account" {
  type        = string
  description = "Service Account name associated to the controller pod"
}
variable "controller_version" {
  type        = string
  description = "Helm Chart version of the AWS ALB Controller"
}
variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "helm_values" {
  type        = list(string)
  description = "Helm Chart Values in yaml content"
  default     = []
}
variable "app_name" {
  description = "project name for which VPC is created"
  type        = string
}
variable "environment" {
  description = "environment name used in naming while creating resources"
  type        = string
}
