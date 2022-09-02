locals {
  node_locations_computed = length(var.node_locations) == 0 ? ["${var.region}-a"] : var.node_locations
}

resource "google_container_node_pool" "default" {
  name           = "${google_container_cluster.primary.name}-node-pool"
  location       = var.region
  node_locations = local.node_locations_computed
  cluster        = google_container_cluster.primary.name
  node_count     = var.node_count

  node_config {
    machine_type = var.node_machine_type
    preemptible  = var.node_preemptible

    disk_type    = var.node_disk_type
    disk_size_gb = var.node_disk_size_gb

    oauth_scopes = var.node_oauth_scopes

    labels = {
      env = local.gcp_project_id
    }

    tags = ["gke-node", "${local.gcp_project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
