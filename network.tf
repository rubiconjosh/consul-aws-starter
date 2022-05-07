resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public_subnet"
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Route
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public_route_table"
  }
}

resource "aws_route_table_association" "route_table_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.route_table.id
}

# Security Group - Allow SSH
resource "aws_security_group" "sg_allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic from home IP & local subnet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from specific CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_source_address, aws_subnet.public.cidr_block]
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
  vpc_id      = aws_vpc.main.id

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
  vpc_id      = aws_vpc.main.id

  ingress_cidr_blocks = [aws_subnet.public.cidr_block]
  ingress_rules       = ["consul-tcp", "consul-webui-http-tcp", "consul-serf-lan-tcp", "consul-serf-lan-udp"]

  tags = {
    Name = "${var.project_name}-sg_consul_server"
  }
}

module "sg_consul_client" {
  source = "terraform-aws-modules/security-group/aws//modules/consul"

  name        = "sg_consul_client"
  description = "Security group for Consul client"
  vpc_id      = aws_vpc.main.id

  ingress_cidr_blocks = [aws_subnet.public.cidr_block]
  ingress_rules       = ["consul-serf-lan-tcp", "consul-serf-lan-udp"]

  tags = {
    Name = "${var.project_name}-sg_consul_client"
  }
}
