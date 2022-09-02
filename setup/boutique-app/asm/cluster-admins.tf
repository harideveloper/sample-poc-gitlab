resource "kubernetes_cluster_role_binding" "cluster_admins_gke1" {
  provider = kubernetes.gke1

  metadata {
    name = "cluster-admin-enablers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  dynamic "subject" {
    for_each = var.cluster_admins
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

resource "kubernetes_cluster_role_binding" "cluster_admins_gke2" {
  provider = kubernetes.gke2

  metadata {
    name = "cluster-admin-enablers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  dynamic "subject" {
    for_each = var.cluster_admins
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}
