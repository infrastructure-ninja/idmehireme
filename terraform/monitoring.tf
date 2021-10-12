resource "google_monitoring_uptime_check_config" "http" {
  display_name = "URL Shortener Health Check"
  project      = var.gcp_project_id
  timeout      = "60s"
  period       = "60s"

  http_check {
    path = "/healthcheck"
    port = "80"
    request_method = "GET"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project_id
      host       = aws_route53_record.go-cname.name
    }
  }

  content_matchers {
    content = "OK!"
  }
}


resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = var.gcp_dashboard_json
}
