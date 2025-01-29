
data "aws_availability_zones" "azs" {
  state = "available"
}
locals {
  public_subnets = { # this is for subnet creation across azs equally
    for idx, cidr_block in var.public_subnets : cidr_block => {
      cidr_block        = cidr_block
      availability_zone = data.aws_availability_zones.azs.names[idx % length(data.aws_availability_zones.azs.names)]
    }
  }
  private_subnets = {
    for idx, cidr_block in var.private_subnets : cidr_block => {
      cidr_block        = cidr_block
      availability_zone = data.aws_availability_zones.azs.names[idx % length(data.aws_availability_zones.azs.names)]
    }
  }
}
