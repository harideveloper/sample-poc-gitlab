provider "google" {
  project = "${var.gcp_project_name}"
  region  = "${var.primary_region}"
}
