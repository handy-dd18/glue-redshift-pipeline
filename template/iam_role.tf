## StepFunctions 用 IAM Role 定義
module "exec_glue_job_state_role" {
  source     = "./modules/iam_role"
  name       = "exec_glue_job_state_role"
  identifier = "states.amazonaws.com"
  policy     = module.exec_glue_job_state_policy.aws_iam_policy_arn

  depends_on = [
    module.exec_glue_job_state_policy
  ]
}

# EventBridgeルール用IAMロール
module "eventbridge_sfn_role" {
  source     = "./modules/iam_role"
  name       = "eventbridge_sfn_role"
  identifier = "events.amazonaws.com"
  policy     = module.eventbridge_sfn_policy.aws_iam_policy_arn

  depends_on = [
    module.eventbridge_sfn_policy
  ]
}

# Glue Job用IAMロール
module "glue_job_role" {
  source     = "./modules/iam_role"
  name       = "glue_job_role"
  identifier = "glue.amazonaws.com"
  policy     = module.glue_access_policy.aws_iam_policy_arn

  depends_on = [
    module.glue_access_policy
  ]
}

## Redshift Serverless 用 IAM Role 定義
module "redshift_serverless_iam_role" {
  source     = "./modules/iam_role"
  name       = "redshift_serverless_role"
  identifier = "redshift.amazonaws.com"
  policy     = module.redshift_serverless_iam_policy.aws_iam_policy_arn

  depends_on = [
    module.redshift_serverless_iam_policy
  ]
}