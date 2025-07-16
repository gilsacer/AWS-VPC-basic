resource "aws_subnet" "sub_private_db_1a" {
  vpc_id            = aws_vpc.vpc-basic.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 4)
  availability_zone = "${data.aws_region.current.name}a"

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-Sub-Private-DB-1a"
    }
  )
}

resource "aws_subnet" "sub_private_db_1b" {
  vpc_id            = aws_vpc.vpc-basic.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 5)
  availability_zone = "${data.aws_region.current.name}b"

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-Sub-Private-DB-1b"
    }
  )
}

resource "aws_route_table" "rt_private_db" {
  vpc_id = aws_vpc.vpc-basic.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = var.cidr_block
    gateway_id = "local"
  }
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-RT-Private-DB"
    }
  )
}

resource "aws_route_table_association" "rtb_assoc_priv_db_1a" {
  subnet_id      = aws_subnet.sub_private_db_1a.id
  route_table_id = aws_route_table.rt_private_db.id
}
resource "aws_route_table_association" "rtb_assoc_priv_db_1b" {
  subnet_id      = aws_subnet.sub_private_db_1b.id
  route_table_id = aws_route_table.rt_private_db.id
}