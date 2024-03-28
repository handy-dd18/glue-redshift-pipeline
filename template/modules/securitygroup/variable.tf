variable "name" {
    description = "The name of the security group"
    type        = string
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}

variable "env" {
    description = "The environment of the security group"
    type        = string
}