data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.bastion_instance_type
  key_name               = var.instance_key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.sg_allow_ssh.id]

  tags = {
    Name = "${var.project_name}-bastion_host"
  }
}

resource "aws_instance" "consul_server" {
  ami                    = data.aws_ami.ubuntu.id
  count                  = 3
  instance_type          = var.instance_type
  key_name               = var.instance_key_name
  subnet_id              = module.vpc.private_subnets[count.index]
  user_data              = file("scripts/server_user_data.sh")
  vpc_security_group_ids = [module.sg_consul_server.security_group_id, aws_security_group.sg_allow_ssh.id, aws_security_group.sg_allow_webui.id]

  tags = {
    Name = "${var.project_name}-consul_server-${count.index}"
  }
}

resource "aws_instance" "consul_client" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.instance_key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.sg_consul_client.security_group_id, aws_security_group.sg_allow_ssh.id]

  tags = {
    Name = "${var.project_name}-consul_client"
  }
}
