resource "aws_eip" "eip_1a" {
  domain = "vpc"

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-eip-1a"
    }
  )
}

resource "aws_eip" "ngw_eip_1b" {
  domain = "vpc"

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-eip-1b"
    }
  )
}

resource "aws_nat_gateway" "ngw_1a" {
  allocation_id = aws_eip.eip_1a.id
  subnet_id     = aws_subnet.sub_public_alb_1a.id

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-ngw-1a"
    }
  )
}

resource "aws_nat_gateway" "ngw_1b" {
  allocation_id = aws_eip.ngw_eip_1b.id
  subnet_id     = aws_subnet.pvt_d.id

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-ngw-1b"
    }
  )
}