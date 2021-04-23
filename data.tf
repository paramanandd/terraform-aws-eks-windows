data "template_file" "aws_auth_cm_windows" {
  template = file("${path.module}/templates/aws-auth-cm-windows.tpl")
  vars = {
    linux_ng_role_arn = aws_iam_role.linux_role.arn
    wind_ng_role_arn  = aws_iam_role.windows_role.arn
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
  depends_on = [
    aws_eks_cluster.cluster
  ]
}