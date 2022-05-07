module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
}

# Security Group - Allow SSH
resource "aws_security_group" "sg_allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic from home IP & local subnet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from specific CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = flatten([var.ssh_source_address, module.vpc.public_subnets_cidr_blocks])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg_allow_ssh"
  }
}

# Security Group - Allow WebUI
resource "aws_security_group" "sg_allow_webui" {
  name        = "allow_webui"
  description = "Allow WebUI inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "WebUI from specific CIDR"
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = [var.ssh_source_address]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg_allow_webui"
  }
}

module "sg_consul_server" {
  source = "terraform-aws-modules/security-group/aws//modules/consul"

  name        = "sg_consul_server"
  description = "Security group for Consul server"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = flatten([module.vpc.private_subnets_cidr_blocks, module.vpc.public_subnets_cidr_blocks])
  ingress_rules       = ["consul-tcp", "consul-webui-http-tcp", "consul-serf-lan-tcp", "consul-serf-lan-udp"]

  tags = {
    Name = "${var.project_name}-sg_consul_server"
  }
}

module "sg_consul_client" {
  source = "terraform-aws-modules/security-group/aws//modules/consul"

  name        = "sg_consul_client"
  description = "Security group for Consul client"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = flatten([module.vpc.public_subnets_cidr_blocks, module.vpc.private_subnets_cidr_blocks])
  ingress_rules       = ["consul-serf-lan-tcp", "consul-serf-lan-udp"]

  tags = {
    Name = "${var.project_name}-sg_consul_client"
  }
}
