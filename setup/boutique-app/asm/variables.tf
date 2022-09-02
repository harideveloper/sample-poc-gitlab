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
    type = string
    default = "europe-west2-a"
}

variable "gke2_location" {
    type = string
    default = "europe-west2-b"
}

variable "gke1_kubeconfig" {
    type = string
    default = "../gke1_kubeconfig_enablers.secret"
}

variable "gke2_kubeconfig" {
    type = string
    default = "../gke2_kubeconfig_enablers.secret"
}

variable "asm_channel" {
  type = string
  default = "regular"
}

variable "cni_enabled" {
  type = string
  default = "true"
}

variable "cluster_admins" {
  type = list(string)
  default = [
    "rajponna1@publicisgroupe.net",
    "sidmoola@publicisgroupe.net",
    "levrog1@publicisgroupe.net",
    "harsunda1@publicisgroupe.net",
    "amimahes@publicisgroupe.net",
    "mudkonda@publicisgroupe.net",
    "swecheru@publicisgroupe.net"
  ]
  description = "List of GCP Users who get the cluster-admin role binding."
}
