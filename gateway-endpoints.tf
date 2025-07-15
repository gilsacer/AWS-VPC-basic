#################### S3 Gateway Endpoint ####################
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc-basic.id
  service_name      = "com.amazonaws.sa-east-1.s3"
  route_table_ids   = [aws_route_table.rt_private_app.id]
  vpc_endpoint_type = "Gateway"

  policy = <<POLICY
{
"Version": "2012-10-17",
"Statement": [
{
"Action" : [
    "s3:*"
],
"Effect": "Allow",
"Resource": "*",
"Principal": "*"
}
]
}
POLICY
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-S3-vpc-gateway-endpoint"
    }
  )
}
#################### Dynamodb Gateway Endpoint ####################
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.vpc-basic.id
  service_name      = "com.amazonaws.sa-east-1.dynamodb"
  route_table_ids   = [aws_route_table.rt_private_app.id]
  vpc_endpoint_type = "Gateway"

  policy = <<POLICY
{
"Version": "2012-10-17",
"Statement": [
{
"Action" : [
    "dynamodb:*"
],
"Effect": "Allow",
"Resource": "*",
"Principal": "*"
}
]
}
POLICY

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-dynamodb-vpc-gateway-endpoint"
    }
  )
}