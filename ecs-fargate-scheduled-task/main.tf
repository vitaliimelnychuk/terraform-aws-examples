#------------------------------------------------------------------------------
# CLOUDWATCH EVENT ROLE
#------------------------------------------------------------------------------
resource "aws_iam_role" "scheduled_task_event_role" {
  name               = "${var.name_prefix}-st-role"
  assume_role_policy = file("${path.module}/files/assume_role_policy.json")
}

resource "aws_iam_role_policy" "event_role_cloudwatch_policy" {
  name = "${var.name_prefix}-st-policy"
  role = aws_iam_role.scheduled_task_event_role.id
  policy = templatefile("${path.module}/files/event_role_cloudwatch_policy.json",
  { TASK_EXECUTION_ROLE_ARN = var.ecs_execution_task_role_arn })
}

#------------------------------------------------------------------------------
# CLOUDWATCH EVENT RULE
#------------------------------------------------------------------------------
# Use your CI/CD process to control rules



#------------------------------------------------------------------------------
# CLOUDWATCH EVENT TARGET
#------------------------------------------------------------------------------
# Use your CI/CD process to control event target. They might be changing through deployments
