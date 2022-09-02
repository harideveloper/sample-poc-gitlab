variable "project_id" {
    type = string
    default = "sandbox-db-enablers"
}

variable "gke1" {
    type = string
    default = "gke1-enablers"
}

variable "gke2" {
    type = string
    default = "gke2-enablers"
}

variable "gke1_location" {
  type    = string
  default = "europe-west2-a"
}

variable "gke2_location" {
  type    = string
  default = "europe-west2-b"
}

variable "gke1_kubeconfig_path" {
    type = string
    default = "../gke1_kubeconfig_enablers.secret"
}

variable "gke2_kubeconfig_path" {
    type = string
    default = "../gke2_kubeconfig_enablers.secret"
}
