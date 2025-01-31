/*=====
IAM roles for cluster
======*/
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_iam_role" {
  name               = "${var.environment}-${var.app_name}-eks-cluster-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = merge(var.tags, {})
  lifecycle {
    ignore_changes = [assume_role_policy]
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_iam_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_iam_role.name
}





/*=====
EKS cluster
======*/
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.environment}-${var.app_name}-eks-cluster"
  version  = var.eks_version
  role_arn = aws_iam_role.eks_cluster_iam_role.arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = var.eks_endpoint_public_access
    endpoint_private_access = var.eks_endpoint_private_access
  }
  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_cluster_kms_key.arn
    }
    resources = ["secrets"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_iam_policy_attachment
  ]
  tags = merge(var.tags, {
    "alpha.eksctl.io/cluster-oidc-enabled" = "true"
  })
}

data "aws_eks_addon_version" "vpc_cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = aws_eks_cluster.eks_cluster.version

}
data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = aws_eks_cluster.eks_cluster.version
}
data "aws_eks_addon_version" "coredns" {

  addon_name         = "coredns"
  kubernetes_version = aws_eks_cluster.eks_cluster.version

}

resource "aws_eks_addon" "ekscluster_cni" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = try(var.cni_version, data.aws_eks_addon_version.vpc_cni.version)
  resolve_conflicts_on_create = "OVERWRITE"
  depends_on                  = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "ekscluster_proxy" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = try(var.proxy_version, data.aws_eks_addon_version.kube_proxy.version)
  resolve_conflicts_on_create = "OVERWRITE"
  depends_on                  = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "ekscluster_coredns" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "coredns"
  addon_version               = try(var.coredns_version, data.aws_eks_addon_version.coredns.version)
  resolve_conflicts_on_create = "OVERWRITE"
  depends_on                  = [aws_eks_cluster.eks_cluster]
}
