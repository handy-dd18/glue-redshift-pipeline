variable "name" {
    description = "The name of the IAM policy"
    type        = string
}

variable "policy_statements" {
  description = "A list of policy statements"
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}