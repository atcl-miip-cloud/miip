data "aws_vpc" "mvp-vpc" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnet" "public-a" {
  vpc_id = data.aws_vpc.mvp-vpc.id
  tags = {
    tier = "public"
  }
  availability_zone = "${var.region}a"
}

data "aws_subnet" "public-c" {
  vpc_id = data.aws_vpc.mvp-vpc.id
  tags = {
    tier = "public"
  }
  availability_zone = "${var.region}c"
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.mvp-vpc.id
  tags = {
    tier = "private"
  }
}

data "aws_subnet_ids" "database" {
  vpc_id = data.aws_vpc.mvp-vpc.id
  tags = {
    tier = "private"
  }
}
