output "webserver-1-public-ip" {
    value = aws_instance.webserver-1.public_ip
}

output "webserver-2-public-ip" {
    value = aws_instance.webserver-2.public_ip
}

output "mysql-hostname" {
    value = aws_db_instance.mysql-database.address
}

output "load_balancer_address" {
    value = aws_elb.lamp-loadbalancer.dns_name
}