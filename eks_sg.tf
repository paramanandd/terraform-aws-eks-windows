resource "aws_security_group" "cluster_sg" {
  name        = "cluster_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id
}

resource "aws_security_group" "windows_sg" {
  name        = "windows_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id
}

resource "aws_security_group_rule" "rule_worker_windows" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.cluster_sg.id
  security_group_id        = aws_security_group.windows_sg.id
}

resource "aws_security_group_rule" "rule_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  security_group_id        = aws_security_group.cluster_sg.id
  source_security_group_id = aws_security_group.windows_sg.id
}