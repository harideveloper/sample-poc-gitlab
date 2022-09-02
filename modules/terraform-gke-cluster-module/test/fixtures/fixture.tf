locals {
  gcp_project_id = "sandbox-db-enablers"
  region         = "europe-west2"
  module_name    = "terraform-gke-cluster-module"

  cluster_profiles = {
    light = {
      node_count        = 1
      node_preemptible  = true
      node_machine_type = "e2-medium"
      istio_enabled     = false
    }
    normal = {
      node_count        = 1
      node_preemptible  = false
      node_machine_type = "n1-standard-2"
      istio_enabled     = true
    }
  }

  active_cluster_profile = "normal"
}

module "gke" {
  source = "../.."

  region = local.region

  node_count        = local.cluster_profiles[local.active_cluster_profile].node_count
  node_preemptible  = local.cluster_profiles[local.active_cluster_profile].node_preemptible
  node_machine_type = local.cluster_profiles[local.active_cluster_profile].node_machine_type
  istio_enabled     = local.cluster_profiles[local.active_cluster_profile].istio_enabled

  vpc_network_name    = google_compute_network.vpc.name
  vpc_subnetwork_name = google_compute_subnetwork.subnet.name
}
