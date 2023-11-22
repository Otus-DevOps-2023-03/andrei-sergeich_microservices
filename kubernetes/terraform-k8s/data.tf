data "yandex_kubernetes_cluster" "k8s-zonal-cluster" {
  cluster_id = yandex_kubernetes_cluster.k8s-zonal-cluster.id
}

data "yandex_kubernetes_node_group" "k8s-node-group" {
  node_group_id = yandex_kubernetes_node_group.k8s-node-group.id
}
