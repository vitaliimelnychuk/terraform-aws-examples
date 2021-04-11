
locals {
  thresholds = {
    CPUUtilizationHighThreshold    = 80
    CPUUtilizationLowThreshold     = 20
    MemoryUtilizationHighThreshold = 400
    MemoryUtilizationLowThreshold  = 100
  }
}

resource "aws_cloudformation_stack" "email_alerts_notification" {
  name          = "EmailAlerts"
  template_body = <<EOT
    {
    "AWSTemplateFormatVersion": "2010-09-09",
    "Resources" : {
        "EmailSNSTopic": {
        "Type" : "AWS::SNS::Topic",
        "Properties" : {
            "DisplayName" : "Email Alert",
            "Subscription": [
            %{for idx, email_address in var.alert_emails}
                {
                "Endpoint" : "${email_address}",
                "Protocol" : "email"
                }%{if idx != length(var.alert_emails) - 1},%{endif}
            %{endfor}
            ]
        }
        }
    },
    "Outputs" : {
        "ARN" : {
        "Description" : "Email SNS Topic ARN",
        "Value" : { "Ref" : "EmailSNSTopic" }
        }
    }
    }
  EOT
}

resource "aws_cloudwatch_metric_alarm" "CPUUtilizationHigh" {
  for_each = { for service in var.services : "${service.cluster_name}_${service.service_name}" => service }

  alarm_name                = "${each.value.cluster_name}_${each.value.service_name}_CPUUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = local.thresholds.CPUUtilizationHighThreshold
  alarm_description         = "This metric monitors high AWS ECS CPU utilization"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = each.value.cluster_name
    ServiceName = each.value.service_name
  }

  alarm_actions = [aws_cloudformation_stack.email_alerts_notification.outputs.ARN]
}


resource "aws_cloudwatch_metric_alarm" "CPUUtilizationLow" {
  for_each = { for service in var.services : "${service.cluster_name}_${service.service_name}" => service }

  alarm_name                = "${each.value.cluster_name}_${each.value.service_name}_CPUUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = local.thresholds.CPUUtilizationLowThreshold
  alarm_description         = "This metric monitors high AWS ECS CPU utilization"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = each.value.cluster_name
    ServiceName = each.value.service_name
  }


  alarm_actions = [aws_cloudformation_stack.email_alerts_notification.outputs.ARN]
}


resource "aws_cloudwatch_metric_alarm" "MemoryUtilizationHigh" {
  for_each = { for service in var.services : "${service.cluster_name}_${service.service_name}" => service }

  alarm_name                = "${each.value.cluster_name}_${each.value.service_name}_MemoryUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = local.thresholds.MemoryUtilizationHighThreshold
  alarm_description         = "This metric monitors high AWS ECS MemoryUtilization"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = each.value.cluster_name
    ServiceName = each.value.service_name
  }

  alarm_actions = [aws_cloudformation_stack.email_alerts_notification.outputs.ARN]
}

resource "aws_cloudwatch_metric_alarm" "MemoryUtilizationLow" {
  for_each = { for service in var.services : "${service.cluster_name}_${service.service_name}" => service }

  alarm_name                = "${each.value.cluster_name}_${each.value.service_name}_MemoryUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = local.thresholds.MemoryUtilizationLowThreshold
  alarm_description         = "This metric monitors Low AWS ECS MemoryUtilization"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = each.value.cluster_name
    ServiceName = each.value.service_name
  }

  alarm_actions = [aws_cloudformation_stack.email_alerts_notification.outputs.ARN]
}
