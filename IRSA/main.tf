data "aws_caller_identity" "current" {}
locals {
  tags = {}
}
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:sub"
      values   = var.service_account
    }
  }
}



resource "aws_iam_role" "role" {
  name               = var.role_name
  tags               = merge(local.tags, var.tags)
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count = length(var.policy_arns)

  role       = aws_iam_role.role.name
  policy_arn = var.policy_arns[count.index]
}
