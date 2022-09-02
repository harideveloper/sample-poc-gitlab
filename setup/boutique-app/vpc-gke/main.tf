terraform {
  backend "gcs" {
  }
}

locals {
  machine_type = "n1-standard-4" # 1 vCPU; 3.75 GiB
  node_count   = 1
  subnet_name  = "${var.application}-${var.subnet_name}"
}

module "vpc" {
  source = "terraform-google-modules/network/google"

  project_id   = var.project_id
  network_name = var.vpc
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = local.subnet_name
      subnet_ip     = var.subnet_ip
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${local.subnet_name}" = [
      {
        range_name    = "${var.subnet_name}-pod-cidr"
        ip_cidr_range = var.pod_cidr
      },
      {
        range_name    = "${var.subnet_name}-svc1-cidr"
        ip_cidr_range = var.svc1_cidr
      },
      {
        range_name    = "${var.subnet_name}-svc2-cidr"
        ip_cidr_range = var.svc2_cidr
      },
    ]
  }

  firewall_rules = [{
    name        = "${var.application}-allow-all-10"
    description = "Allow Pod to Pod connectivity"
    direction   = "INGRESS"
    ranges      = ["10.0.0.0/8"]
    allow = [{
      protocol = "tcp"
      ports    = ["0-65535"]
    }]
  }]
}

data "google_project" "project" {
  project_id = var.project_id
}

module "gke1" {
  source = "terraform-google-modules/kubernetes-engine/google"
  count  = var.gke_enabled ? 1 : 0

  project_id                = module.vpc.project_id
  name                      = var.gke1
  regional                  = false
  region                    = var.region
  zones                     = [var.gke1_location]
  network                   = module.vpc.network_name
  subnetwork                = local.subnet_name
  ip_range_pods             = "${var.subnet_name}-pod-cidr"
  ip_range_services         = "${var.subnet_name}-svc1-cidr"
  default_max_pods_per_node = 64
  network_policy            = true
  release_channel           = var.gke_channel
  cluster_resource_labels   = { "mesh_id" : "proj-${data.google_project.project.number}" }
  node_pools = [
    {
      name         = "node-pool-01"
      autoscaling  = false
      auto_upgrade = true
      min_count    = local.node_count
      max_count    = local.node_count
      node_count   = local.node_count
      machine_type = local.machine_type
    },
  ]
}

module "gke2" {
  source = "terraform-google-modules/kubernetes-engine/google"
  count  = var.gke_enabled ? 1 : 0

  project_id                = module.vpc.project_id
  name                      = var.gke2
  regional                  = false
  region                    = var.region
  zones                     = [var.gke2_location]
  network                   = module.vpc.network_name
  subnetwork                = local.subnet_name
  ip_range_pods             = "${var.subnet_name}-pod-cidr"
  ip_range_services         = "${var.subnet_name}-svc2-cidr"
  default_max_pods_per_node = 64
  network_policy            = true
  release_channel           = var.gke_channel
  cluster_resource_labels   = { "mesh_id" : "proj-${data.google_project.project.number}" }
  node_pools = [
    {
      name         = "node-pool-01"
      autoscaling  = false
      auto_upgrade = true
      min_count    = local.node_count
      max_count    = local.node_count
      node_count   = local.node_count
      machine_type = local.machine_type
    },
  ]
}

module "gke1_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  count  = var.gke_enabled ? 1 : 0

  project_id   = var.project_id
  cluster_name = module.gke1[0].name
  location     = module.gke1[0].location
  depends_on   = [module.gke1]
}

module "gke2_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  count  = var.gke_enabled ? 1 : 0

  project_id   = var.project_id
  cluster_name = module.gke2[0].name
  location     = module.gke2[0].location
  depends_on   = [module.gke2]
}

resource "local_file" "gke1_kubeconfig" {
  count = var.gke_enabled ? 1 : 0

  content  = module.gke1_auth[0].kubeconfig_raw
  filename = var.gke1_kubeconfig
}

resource "local_file" "gke2_kubeconfig" {
  count = var.gke_enabled ? 1 : 0

  content  = module.gke2_auth[0].kubeconfig_raw
  filename = var.gke2_kubeconfig
}
