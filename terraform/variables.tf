variable "aws_access_key" {
  type        = string
}

variable "aws_secret_key" {
  type        = string
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
}


variable "gcp_project_id" {
  default     = "idmehireme-328303"
  type        = string
  description = "The GCP project ID we intend to deploy resources to"
}

variable "application_name" {
  default     = "url-shortener"
  type        = string
  description = "The friendly name of the application, used in many places"
}

variable "gcp_project_region" {
  default     = "us-west1"
  type        = string
  description = "The GCP region we want to deploy resources to"
}

variable "app_docker_tag" {
  type        = string
  default     = "latest"
  description = "The version tag of the docker container that we want to deploy into GCP Cloud Run"
}

variable "app_sentry_dsn" {
  type        = string
  description = "DSN used to commnuicate with Sentry.io (set as a docker environment variable)"
}

variable "app_mongo_url" {
  type        = string
  description = "URL to access MongoDB database resource"
}

variable "app_mongo_dbname" {
  type        = string
  description = "Name of our database on MongoDB"
}

