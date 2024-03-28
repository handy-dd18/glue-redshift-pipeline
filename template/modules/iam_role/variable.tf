variable "name" {
    description = "The name of the IAM role"
    type        = string
}

variable "policy" {
    description = "The ARN of the IAM policy to attach to the role"
    type        = string
}

variable "identifier" {
    description = "The identifier of the service that will assume the role"
    type        = string
}