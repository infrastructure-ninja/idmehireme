terraform {
  backend "remote" {
    organization = "joel-caturia"

    workspaces {
      name = "Experimental"
    }
  }
}



resource "google_cloud_run_service" "application" {
  name     = var.application_name
  project  = var.gcp_project_id
  location = var.gcp_project_region

  depends_on = [google_project_service.cloudrun_admin_api]

  autogenerate_revision_name = true

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1000"
        "autoscaling.knative.dev/minScale" = "1"
      }
    }

    spec {
      containers {
         image = "us.gcr.io/${var.gcp_project_id}/${var.application_name}:${var.app_docker_tag}"

         resources {
           limits = {
             memory = "768Mi"
           }
         }

        env {
          name  = "APP_SENTRY_DSN"
          value = var.app_sentry_dsn
        }
        env {
          name  = "APP_MONGO_URL"
          value = var.app_mongo_url
        }
        env {
          name  = "APP_MONGO_DBNAME"
          value = var.app_mongo_dbname
        }
      }
    }
  }
}


data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}


resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.application.location
  project     = google_cloud_run_service.application.project
  service     = google_cloud_run_service.application.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
