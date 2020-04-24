resource "aws_security_group" "aws-cluster" {
  name        = "${var.generated-cluster-name}-cluster-security-group"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc-id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.generated-cluster-name}-cluster-security-group"
  }
}

resource "aws_security_group_rule" "aws-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aws-cluster.id
  source_security_group_id = aws_security_group.aws-node.id
  to_port                  = 443
  type                     = "ingress"
}

/* Retaining this commented block for future reference- see https://github.com/terraform-aws-modules/terraform-aws-eks/issues/62

resource "aws_security_group_rule" "aws-cluster-ingress-workstation-https" {
  cidr_blocks       = [var.workstation_cidr_block]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.aws-cluster.id
  to_port           = 443
  type              = "ingress"
}
*/