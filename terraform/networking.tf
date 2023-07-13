## VPC
resource "aws_vpc" "main" {
  count = var.vpc_enabled ? 1 : 0
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${local.tag_name}-vpc" 
  }  
}

## Subnets
resource "aws_subnet" "pub_sub" {
  count      = var.pub_sub_enabled ? length(var.pub_sub_cidr) : 0
  vpc_id     = aws_vpc.main[0].id
  cidr_block = var.pub_sub_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.tag_name}-pub-sub-${count.index+1}"
  }  
}

resource "aws_subnet" "pvt_sub" {
  count      = var.pvt_sub_enabled ? length(var.pvt_sub_cidr) : 0
  vpc_id     = aws_vpc.main[0].id
  cidr_block = var.pvt_sub_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.tag_name}-pvt-sub-${count.index+1}"
  }  
}

## Route Tables
resource "aws_route_table" "pub-rt" {
  count      = var.pub_sub_enabled ? length(var.pub_sub_cidr) : 0 
  vpc_id     = aws_vpc.main[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
  tags = {
    Name = "${local.tag_name}-pub-rt-${count.index+1}"
  }   
  timeouts {
    create = "5m"
    delete = "5m"
  }
}

resource "aws_route_table" "pvt-rt" {
  count          = var.pvt_sub_enabled ? length(var.pvt_sub_cidr) : 0 
  vpc_id         = aws_vpc.main[0].id
  /*route {
      cidr_block = "0.0.0.0/0"
      //nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }*/
  tags = {
    Name = "${local.tag_name}-pvt-rt-${count.index+1}"
  }    
  timeouts {
    create = "5m"
    delete = "5m"
  }
}

## Route Table Association
resource "aws_route_table_association" "pub-association" {
  count          = var.pub_sub_enabled ? length(var.pub_sub_cidr) : 0
  subnet_id      = aws_subnet.pub_sub[count.index].id 
  route_table_id = aws_route_table.pub-rt[count.index].id  
}

resource "aws_route_table_association" "pvt-association" {
  count          = var.pvt_sub_enabled ? length(var.pvt_sub_cidr) : 0
  subnet_id      = aws_subnet.pvt_sub[count.index].id 
  route_table_id = aws_route_table.pvt-rt[count.index].id  
}

## IGW
resource "aws_internet_gateway" "igw" {
  count = var.vpc_enabled && var.igw_enabled ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  tags = {
    Name = "${local.tag_name}-igw"
  }
}

## NGW
resource "aws_nat_gateway" "ngw" {
  count = var.nat_enabled ? 1 : 0
  //count         = var.igw_enabled && var.nat_enabled && var.pvt_sub_enabled ? length(var.pvt_sub_cidr) : 0
  allocation_id = aws_eip.ngw_eip[count.index].id
  subnet_id     = aws_subnet.pub_sub[0].id

  tags = {
    Name = "${local.tag_name}-ngw-${count.index+1}"
  }

  depends_on = [aws_internet_gateway.igw]
}

## EIP
resource "aws_eip" "ngw_eip" {
  count   = var.pvt_sub_enabled ? length(var.pvt_sub_cidr) : 0
  vpc     = true
  tags = {
    Name = "${local.tag_name}-eip-${count.index+1}"
  }
  depends_on = [aws_internet_gateway.igw]  
}
