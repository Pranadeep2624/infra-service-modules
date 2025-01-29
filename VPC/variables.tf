variable "cidr_base" {
  description = "VPC CIDR "
  type        = string
}
variable "public_subnets" {
  description = "list of public subnet CIDRs"
  type        = list(string)
}
variable "private_subnets" {
  description = "list of private subnet CIDRs"
  type        = list(string)
}
variable "environment" {
  description = "environment name used in naming while creating resources"
  type        = string
}

variable "app_name" {
  description = "project name for which VPC is created"
  type        = string
}

variable "tags" {
  description = "Tags to be attached to Resources"
  type        = map(string)
  default     = {}
}

variable "create_nat" {
  description = "Boolean to indicate creation of Nat Gateway"
  type        = bool
  default     = true
}
