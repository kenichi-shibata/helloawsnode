resource "aws_vpc" "platform_vpc" {
  cidr_block = "172.1.0.0/16"

  tags = {
          Name = "${var.pre_tag}-${var.platform_name}-vpc"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "internet" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  tags = {
          Name        = "${var.pre_tag}-${var.service_name}-pmry-igw"
          Region      = "${var.business_region}"
          Environment = "${var.environment}"
  }
}

resource "aws_subnet" "primary_public" {
  vpc_id                  = "${aws_vpc.platform_vpc.id}"
  cidr_block              = "172.1.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
          Name        = "${var.pre_tag}-${var.service_name}-pmry-pub"
          Region      = "${var.business_region}"
          Environment = "${var.environment}"
  }
}

resource "aws_subnet" "primary_private" {
  vpc_id                  = "${aws_vpc.platform_vpc.id}"
  cidr_block              = "172.1.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags = {
          Name        = "${var.pre_tag}-${var.service_name}-pmry-pvt"
          Region      = "${var.business_region}"
          Environment = "${var.environment}"
  }
}

resource "aws_subnet" "secondary_public" {
  vpc_id                  = "${aws_vpc.platform_vpc.id}"
  cidr_block              = "172.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
          Name        = "${var.pre_tag}-${var.service_name}-sdry-pub"
          Region      = "${var.business_region}"
          Environment = "${var.environment}"
  }
}

resource "aws_subnet" "secondary_private" {
  vpc_id                  = "${aws_vpc.platform_vpc.id}"
  cidr_block              = "172.1.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags = {
          Name        = "${var.pre_tag}-${var.service_name}-sdry-pvt"
          Region      = "${var.business_region}"
          Environment = "${var.environment}"
  }
}

## create an elastic ip
resource "aws_eip" "primary_eip" {
  vpc                    = true
}

resource "aws_eip" "secondary_eip" {
  vpc                    = true
}

## create a nat gateway for private_primary subnet
resource "aws_nat_gateway" "primary_nat" {
    allocation_id         = "${aws_eip.primary_eip.id}"
    subnet_id             = "${aws_subnet.primary_public.id}"
}

resource "aws_nat_gateway" "secondary_nat" {
    allocation_id         = "${aws_eip.secondary_eip.id}"
    subnet_id             = "${aws_subnet.secondary_public.id}"
}

resource "aws_route_table" "public_route" {
  vpc_id                  = "${aws_vpc.platform_vpc.id}"

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = "${aws_internet_gateway.internet.id}"
  }

  tags {
    Name        = "${var.pre_tag}-internet-gateway"
    Region      = "${var.business_region}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "primary_nat_route" {
  vpc_id                  = "${aws_vpc.platform_vpc.id}"

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = "${aws_nat_gateway.primary_nat.id}"
  }

  tags {
    Name        = "${var.pre_tag}-${var.service_name}-pmry-nat"
    Region      = "${var.business_region}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "secondary_nat_route" {
  vpc_id                  = "${aws_vpc.platform_vpc.id}"

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = "${aws_nat_gateway.secondary_nat.id}"
  }

  tags {
    Name        = "${var.pre_tag}-${var.service_name}-sdry-nat"
    Region      = "${var.business_region}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "primary_public" {
  subnet_id      = "${aws_subnet.primary_public.id}"
  route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_route_table_association" "primary_private" {
  subnet_id      = "${aws_subnet.primary_private.id}"
  route_table_id = "${aws_route_table.primary_nat_route.id}"
}

resource "aws_route_table_association" "secondary_public" {
  subnet_id      = "${aws_subnet.secondary_public.id}"
  route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_route_table_association" "secondary_private" {
  subnet_id      = "${aws_subnet.secondary_private.id}"
  route_table_id = "${aws_route_table.secondary_nat_route.id}"
}


