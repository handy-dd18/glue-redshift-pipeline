# Redshift Serverless用のSecrets Manager定義
data "aws_secretsmanager_secret" "redshift_serverless_secret" {
  name = var.aws_secretsmanager_secret_name

  depends_on = [
    aws_redshiftserverless_namespace.redshift_serverless_ns,
    aws_redshiftserverless_workgroup.redshift_serverless_wg,
    ]
}

# Redshift Serverless Connection定義
resource "aws_glue_connection" "redshift_serverless_connection" {
  name = var.aws_glue_connection_redshift_serverless_connection_name
  connection_type = "JDBC"

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:redshift://${data.aws_redshiftserverless_workgroup.redshift_serverless_wg.endpoint[0].address}:${data.aws_redshiftserverless_workgroup.redshift_serverless_wg.endpoint[0].port}/${data.aws_redshiftserverless_namespace.redshift_serverless_ns.db_name}"
    SECRET_ID           = data.aws_secretsmanager_secret.redshift_serverless_secret.name
  }

  physical_connection_requirements {
    availability_zone = "ap-northeast-1a"
    security_group_id_list = [module.redshift_connection_sg.security_group_id]
    subnet_id              = var.subnet_private_1a_id
  }

  depends_on = [
    aws_redshiftserverless_namespace.redshift_serverless_ns,
    aws_redshiftserverless_workgroup.redshift_serverless_wg,
    module.redshift_connection_sg.security_group_id,
  ]
}

# VPC Connection定義
resource "aws_glue_connection" "vpc_connection" {
  name = var.aws_glue_connection_vpc_connection_name
  connection_type = "NETWORK"

  physical_connection_requirements {
    availability_zone = "ap-northeast-1a"
    security_group_id_list = [module.vpc_connection_sg.security_group_id]
    subnet_id              = var.subnet_private_1a_id
  }

  depends_on = [
    module.vpc_connection_sg.security_group_id,
  ]
}