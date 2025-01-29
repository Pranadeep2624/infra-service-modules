resource "aws_vpc" "main" {
  cidr_block           = var.cidr_base
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name                                                                   = "${var.environment}-${var.app_name}-vpc",
    "kubernetes.io/cluster/${var.environment}-${var.app_name}-eks-cluster" = "shared",
  })

}



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  depends_on = [aws_vpc.main]
  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}-igw"
  })
}





/* Subnets creation */
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.main.id
  for_each                = local.public_subnets
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true
  availability_zone       = each.value.availability_zone
  tags = merge(var.tags, {
    "Name"                                                                 = "${var.environment}-${var.app_name}-publicsubnet",
    "kubernetes.io/cluster/${var.environment}-${var.app_name}-eks-cluster" = "shared",
    "kubernetes.io/role/elb"                                               = 1
  })
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.main.id
  for_each                = local.private_subnets
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false
  availability_zone       = each.value.availability_zone
  tags = merge(var.tags, {
    "Name"                                                                 = "${var.environment}-${var.app_name}-privatesubnet",
    "kubernetes.io/cluster/${var.environment}-${var.app_name}-eks-cluster" = "shared",
    "kubernetes.io/role/internal-elb"                                      = 1
  })
}


/*Elastic IP and nat gateway */
resource "aws_eip" "nat_eip" {
  count  = var.create_nat ? 1 : 0
  domain = "vpc"
  tags = merge(var.tags, {
    "Name" = "${var.environment}-${var.app_name}-eip"
  })
}
resource "aws_nat_gateway" "nat" {
  count         = var.create_nat ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnets[var.public_subnets[0]].id
  depends_on    = [aws_internet_gateway.gw]

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}-nat"
  })
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}-private-route-table"

  })
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.app_name}-public-route-table"

  })
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.create_nat ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

/* Route table associations */


resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
