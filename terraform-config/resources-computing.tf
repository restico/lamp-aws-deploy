# Keys
resource "tls_private_key" "key-1" {
    algorithm = "ED25519"
}

resource "tls_private_key" "key-2" {
    algorithm = "ED25519"
}

resource "local_sensitive_file" "key-1-file" {
    content  = tls_private_key.key-1.private_key_openssh
    filename = "key-1.pem"
}

resource "local_sensitive_file" "key-2-file" {
    content  = tls_private_key.key-2.private_key_openssh
    filename = "key-2.pem"
}

# EC2
resource "aws_key_pair" "aws-key-1" {
    key_name   = "webserver-key-1"
    public_key = tls_private_key.key-1.public_key_openssh
}

resource "aws_key_pair" "aws-key-2" {
    key_name   = "webserver-key-2"
    public_key = tls_private_key.key-2.public_key_openssh
}

resource "aws_instance" "webserver-1" {
    ami                    = var.ec2_ami
    instance_type          = var.ec2_type

    key_name               = aws_key_pair.aws-key-1.key_name

    subnet_id              = aws_subnet.lamp-subnet.id
    vpc_security_group_ids = [aws_default_security_group.web-servers-sg.id]

    root_block_device {
        volume_size = "8"
        volume_type = "gp2"
    }

    tags = {
        Name = "webserver-1"
    }
}

resource "aws_instance" "webserver-2" {
    ami                    = var.ec2_ami
    instance_type          = var.ec2_type

    key_name               = aws_key_pair.aws-key-2.key_name

    subnet_id              = aws_subnet.lamp-subnet.id
    vpc_security_group_ids = [aws_default_security_group.web-servers-sg.id]

    root_block_device {
        volume_size = "8"
        volume_type = "gp2"
    }

    tags = {
        Name = "webserver-2"
    }
}

# RDS
resource "aws_db_instance" "mysql-database" {
    identifier             = "mysql-database"

    db_name                = var.db_name
    engine                 = "mysql"
    engine_version         = "8.0.33"
    instance_class         = var.db_type
    allocated_storage      = 20
    max_allocated_storage  = 20

    username               = var.db_root_name
    password               = var.db_root_password

    availability_zone      = var.availability_zone
    db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.name
    vpc_security_group_ids = [aws_security_group.database-sg.id]

    multi_az               = false
    apply_immediately      = true
    skip_final_snapshot    = true

    publicly_accessible    = false
}

# ELB
resource "aws_elb" "lamp-loadbalancer" {
    name               = "lamp-loadbalancer"
    internal           = false

    security_groups    = [aws_security_group.loadbalancer-sg.id]
    subnets            = [aws_subnet.lamp-subnet.id]

    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80/index.php"
        interval            = 30
    }

    instances = [aws_instance.webserver-1.id, aws_instance.webserver-2.id]

    tags = {
        Name = "lamp-loadbalancer"
    }
}