variable "cluster_name" {
  type        = string
  description = "GKE cluster name (optional)"
  default     = ""
}

variable "region" {
  type        = string
  description = "GKE cluster region"
}

variable "vpc_network_name" {
  type        = string
  description = "VPC network name where the GKE cluster will be deployed"
}

variable "vpc_subnetwork_name" {
  type        = string
  description = "VPC subnet name where the GKE cluster will be deploed"
}

variable "node_locations" {
  type        = list(string)
  description = "List of GCP zones to replicate node pools"
  default     = []
}

variable "node_count" {
  type        = string
  description = "The number of nodes in each zone"
}

variable "node_preemptible" {
  type        = bool
  description = "Provision preemptible nodes in the pool to save cost"
  default     = false
}

variable "node_machine_type" {
  type        = string
  description = "Node machine type"
}

variable "node_oauth_scopes" {
  type        = list(string)
  description = "List of OAUTH scopes to assign to the node instances"
  default = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "node_disk_type" {
  type        = string
  description = "Node disk type, ie (pd-standard|pd-ssd)"
  default     = "pd-ssd"
}

variable "node_disk_size_gb" {
  type        = string
  description = "Node disk size in GB"
  default     = null
}

variable "istio_enabled" {
  type        = bool
  description = "True will enable istio on the cluster"
  default     = false
}
