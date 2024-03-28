data "aws_iam_policy_document" "default" {
  dynamic "statement" {
    for_each = var.policy_statements

    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}