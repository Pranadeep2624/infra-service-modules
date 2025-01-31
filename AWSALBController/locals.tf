locals {
  mandatory_helm_chart_values = {
    "clusterName"                                               = var.cluster_name
    "serviceAccount.name"                                       = var.service_account
    "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa.role_arn
  }

}
