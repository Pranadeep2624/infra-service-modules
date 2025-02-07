
data "http" "alb_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${var.app_version}/docs/install/iam_policy.json"
}
resource "aws_iam_policy" "controller_policy" {
  name        = "${var.environment}-${var.app_name}-eks-cluster-aws-alb-policy"
  path        = "/"
  description = "AWS ALB Controller IAM Policy "

  policy = data.http.alb_policy.response_body
}
module "irsa" {
  source        = "git::https://github.com/Pranadeep2624/terraform-aws-modules.git//IRSA"
  oidc_provider = replace(var.oidc_url, "https://", "")


  service_account = ["system:serviceaccount:${var.namespace}:${var.service_account}"]
  role_name       = "${var.environment}-${var.app_name}-alb-controller-irsa"
  policy_arns     = [aws_iam_policy.controller_policy.arn]

}

# resource "helm_release" "aws_alb_controller" {
#   name = "aws-load-balancer-controller"

#   repository       = "https://aws.github.io/eks-charts"
#   chart            = "aws-load-balancer-controller"
#   create_namespace = var.namespace != "kube-system" ? true : false
#   version          = var.controller_version
#   namespace        = var.namespace

#   cleanup_on_fail = true
#   values          = var.helm_values

#   timeout = 600
#   dynamic "set" {
#     for_each = local.mandatory_helm_chart_values
#     iterator = helm_key_value
#     content {
#       name  = helm_key_value.key
#       value = helm_key_value.value
#     }
#   }

# depends_on = [  module.irsa ]

# }
