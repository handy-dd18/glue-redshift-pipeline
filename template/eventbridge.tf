# EventBridgeルール定義
resource "aws_cloudwatch_event_rule" "trigger_state_machine" {
  name        = var.aws_cloudwatch_event_rule_name
  description = "Triggers Step Functions state machine on S3 object creation"

  event_pattern = jsonencode({
    "source" : ["aws.s3"],
    "detail-type" : ["Object Created"],
    "detail" : {
      "bucket" : {
        "name" : [
          "${aws_s3_bucket.raw_data_bucket.bucket}"
        ]
      },
      "object" : {
        "key" : [
          {
            "prefix" : "from_samplesystem/sample_data/"
          },
          {
            "suffix" : "${var.sample_file_name}"
          }
        ]
      }
    }
  })
}

# EventBridgeルールターゲット定義
resource "aws_cloudwatch_event_target" "trigger_state_machine_target" {
  rule      = aws_cloudwatch_event_rule.trigger_state_machine.name
  target_id = var.aws_cloudwatch_event_target_id
  arn       = aws_sfn_state_machine.exec_glue_job_state_machine.arn
  role_arn  = module.eventbridge_sfn_role.iam_role_arn
}

