variable "environment" {
  description = "Environment Name for which the Kubernetes Cluster is created"
  type        = string
}
variable "app_name" {
  description = "Name of the Project"
  type        = string
}
variable "eks_endpoint_private_access" {
  description = "Whether to keep the EKS endpoint private"
  type        = string

}
variable "eks_endpoint_public_access" {
  description = "Whether to keep the EKS endpoint public"
  type        = string
}
variable "eks_version" {
  description = "EKS version to be used to spin up EKS Cluster"
  type        = string
}
variable "cni_version" {
  default     = null
  type        = string
  description = "Version of the Addon"
}
variable "proxy_version" {
  default     = null
  type        = string
  description = "Version of the Addon"
}
variable "coredns_version" {
  default     = null
  type        = string
  description = "Version of the Addon"
}
variable "subnet_ids" {
  description = "The Subnet Ids on which EKS Cluster will be created"
  type        = list(string)
}
variable "node_policies" {
  default     = [""]
  description = "Node Policies to be associated to EKS apart from necessary ones "
  type        = list(string)

}

variable "eks_instance_type" {
  description = "Instance Type of the EKS Nodes"
  type        = string
}

variable "eks_desired_size" {
  description = "Desired Number of EKS Nodes"
  type        = string
}
variable "eks_min_size" {
  description = "Minimum Number of EKS Nodes"
  type        = string
}
variable "eks_max_size" {
  description = "Maximum Number of EKS Nodes"
  type        = string
}

variable "tags" {
  description = "Tags to be attached to Resources Created"
  type        = map(string)
  default     = {}
}
variable "service_ipv4_cidr" {
  description = "IPv4 CIDR of service "
  default     = "172.20.0.0/16"
  type        = string
}
