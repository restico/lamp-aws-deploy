# VPC
resource "aws_vpc" "lamp-network" {
    cidr_block           = "192.168.1.0/24"
    enable_dns_hostnames = true

    tags = {
        Name = "lamp-network"
    }
}

resource "aws_internet_gateway" "lamp-network-igw" {
    vpc_id = aws_vpc.lamp-network.id

    tags = {
        Name = "lamp-network-igw"
    }
}

resource "aws_subnet" "lamp-subnet" {
    vpc_id                  = aws_vpc.lamp-network.id
    cidr_block              = "192.168.1.0/26"
    availability_zone       = var.availability_zone
    map_public_ip_on_launch = true

    tags = {
        Name = "lamp-subnet"
    }
}

resource "aws_subnet" "empty-subnet" {
    vpc_id            = aws_vpc.lamp-network.id
    cidr_block        = "192.168.1.128/26"
    availability_zone = "eu-central-1b"

    tags = {
        Name = "empty"
    }
  
}

resource "aws_default_route_table" "routing" {
    default_route_table_id = aws_vpc.lamp-network.default_route_table_id

    route {
        cidr_block = "192.168.1.0/24"
        gateway_id = "local"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lamp-network-igw.id
    }

    tags = {
        Name = "main-routing"
    }
}

resource "aws_default_security_group" "web-servers-sg" {
    vpc_id = aws_vpc.lamp-network.id
  
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web-servers-sg"
    }
}

resource "aws_security_group" "loadbalancer-sg" {
    vpc_id      = aws_vpc.lamp-network.id

    name        = "loadbalancer-sg"
    description = "Allow HTTP (80) inbound traffic"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "database-sg" {
    name        = "database-sg"
    description = "Allow MySQL (3306) inbound traffic"
    vpc_id      = aws_vpc.lamp-network.id

    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_default_security_group.web-servers-sg.id]
    }

    tags = {
        Name = "database-sg"
    }
}

resource "aws_db_subnet_group" "db-subnet-group" {
    name        = "subnet-group"
    subnet_ids  = [aws_subnet.lamp-subnet.id, aws_subnet.empty-subnet.id]
    description = "Subnet group"
}