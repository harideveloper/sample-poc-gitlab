###
###  Networking fixtures for the module testing
###

data "google_client_config" "current" {
}

locals {
  module_name_short = replace(replace(local.module_name, "terraform-", ""), "-module", "")
  # gcp_project_id    = data.google_client_config.current.project
}

resource "random_string" "vpc_name_suffix" {
  length  = 4
  lower   = true
  number  = true
  upper   = false
  special = false
}

locals {
  vpc_name        = "${local.gcp_project_id}-vpc-modules-${local.module_name_short}-${random_string.vpc_name_suffix.result}" # Some naming convention to prevent clashes
  vpc_subnet_name = "${local.module_name_short}-subnet"
}

# VPC
resource "google_compute_network" "vpc" {
  project = local.gcp_project_id
  name    = local.vpc_name

  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = local.vpc_subnet_name
  region        = local.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}


output "vpc_network_name" {
  value = google_compute_network.vpc.name
}

output "vpc_subnetwork_name" {
  value = google_compute_subnetwork.subnet.name
}
