
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name

  dashboard_body = <<EOT
{
    "widgets": [
        %{for idx, service in var.services}
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 6,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ECS", "CPUUtilization", "ServiceName", "${service.service_name}", "ClusterName", "${service.cluster_name}", { "id": "m1" } ],
                    [ { "expression": "ANOMALY_DETECTION_BAND(m1, 2)", "label": "CPUUtilization (expected)", "id": "ad1", "color": "#95A5A6" } ],
                    [ "AWS/ECS", "MemoryUtilization", "ServiceName", "${service.service_name}", "ClusterName", "${service.cluster_name}", { "id": "m2" } ]
                ],
                "region": "us-east-1",
                "title": "${service.widget_prefix} CPU/Memory"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${service.lb_id}", { "stat": "Minimum" } ],
                    [ "...", { "yAxis": "left", "stat": "Maximum" } ],
                    [ "..." ],
                    [ "...", { "stat": "p90" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "title": "${service.widget_prefix} Response Time",
                "period": 300,
                "stat": "p50"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${service.lb_id}" ],
                    [ ".", "HTTPCode_Target_4XX_Count", ".", "." ],
                    [ ".", "HTTPCode_ELB_502_Count", ".", "." ],
                    [ ".", "HTTPCode_ELB_5XX_Count", ".", "." ]
                ],
                "region": "us-east-1",
                "title": "${service.widget_prefix} Requests"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", "${service.lb_id}" ]
                ],
                "region": "us-east-1",
                "title": "${service.widget_prefix} Traffic"
            }
        }%{if idx != length(var.services) - 1},%{endif}
        %{endfor}
    ]
}
EOT
}
