resource "aws_subnet" "sub_public_alb_1a" {
  vpc_id                  = aws_vpc.vpc-basic.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, 0)
  availability_zone       = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-Subnet-ALB-1a"
    }
  )
}

resource "aws_subnet" "sub_public_alb_1b" {
  vpc_id                  = aws_vpc.vpc-basic.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, 1)
  availability_zone       = "${data.aws_region.current.name}b"
  map_public_ip_on_launch = false

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-Subnet-ALB-1b"
    }
  )
}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc-basic.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = var.cidr_block
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-RT-Public"
    }
  )
}

resource "aws_route_table_association" "rtb_assoc_pub_1a" {
  subnet_id      = aws_subnet.sub_public_alb_1a.id
  route_table_id = aws_route_table.rt-public.id
}
resource "aws_route_table_association" "rtb_assoc_pub_1b" {
  subnet_id      = aws_subnet.sub_public_alb_1b.id
  route_table_id = aws_route_table.rt-public.id
}