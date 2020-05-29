resource "aws_security_group" "rdp" {
  name        = "sg_rdp_public_${var.project_name}"
  vpc_id      = data.aws_vpc.mvp-vpc.id
  description = "Allow RDP inbound traffic from internet"

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "ssh" {
  name        = "sg_ssh_public_${var.project_name}"
  vpc_id      = data.aws_vpc.mvp-vpc.id
  description = "Allow RDP inbound traffic from internet"

    ingress {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      description = ""
    }
    ingress {
      from_port = -1
      to_port   = -1
      protocol  = "icmp"
      cidr_blocks = [ "0.0.0.0/0" ]
      description = ""
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
