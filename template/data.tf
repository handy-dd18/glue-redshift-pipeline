# AWSアカウントの情報を取得するための設定
data "aws_caller_identity" "current" {}

data "aws_redshiftserverless_workgroup" "redshift_serverless_wg" {
  workgroup_name = aws_redshiftserverless_workgroup.redshift_serverless_wg.workgroup_name
}

data "aws_redshiftserverless_namespace" "redshift_serverless_ns" {
  namespace_name = aws_redshiftserverless_namespace.redshift_serverless_ns.namespace_name
}