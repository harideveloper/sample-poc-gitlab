variable "asm_gateways_namespace" {
    type = string
    default = "asm-gateways"
}

variable "asm_label" {
    type = string
    default = ""
}

variable "gke1_kubeconfig" {
    type = string
    default = "../gke1_kubeconfig_enablers.secret"
}

variable "gke2_kubeconfig" {
    type = string
    default = "../gke2_kubeconfig_enablers.secret"
}