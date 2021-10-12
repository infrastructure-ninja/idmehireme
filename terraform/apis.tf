#############################################################################
###### ENABLE REQUIRED GCP APIs
#############################################################################

resource "google_project_service" "cloudresource_manager_api" {
  project            = var.gcp_project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudrun_admin_api" {
  project            = var.gcp_project_id
  service            = "run.googleapis.com"
  depends_on         = [google_project_service.cloudresource_manager_api]
  disable_on_destroy = false
}

resource "google_project_service" "cloud_dns_api" {
  project            = var.gcp_project_id
  service            = "dns.googleapis.com"
  depends_on         = [google_project_service.cloudresource_manager_api]
  disable_on_destroy = false
}
