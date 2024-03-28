# Redshift Serverless 用 名前空間作成
resource "aws_redshiftserverless_namespace" "redshift_serverless_ns" {
  namespace_name        = var.aws_redshiftserverless_namespace_name
  admin_username        = var.aws_redshiftserverless_user_name
  db_name              = var.aws_redshiftserverless_db_name
  manage_admin_password = true
  iam_roles             = [module.redshift_serverless_iam_role.iam_role_arn]
  log_exports           = ["userlog", "connectionlog", "useractivitylog"]
}

# Redshift Serverless 用 ワークグループ作成
resource "aws_redshiftserverless_workgroup" "redshift_serverless_wg" {
  workgroup_name = var.aws_redshiftserverless_workgroup_name
  namespace_name = aws_redshiftserverless_namespace.redshift_serverless_ns.namespace_name
  subnet_ids = [
    var.subnet_private_1a_id,
    var.subnet_private_1c_id,
    var.subnet_private_1d_id
  ]
  base_capacity        = 8
  enhanced_vpc_routing = true

  # 必要に応じてコメントアウトを解除してください
  # config_parameter {
  #     parameter_key = "auto_mv"
  #     parameter_value = "true"
  # }
  # config_parameter {
  #     parameter_key = "datestyle"
  #     parameter_value = "ISO, MDY"
  # }
  # config_parameter {
  #     parameter_key = "enable_case_sensitive_identifier"
  #     parameter_value = "false"
  # }
  # config_parameter {
  #     parameter_key = "enable_user_activity_logging"
  #     parameter_value = "true"
  # }
  # config_parameter {
  #     parameter_key = "query_group"
  #     parameter_value = "default"
  # }
  # config_parameter {
  #     parameter_key = "require_ssl"
  #     parameter_value = "false"
  # }
  # config_parameter {
  #     parameter_key = "search_path"
  #     parameter_value = "$user, public"
  # }
  # config_parameter {
  #     parameter_key = "use_fips_ssl"
  #     parameter_value = "false"
  # }

  # config_parameter {
  #     parameter_key = "max_query_cpu_time"
  #     parameter_value = 1
  # }
  # config_parameter {
  #     parameter_key = "max_query_blocks_read"
  #     parameter_value = 2
  # }
  # config_parameter {
  #     parameter_key = "max_scan_row_count"
  #     parameter_value = 3
  # }
  # config_parameter {
  #     parameter_key = "max_query_execution_time"
  #     parameter_value = 4
  # }
  # config_parameter {
  #     parameter_key = "max_query_queue_time"
  #     parameter_value = 5
  # }
  # config_parameter {
  #     parameter_key = "max_query_cpu_usage_percent"
  #     parameter_value = 6
  # }
  # config_parameter {
  #     parameter_key = "max_query_temp_blocks_to_disk"
  #     parameter_value = 7
  # }
  # config_parameter {
  #     parameter_key = "max_join_row_count"
  #     parameter_value = 8
  # }
  # config_parameter {
  #     parameter_key = "max_nested_loop_join_row_count"
  #     parameter_value = 9
  # }

  publicly_accessible = false
  security_group_ids = [
    module.redshift_serverless_security_group.security_group_id
  ]
}