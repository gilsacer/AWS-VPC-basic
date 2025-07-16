resource "aws_vpc_dhcp_options" "dhcp-vpc-basic" {
  domain_name                       = "aws-vpc.internal"
  domain_name_servers               = ["10.100.0.1", "10.100.0.2"]
  ipv6_address_preferred_lease_time = 1440
  ntp_servers                       = ["127.0.0.1"]
  netbios_name_servers              = ["127.0.0.1"]
  netbios_node_type                 = 2

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-dhcp-vpc"
    }
  )
}