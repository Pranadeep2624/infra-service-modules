data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.argocd_management_role_arn]
    }
  }
}

resource "aws_iam_role" "argocd_role" {
  name               = "${var.cluster_name}-argocd-role"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

}
