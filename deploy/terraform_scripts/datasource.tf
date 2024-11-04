data "aws_ami" "latest-ami" {
  most_recent = true

  owners = ["602401143452"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-*-v*"]
  }
}


data "aws_key_pair" "eks-key"{
    key_name = "EKS-Cluster"
}
