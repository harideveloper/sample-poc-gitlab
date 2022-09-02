data "google_client_config" "current" {
}

locals {
  gcp_project_id       = data.google_client_config.current.project
  cluster_name_default = "${replace(local.gcp_project_id, "_", "-")}-gke-${random_string.cluster_name_suffix.result}"
  cluster_name         = coalesce(var.cluster_name, local.cluster_name_default)
}

resource "random_string" "cluster_name_suffix" {
  length  = 4
  lower   = true
  number  = true
  upper   = false
  special = false
}

resource "google_container_cluster" "primary" {
  provider = google-beta

  name     = local.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_network_name
  subnetwork = var.vpc_subnetwork_name

  addons_config {
    #  http_load_balancing {
    #     disabled = ! var.istio_enabled
    #   }

    # https://itsmetommy.com/2019/07/29/kubernetes-enable-istio-on-gke-using-terraform/
    istio_config {
      disabled = !var.istio_enabled
      auth     = "AUTH_NONE"
    }
  }

  depends_on = [
    google_project_service.project
  ]
}
