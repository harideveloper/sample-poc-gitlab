###
###  The following APIs must be enabled in the GCP project to use the service.
###    Enabling APIs is usually done outside of the module (eg. where the 'project factory' is called), but adding it here for now.
###

locals {
  required_apis = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
  ]
}

resource "google_project_service" "project" {
  for_each = toset(local.required_apis)

  project = local.gcp_project_id
  service = each.value

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy         = false
  disable_dependent_services = false
}
