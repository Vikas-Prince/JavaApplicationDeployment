# Create a VPC
resource "aws_vpc" "myVpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Eks-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "vpcSubnet1" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Eks-subnet-1"
  }
}

resource "aws_subnet" "vpcSubnet2" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Eks-subnet-2"
  }
}

resource "aws_subnet" "vpcSubnet3" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Eks-subnet-3"
  }
}

#  Create an Internet Gateway
resource "aws_internet_gateway" "vpcGateway" {
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = "Eks-Gateway"
  }
}

# Create Route Tables
resource "aws_route_table" "vpcRouteTable" {
  vpc_id = aws_vpc.myVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpcGateway.id
  }

  tags = {
    Name = "Eks-Route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.vpcSubnet1.id
  route_table_id = aws_route_table.vpcRouteTable.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.vpcSubnet2.id
  route_table_id = aws_route_table.vpcRouteTable.id
}

resource "aws_route_table_association" "route_table_association_3" {
  subnet_id      = aws_subnet.vpcSubnet3.id
  route_table_id = aws_route_table.vpcRouteTable.id
}

# Create Security Group
resource "aws_security_group" "terraSecuritygp" {
  name        = "EKSSecurityGroup"
  description = "Creating New Security Group for this VPC"
  vpc_id      = aws_vpc.myVpc.id

  # Allow all protocols (not recommended for production)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Consider restricting based on needs
  }

  tags = {
    Name = "Eks-sg"
  }
}


# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "my-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

# Attach necessary policies to EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}



# Create a custom policy
resource "aws_iam_policy" "custom_eks_policy" {
  name        = "CustomEKSAccessPolicy"
  description = "Custom policy to allow EKS actions"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = "eks:*",
        Resource = "*"
      }
    ]
  })
}

# Attach the custom policy to the EKS role
resource "aws_iam_role_policy_attachment" "custom_policy_attachment" {
  policy_arn = aws_iam_policy.custom_eks_policy.arn
  role       = aws_iam_role.eks_cluster_role.name
}


# IAM Role for EKS Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "my-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Attach necessary policies to EKS Node Role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# eks cluster policy 
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = [
      aws_subnet.vpcSubnet1.id,
      aws_subnet.vpcSubnet2.id,
      aws_subnet.vpcSubnet3.id,
    ]
    security_group_ids = [aws_security_group.terraSecuritygp.id]
  }

  depends_on = [
    aws_iam_policy.custom_eks_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]
}


# Launch Template for custom AMI
resource "aws_launch_template" "eks_launch_template" {
  name_prefix   = "eks-"
  image_id      = data.aws_ami.latest-ami.id  # Use the latest AMI from the data source
  instance_type = var.instance_type

  key_name = data.aws_key_pair.eks-key.key_name

  lifecycle {
    create_before_destroy = true
  }
}


# Create EKS Node Group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  node_group_name = "my-node-group"
  subnet_ids      = [
    aws_subnet.vpcSubnet1.id,
    aws_subnet.vpcSubnet2.id,
    aws_subnet.vpcSubnet3.id,
  ]

  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.my_cluster,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only_policy
  ]

  tags = {
    Name = "Worker Nodes"
  }
}
