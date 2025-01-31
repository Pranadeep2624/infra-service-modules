/*=========
IAM role for aws-node ( VPC CNI pods)
This is role will be used by service account aws-node associated to aws-node pods which
needs IAM permissions to spin up eks node
===========*/
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster.version}/amazon-linux-2023/x86_64/standard/recommended/release_version"
}
resource "aws_eks_node_group" "eks_node" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  version         = aws_eks_cluster.eks_cluster.version
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  node_group_name = "${var.environment}-${var.app_name}-eks-node"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids
  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}-eks-nodegroup"
  })

  scaling_config {
    desired_size = var.eks_desired_size
    max_size     = var.eks_max_size
    min_size     = var.eks_min_size
  }

  capacity_type  = "ON_DEMAND"
  instance_types = [var.eks_instance_type]

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role.eks_node_role
  ]
}

data "aws_iam_policy_document" "eks_node_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-nodegroup.amazonaws.com", "eks.amazonaws.com", "ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_node_role" {
  name               = "${var.environment}-${var.app_name}-eks-node-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.eks_node_role_policy.json
  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}-eks-iam-role"
  })
  lifecycle {
    ignore_changes = [assume_role_policy]
  }
}


resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attach" {
  role       = aws_iam_role.eks_node_role.name
  count      = length(compact(concat(var.node_policies, local.node_policies)))
  policy_arn = compact(concat(var.node_policies, local.node_policies))[count.index]
}
