variable "name_prefix" {
  description = "Name prefix for resources on AWS"
}

variable "ecs_execution_task_role_arn" {
  description = "(Required) The task definition execution role. The Amazon Resource Name (ARN) of the IAM role to be used for this target when the rule is triggered."
}
