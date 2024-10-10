# Step 2: Create Subnets 

# Get available zones 

data "aws_availability_zones" "available" { state = "available" }

# Step 2-1: Create Subnets

locals {
  actual_private_subnet_count = min(var.total_private_subnets, length(data.aws_availability_zones.available.names))
  actual_public_subnet_count  = min(var.total_public_subnets, length(data.aws_availability_zones.available.names))
}

resource "aws_subnet" "subnets_public" {
  count                   = local.actual_public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, var.subnet_size, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "subnets_private" {
  count             = local.actual_private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, var.subnet_size, count.index + 3)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-route-table"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_rt_association" {
  count          = local.actual_public_subnet_count
  subnet_id      = aws_subnet.subnets_public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_rt_association" {
  count          = local.actual_private_subnet_count
  subnet_id      = aws_subnet.subnets_private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Create Route for Public Subnets (Internet Access)
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}