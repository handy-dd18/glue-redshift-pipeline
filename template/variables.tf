variable "vpc_id" {
    description = "VPC ID"
    type        = string
}

variable "subnet_private_1a_id" {
    description = "Subnet Private01a ID"
    type        = string
}

variable "subnet_private_1c_id" {
    description = "Subnet Private01c ID"
    type        = string
}

variable "subnet_private_1d_id" {
    description = "Subnet Private01d ID"
    type        = string
}

variable "s3_glue_redshift_insert_job_script_file_name" {
    description = "Glue Jobスクリプトファイル名"
    type        = string
    default     = "s3-glue-redshift-insert-job.py"
}

variable "redshift_serverless_insert_job_name" {
    description = "Glue Job名"
    type        = string
    default     = "redshift-insert-job"
}

variable "aws_secretsmanager_secret_name" {
    description = "Redshift Serverless用のSecrets Manager名"
    type        = string
    default     = "redshift!redshift-serverless-ns-admin"
}

variable "aws_glue_connection_vpc_connection_name" {
    description = "VPC Connection名"
    type        = string
    default     = "VPC Connection"
}

variable "aws_glue_connection_redshift_serverless_connection_name" {
    description = "Redshift Serverless Connection名"
    type        = string
    default     = "Redshift Serverless Connection"
}

variable "aws_sfn_state_machine_name" {
    description = "StepFunctions State Machine名"
    type        = string
    default     = "exec_glue_job_state_machine"
}

variable "aws_redshiftserverless_namespace_name" {
    description = "Redshift Serverless Namespace名"
    type        = string
    default     = "redshift-serverless-ns"
}

variable "aws_redshiftserverless_workgroup_name" {
    description = "Redshift Serverless Workgroup名"
    type        = string
    default     = "redshift-serverless-wg"
}

variable "aws_redshiftserverless_user_name" {
    description = "Redshift Serverless ユーザ名"
    type        = string
    default     = "admin"
}

variable "aws_redshiftserverless_db_name" {
    description = "Redshift Serverless DB名"
    type        = string
    default     = "dev"
}

variable "aws_cloudwatch_event_rule_name" {
    description = "EventBridgeルール名"
    type        = string
    default     = "trigger-step-functions-rule"
}

variable "aws_cloudwatch_event_target_id" {
    description = "EventBridgeルールターゲットID"
    type        = string
    default     = "StepFunctionsTarget"
}

variable "sample_file_name" {
    description = "サンプルファイル名"
    type        = string
    default     = "sample_data_utf8.csv"
}