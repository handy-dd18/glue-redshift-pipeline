# Glue Jobスクリプト格納用S3バケット
resource "aws_s3_bucket" "glue_scripts_bucket" {
  bucket = "glue-script-${data.aws_caller_identity.current.account_id}"

  force_destroy = true
}

# Glue Job 一時データ格納用S3バケット
resource "aws_s3_bucket" "glue_temp_bucket" {
  bucket = "glue-temp-${data.aws_caller_identity.current.account_id}"

  force_destroy = true
}

# 生データ格納用S3バケット
resource "aws_s3_bucket" "raw_data_bucket" {
  bucket = "raw-data-${data.aws_caller_identity.current.account_id}"

  force_destroy = true
}

resource "aws_s3_bucket_notification" "raw_data_bucket_notification" {
  bucket      = aws_s3_bucket.raw_data_bucket.id
  eventbridge = true
}

# サンプルCSVファイルアップロード
resource "aws_s3_object" "sample_file" {
  bucket = aws_s3_bucket.raw_data_bucket.bucket
  key    = "from_samplesystem/sample_data/${var.sample_file_name}"
  source = "/files/sample_data/${var.sample_file_name}"

  depends_on = [
    aws_s3_bucket.raw_data_bucket,
    aws_redshiftserverless_workgroup.redshift_serverless_wg,
    aws_glue_job.redshift_serverless_insert_job,
    aws_cloudwatch_event_rule.trigger_state_machine,
    aws_sfn_state_machine.exec_glue_job_state_machine
  ]
}