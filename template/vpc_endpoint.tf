# S3インターフェースエンドポイント作成
resource "aws_vpc_endpoint" "interface_s3" {
  vpc_id            = var.vpc_id
  subnet_ids        = [
    var.subnet_private_1a_id,
  ]
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    module.s3_interface_endpoint_security_group.security_group_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "s3-interface-endpoint"
    Env  = "shared"
  }
}

# SecretsManagerインターフェースエンドポイント作成
resource "aws_vpc_endpoint" "interface_secretsmanager" {
  vpc_id            = var.vpc_id
  subnet_ids        = [
    var.subnet_private_1a_id,
  ]
  service_name      = "com.amazonaws.ap-northeast-1.secretsmanager"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    module.secretsmanager_interface_endpoint_security_group.security_group_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "secretsmanager-interface-endpoint"
    Env  = "shared"
  }
}