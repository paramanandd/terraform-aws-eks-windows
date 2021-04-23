resource "aws_cloudwatch_log_group" "cloudwatch_log_grp" {
  name              = var.cluster_name
  retention_in_days = var.retention_in_days
}

resource "aws_eks_cluster" "cluster" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.cluster_role.arn
  version                   = var.kubernetes_version
  enabled_cluster_log_types = var.enabled_cluster_log_types
  
  vpc_config {
    security_group_ids      = [aws_security_group.cluster_sg.id]
    subnet_ids              = local.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = local.public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
  }

  depends_on = [aws_cloudwatch_log_group.cloudwatch_log_grp]
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = data.template_file.aws_auth_cm_windows.rendered
    mapUsers = yamlencode(var.map_users)
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]
}

resource "aws_eks_node_group" "linux_ng" {
  cluster_name         = var.cluster_name
  node_group_name      = var.linux_node_group_name
  node_role_arn        = aws_iam_role.linux_role.arn
  subnet_ids           = local.subnet_ids
  ami_type             = var.ami_type
  capacity_type        = var.capacity_type
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = var.instance_types
  version              = var.kubernetes_version
  release_version      = var.release_version

  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
    source_security_group_ids = var.source_security_group_ids
  }
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]
}

resource "null_resource" "install_vpc_controller" {
  provisioner "local-exec" {
    command = "eksctl utils install-vpc-controllers --cluster ${var.cluster_name} --approve"
  }
  depends_on = [
    aws_eks_node_group.linux_ng
  ]
}

data "aws_ssm_parameter" "eks_worker_windows" {
  name = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-${var.kubernetes_version}/image_id"
}

data "template_file" "userdata_windows" {
  template = file("${path.module}/templates/userdata_windows.tpl")
  vars = {
    cluster_name = var.cluster_name
    kubelet_extra_args  = var.kubelet_extra_args
  }
}

resource "aws_launch_template" "workers" {
  name                   = var.lt_name
  vpc_security_group_ids = [aws_security_group.windows_sg.id,aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id]
  image_id               = data.aws_ssm_parameter.eks_worker_windows.value
  instance_type          = var.win_instance_type
  key_name               = var.key_name
  user_data              = base64encode(data.template_file.userdata_windows.rendered)

  monitoring {
    enabled = false
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = { "kubernetes.io/cluster/${var.cluster_name}" = "owned", "kubernetes.io/os" = "windows" }
  }

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.windows_profile.arn
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
  depends_on = [
    null_resource.install_vpc_controller
  ]
}

resource "aws_autoscaling_group" "workers" {

  name             = var.asg_name
  desired_capacity = var.win_desired_capacity
  max_size         = var.win_max_size
  min_size         = var.win_min_size

  launch_template {
    id      = aws_launch_template.workers.id
    version = "$Latest"
  }

  vpc_zone_identifier = local.subnet_ids
  health_check_type   = "EC2"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity, target_group_arns]
  }
}