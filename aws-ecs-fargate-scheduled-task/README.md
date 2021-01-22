# terraform-aws-ecs-fargate-scheduled-task

Terraform Module to provision AWS ECS Fargate Schedule Task

## ECS tasks running approatch

This module provides simple interface to create roles for running scheduled tasks in AWS ECS Fargete. ALl events rules and tasks should be described in the repositories where tasks source code is stored.

It will allows to update tasks definition in your CI/CD process. Here is an example how to create/update events by using aws CLI.

### Creating events

The follwoing example will create a rule for creating event in each morning at 8AM. You can read more about param from the docs:
https://docs.aws.amazon.com/cli/latest/reference/events/put-rule.html

```bash
aws events put-rule --schedule-expression "cron(0 8 * * ? *)" --name YourRuleName
```

### Creating Targets

Once you are deploting your app you also need to update targets from where tasks should be run. Here is an example how you can create/update targets for your app.

https://docs.aws.amazon.com/cli/latest/reference/events/put-targets.html

```bash
aws events put-targets --rule "YourRuleName" --cli-input-json file://your-task-definition.json
```

## Usage

```HCL
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


module "scheduled_task" {
  source                      = "./aws-ecs-fargate-scheduled-task"
  name_prefix                 = "role-prefix-name"
  ecs_execution_task_role_arn = "your-task-execution=arn" // the one you have in task definition
}

```
