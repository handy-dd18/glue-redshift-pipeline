# Glue Jobリソース定義
resource "aws_glue_job" "redshift_serverless_insert_job" {
  name     = var.redshift_serverless_insert_job_name
  role_arn = module.glue_job_role.iam_role_arn

  command {
    script_location = "s3://${aws_s3_object.glue_script.bucket}/${aws_s3_object.glue_script.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"             = "s3://${aws_s3_object.glue_script.bucket}/temporary/"
    "--job-bookmark-option" = "job-bookmark-disable"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
    "--enable-spark-ui"                  = "true"
  }

  max_retries       = 0
  timeout           = 2880
  worker_type       = "G.1X"
  number_of_workers = 2

  execution_property {
    max_concurrent_runs = 10
  }

  connections = [
    aws_glue_connection.vpc_connection.name,
    aws_glue_connection.redshift_serverless_connection.name
  ]

  glue_version = "4.0"
}
