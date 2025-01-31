variable "oidc_provider" {
  description = "OIDC provider value"
  type        = string
}

variable "service_account" {
  description = "Service Account with namespace format (['system:serviceaccount:namespace:service_account']) associated with IRSA"
  type        = list(string)

}
variable "role_name" {
  description = "Role Name of the IAM Role"
  type        = string
}
variable "policy_arns" {
  description = "List of all the Policy arns to attach"
  type        = list(string)
}
variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
