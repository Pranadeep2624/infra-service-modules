resource "kubernetes_secret" "example" {
  metadata {
    name = var.cluster_connect_secret_name
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
    namespace = var.namespace
  }

  data = {
  name =  var.cluster_name
  server = var.cluster_endpoint
  config = jsonencode({
      awsAuthConfig = {
        clusterName = "${var.cluster_name}"
        roleARN     = "${aws_iam_role.argocd_role.arn}"
      },
      tlsClientConfig = {
        insecure = false
        caData   = var.cluster_certificate_authority_data
      }
    })
  }
  type = "Opaque"

}