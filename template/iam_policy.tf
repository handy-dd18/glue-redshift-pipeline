## StepFunctions 用 IAM Policy 定義
module "exec_glue_job_state_policy" {
  source = "./modules/iam_policy"
  name   = "StepFunctions_Exec_GlueJob_AllowPolicy"

  policy_statements = [
    {
      effect = "Allow",
      actions = [
        "glue:StartJobRun",
        "glue:GetJobRun",
        "glue:GetJobRuns",
        "glue:BatchStopJobRun"
      ],
      resources = ["*"]
    },
    {
      effect = "Allow",
      actions = [
        "xray:PutTraceSegments",
        "xray:PutTelemetryRecords",
        "xray:GetSamplingRules",
        "xray:GetSamplingTargets"
      ],
      resources = ["*"]
    }
  ]
}

# EventBridgeルール用IAMポリシー
module "eventbridge_sfn_policy" {
  source = "./modules/iam_policy"
  name   = "eventbridge_sfn_policy"

  policy_statements = [
    {
      effect    = "Allow",
      actions   = ["states:StartExecution"],
      resources = [aws_sfn_state_machine.exec_glue_job_state_machine.arn]
    }
  ]
}

# Glue Jobリソース用IAMポリシー
module "glue_access_policy" {
  source = "./modules/iam_policy"
  name   = "glue_access_policy"

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ]
      resources = [
        "arn:aws:s3:::${aws_s3_bucket.glue_scripts_bucket.bucket}/*",
        "arn:aws:s3:::${aws_s3_bucket.glue_scripts_bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.glue_temp_bucket.bucket}/*",
        "arn:aws:s3:::${aws_s3_bucket.glue_temp_bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.raw_data_bucket.bucket}/*",
        "arn:aws:s3:::${aws_s3_bucket.raw_data_bucket.bucket}"
      ]
    },
    {
      effect = "Allow"
      actions = [
        "redshift:DescribeClusters",
        "redshift:GetClusterCredentials",
        "redshift:GetClusterCredentialsWithIAM",
        "redshift-serverless:GetCredentials"
      ]
      resources = ["*"]
    },
    {
      effect = "Allow"
      actions = [
        "redshift-data:ExecuteStatement",
        "redshift-data:BatchExecuteStatement",
        "redshift-data:ExecuteStatement",
        "redshift-data:CancelStatement",
        "redshift-data:GetStatementResult",
        "redshift-data:DescribeStatement",
        "redshift-data:DescribeTable",
        "redshift-data:ListStatements",
        "redshift-data:ListDatabases",
        "redshift-data:ListSchemas",
        "redshift-data:ListTables",
      ]
      resources = ["*"]
    },
    {
      effect = "Allow"
      actions = [
        "glue:GetConnection",
        "glue:StartJobRun",
        "glue:GetJobRun",
        "glue:GetJobRuns",
        "glue:BatchStopJobRun",
      ]
      resources = ["*"]
    },
    {
      effect = "Allow"
      actions = [
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeRouteTables",
        "ec2:CreateNetworkInterface",
        "ec2:CreateNetworkInterfacePermission",
        "ec2:DeleteNetworkInterface",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:DescribeNetworkInterfaces",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateTags",
      ]
      resources = ["*"]
    },
    {
      effect = "Allow"
      actions = [
        "secretsmanager:GetSecretValue",
      ]
      resources = ["*"]
    },
    {
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics"
      ]
      resources = ["*"]
    }
  ]
}

## Redshift Serverless 用 IAM Policy 定義
module "redshift_serverless_iam_policy" {
  source = "./modules/iam_policy"
  name   = "RedshiftServerless_AllowPolicy"

  policy_statements = [
    {
      effect = "Allow",
      actions = [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts",
        "s3:ListBucketMultipartUploads",
        "s3:ListBucketVersions"
      ],
      resources = ["*"]
    },
    {
      effect = "Allow",
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      resources = ["*"]
    },
    {
      effect = "Allow",
      actions = [
        "redshift-data:ExecuteStatement",
        "redshift-data:GetStatementResult",
        "redshift-data:ListDatabases",
        "redshift-data:ListSchemas",
        "redshift-data:ListTables",
        "redshift-data:DescribeTable",
        "redshift-data:ListStatements",
        "redshift-data:CancelStatement",
        "redshift-data:GetStatementResult"
      ],
      resources = ["*"]
    },
    {
      effect = "Allow",
      actions = [
        "glue:GetDatabase",
        "glue:GetDatabases",
        "glue:GetTable",
        "glue:GetTables",
        "glue:GetTableVersions",
        "glue:GetTableVersion",
        "glue:GetPartitions",
        "glue:GetPartition"
      ],
      resources = ["*"]
    }
  ]
}