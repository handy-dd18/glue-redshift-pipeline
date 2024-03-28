resource "aws_iam_policy" "default" {
  name   = var.name
  policy = data.aws_iam_policy_document.default.json
}