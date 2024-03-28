# Glue Jobスクリプト内のS3バケット名を修正
resource "null_resource" "redshift_serverless_insert_job_s3_bucket" {
  triggers = {
    s3_bucket_name = aws_s3_bucket.glue_temp_bucket.bucket
  }

  provisioner "local-exec" {
    command = "sed -i 's/__TEMP_S3_BUCKET_NAME__/${self.triggers.s3_bucket_name}/g' /files/python_script/${var.s3_glue_redshift_insert_job_script_file_name}"
  }

  depends_on = [
    aws_s3_bucket.glue_temp_bucket
  ]
}

# Glue Jobスクリプト内のRedshift Connection名を修正
resource "null_resource" "redshift_serverless_insert_job_redshift_connection" {
  triggers = {
    redshift_connection_name = aws_glue_connection.redshift_serverless_connection.name
  }

  provisioner "local-exec" {
    command = "sed -i 's/__REDSHIFT_CONNECTION_NAME__/${self.triggers.redshift_connection_name}/g' /files/python_script/${var.s3_glue_redshift_insert_job_script_file_name}"
  }

  depends_on = [
    null_resource.redshift_serverless_insert_job_s3_bucket
  ]
}

# Glue Jobスクリプトアップロード
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.glue_scripts_bucket.bucket
  key    = "scripts/${var.s3_glue_redshift_insert_job_script_file_name}"
  source = "/files/python_script/${var.s3_glue_redshift_insert_job_script_file_name}"

  depends_on = [
    null_resource.redshift_serverless_insert_job_redshift_connection,
    null_resource.redshift_serverless_insert_job_s3_bucket
  ]
}