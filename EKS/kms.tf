resource "aws_kms_key" "eks_cluster_kms_key" {
  description              = "KMS key for EKS Cluster"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      = false
  policy = jsonencode({
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : "kms:*",
        "Resource" : "*"
    }]
    Version = "2012-10-17"
  })
  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}-eks-kms-key"
  })


}

resource "aws_kms_alias" "eks_cluster_kms_alias" {
  name          = "alias/${var.environment}-${var.app_name}-eks-kms"
  target_key_id = aws_kms_key.eks_cluster_kms_key.key_id
}
