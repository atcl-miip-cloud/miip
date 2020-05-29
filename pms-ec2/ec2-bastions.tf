##### UBUNTU for Bastion Server

resource "aws_instance" "bastion" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = local.ec2_keypair_name
  subnet_id     = data.aws_subnet.public-a.id
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
  ]

  tags = {
    "Name"       = "${local.ec2_prefix}-bastion-public-ubuntu-vm"
    "purpose"    = "Bastion"
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_eip" "bastion" {
  vpc = true
  instance                  = aws_instance.bastion[0].id
  tags = {
    "Name"       = "${local.ec2_prefix}-bastion-eip"
    "purpose"    = "Bastion"
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }
}

output "linux_bastion_elastic_ip" {
  description = "Public Ip of Ubuntu Bastion Server"
  value       = aws_eip.bastion.public_ip
}
