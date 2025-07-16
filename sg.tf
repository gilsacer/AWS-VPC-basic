resource "aws_security_group" "app" {
  name        = "App"
  description = "Allow public inbound traffic"
  vpc_id      = aws_vpc.vpc-basic.id

  ingress {
    from_port       = 80 # http
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port       = 443 # https
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "Web Server" })
}

#### SG Database ####
resource "aws_security_group" "db" {
  name        = "DB"
  description = "Allow incoming database connections"
  vpc_id      = aws_vpc.vpc-basic.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id, aws_security_group.bastion.id]
  }

  egress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id, aws_security_group.bastion.id]
  }

  tags = merge(local.tags, { Name = "Database MySQL" })
}

#### SG Load Balancer ####
resource "aws_security_group" "alb" {
  name        = "ALB-SG"
  description = "Load Balancer SG"
  vpc_id      = aws_vpc.vpc-basic.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "Load Balancer" })
}

#### SG Bastion Host ####
resource "aws_security_group" "bastion" {
  name        = "Bastion"
  description = "Allow incoming connections to Bastion machine"
  vpc_id      = aws_vpc.vpc-basic.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc-basic.cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.vpc-basic.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc-basic.cidr_block]
  }
  tags = merge(local.tags, { Name = "Bastion" })
}