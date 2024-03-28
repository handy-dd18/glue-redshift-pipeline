# VPC Connection用のセキュリティグループ作成
module "vpc_connection_sg" {
  source = "./modules/securitygroup"
  name   = "vpc-connection-sg"
  vpc_id = var.vpc_id
  env    = "dev"
}

# VPC Connection用のセキュリティグループルール作成(default)
resource "aws_security_group_rule" "vpc_connection_sg_default" {
  security_group_id = module.vpc_connection_sg.security_group_id

  # 自身のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.vpc_connection_sg.security_group_id
}

# Redshift Connection用のセキュリティグループ作成
module "redshift_connection_sg" {
  source = "./modules/securitygroup"
  name   = "redshift-connection-sg"
  vpc_id = var.vpc_id
  env    = "dev"
}

# Redshift Connection用のセキュリティグループルール作成(default)
resource "aws_security_group_rule" "redshift_connection_sg_default" {
  security_group_id = module.redshift_connection_sg.security_group_id

  # 自身のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.redshift_connection_sg.security_group_id
}

# Redshift Connection用のセキュリティグループルール作成(Glue Job)
resource "aws_security_group_rule" "redshift_connection_sg_glue_job" {
  security_group_id = module.redshift_connection_sg.security_group_id

  # 自身のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.vpc_connection_sg.security_group_id
}

# Redshift Serverless 用のセキュリティグループ作成
module "redshift_serverless_security_group" {
  source = "./modules/securitygroup"
  name   = "redshift-serverless-1-sg"
  vpc_id = var.vpc_id
  env    = "dev"
}

# Redshift Serverless 用のセキュリティグループルール作成(default)
resource "aws_security_group_rule" "redshift_serverless_default" {
  security_group_id = module.redshift_serverless_security_group.security_group_id

  # 自身のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.redshift_serverless_security_group.security_group_id
}

# Redshift Serverless 用のセキュリティグループルール作成(innervpc)
resource "aws_security_group_rule" "redshift_serverless_innervpc" {
  security_group_id = module.redshift_serverless_security_group.security_group_id

  # VPC内の全てのリソースからのingressアクセスを許可
  type      = "ingress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  cidr_blocks = [
    "10.0.0.0/8",
  ]
}

# Redshift Serverless 用のセキュリティグループルール作成(glue)
resource "aws_security_group_rule" "redshift_serverless_glue" {
  security_group_id = module.redshift_serverless_security_group.security_group_id

  # Glue用のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.vpc_connection_sg.security_group_id
}

# Redshift Serverless 用のセキュリティグループルール作成(redshift connection)
resource "aws_security_group_rule" "redshift_serverless_redshift_connection" {
  security_group_id = module.redshift_serverless_security_group.security_group_id

  # Glue用のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.redshift_connection_sg.security_group_id
}

# S3インターフェースエンドポイント用のセキュリティグループ作成
module "s3_interface_endpoint_security_group" {
  source = "./modules/securitygroup"
  name   = "s3-interface-endpoint-sg"
  vpc_id = var.vpc_id
  env    = "dev"
}

# S3インターフェースエンドポイント用のセキュリティグループルール作成(Glue Job Connection)
resource "aws_security_group_rule" "s3_intarface_endpoint" {
  security_group_id = module.s3_interface_endpoint_security_group.security_group_id

  # Glue用のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.vpc_connection_sg.security_group_id

  depends_on = [
    module.s3_interface_endpoint_security_group
  ]
}

# S3インターフェースエンドポイント用のセキュリティグループルール作成(Redshift Connection)
resource "aws_security_group_rule" "s3_intarface_endpoint_ingress_redshift" {
  security_group_id = module.s3_interface_endpoint_security_group.security_group_id

  # Glue用のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.redshift_connection_sg.security_group_id

  depends_on = [
    module.s3_interface_endpoint_security_group
  ]
}

# S3インターフェースエンドポイント用のセキュリティグループルール作成(Redshift)
resource "aws_security_group_rule" "s3_intarface_endpoint_ingress_redshiftserverless" {
  security_group_id = module.s3_interface_endpoint_security_group.security_group_id

  # Redshift用のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.redshift_serverless_security_group.security_group_id

  depends_on = [
    module.s3_interface_endpoint_security_group
  ]
}

# SecretsManagerインターフェースエンドポイント用のセキュリティグループ作成
module "secretsmanager_interface_endpoint_security_group" {
  source = "./modules/securitygroup"
  name   = "secretsmanager-interface-endpoint-sg"
  vpc_id = var.vpc_id
  env    = "dev"
}

# SecretsManagerインターフェースエンドポイント用のセキュリティグループルール作成
resource "aws_security_group_rule" "secretsmanager_intarface_endpoint" {
  security_group_id = module.secretsmanager_interface_endpoint_security_group.security_group_id

  # Glue用のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.secretsmanager_interface_endpoint_security_group.security_group_id

  depends_on = [
    module.secretsmanager_interface_endpoint_security_group
  ]
}

# SecretsManagerインターフェースエンドポイント用のセキュリティグループルール作成(Glue Job)
resource "aws_security_group_rule" "secretsmanager_intarface_endpoint_ingress_glue" {
  security_group_id = module.secretsmanager_interface_endpoint_security_group.security_group_id

  # Glue用のセキュリティグループからのingressアクセスを許可
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.vpc_connection_sg.security_group_id

  depends_on = [
    module.secretsmanager_interface_endpoint_security_group
  ]
}