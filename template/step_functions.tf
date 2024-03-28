## StepFunctions 定義
resource "aws_sfn_state_machine" "exec_glue_job_state_machine" {
  name     = var.aws_sfn_state_machine_name
  role_arn = module.exec_glue_job_state_role.iam_role_arn

  definition = templatefile(
    "/files/sf_template/exec_glue_job_state.tftpl",
    {
      glue_job_name = aws_glue_job.redshift_serverless_insert_job.name
    }
  )
}
