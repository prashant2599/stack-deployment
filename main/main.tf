resource "aws_vpc" "ecsvpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      "env" = "dev"
    }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.ecsvpc.id


    tags = {
      "name" = "dev-igw"
    }
  
}

resource "aws_subnet" "publicsubnet1" {
    cidr_block = var.pub_cidr_block_1
    vpc_id = aws_vpc.ecsvpc.id
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true

    tags = {
      "name" = "pubsub1"
    }
  
}

resource "aws_subnet" "publicsubnet2" {
    cidr_block = var.pub_cidr_block_2
    vpc_id = aws_vpc.ecsvpc.id
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
    tags = {
      "name" = "pubsub2"
    }
  
}


resource "aws_eip" "ecseip1" {
    tags = {
      "name" = "ecseip1"
    }
}

resource "aws_eip" "ecseip2" {
    tags = {
      "name" = "ecseip2"
    }
}

resource "aws_nat_gateway" "nateip1" {
    subnet_id = aws_subnet.publicsubnet1.id
    allocation_id = aws_eip.ecseip1.id 
}


resource "aws_nat_gateway" "nateip2" {
    subnet_id = aws_subnet.publicsubnet2.id
    allocation_id = aws_eip.ecseip2.id 
}


resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.ecsvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "pubrta" {
    route_table_id = aws_route_table.pubrt.id
    subnet_id = aws_subnet.publicsubnet1.id
}

resource "aws_route_table_association" "pubrtb" {
    route_table_id = aws_route_table.pubrt.id
    subnet_id = aws_subnet.publicsubnet2.id  
}

resource "aws_subnet" "privatesubnet1" {
    vpc_id = aws_vpc.ecsvpc.id
    cidr_block = var.pri_cidr_block_1
    availability_zone = "ap-south-1a"

    tags = {
      "name" = "prisub1"
    }
}

resource "aws_subnet" "privatesubnet2" {
    vpc_id = aws_vpc.ecsvpc.id
    cidr_block = var.pri_cidr_block_2
    availability_zone = "ap-south-1b"

    tags = {
      "name" = "prisub1=2"
    }
}

resource "aws_route_table" "prirt1" {
  vpc_id = aws_vpc.ecsvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nateip1.id
  }
}

resource "aws_route_table" "prirt2" {
  vpc_id = aws_vpc.ecsvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nateip2.id
  }
}

resource "aws_route_table_association" "privatert1" {
  route_table_id = aws_route_table.prirt1.id
  subnet_id = aws_subnet.privatesubnet1.id
}

resource "aws_route_table_association" "privatert2" {
  route_table_id = aws_route_table.prirt2.id
  subnet_id = aws_subnet.privatesubnet2.id
}

resource "aws_ecs_cluster" "ecs-ec2" {
  name = var.ecs_name
  tags = {
    "name" = "dev"
  }
  
}
