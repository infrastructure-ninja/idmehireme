#############################################################################
###### CREATE LOAD BALANCER and REQUIRED DEPENDENCIES
#############################################################################

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 5.1"
  name    = "${var.application_name}-loadbalancer"
  project = var.gcp_project_id

  ssl                             = false
  https_redirect                  = false
  #ssl                             = var.ssl
  #managed_ssl_certificate_domains = [var.domain]
  #https_redirect                  = var.ssl

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        }
      ]
      enable_cdn              = false
      security_policy         = null
      custom_request_headers  = ["host: ${trimprefix(google_cloud_run_service.application.status[0].url, "https://")}"]
      custom_response_headers = null

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}


resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  provider              = google
  name                  = "${var.application_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.gcp_project_region
  cloud_run {
    service = google_cloud_run_service.application.name
  }
}
