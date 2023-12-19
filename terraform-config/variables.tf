variable "region" {
    type    = string
    default = "eu-central-1"
}

variable "availability_zone" {
    type    = string
    default = "eu-central-1a"
}

variable "ec2_ami" {
    type        = string
    default     = "ami-06dd92ecc74fdfb36"
    description = "Ubuntu Server 20.04 LTS (HVM), SSD Volume Type"
}

variable "ec2_type" {
    type    = string
    default = "t2.micro"
}

variable "db_type" {
    type    = string
    default = "db.t2.micro"
}

variable "db_name" {
    type        = string
    default     = "lampStack"
    description = "Database name"
}

variable "db_root_name" {
    type        = string
    sensitive   = true
    description = "Database root user name"
}

variable "db_root_password" {
    type        = string
    sensitive   = true
    description = "Database root user password"
}