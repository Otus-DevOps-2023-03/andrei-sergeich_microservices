output "k8s_version" {
  value = data.yandex_kubernetes_cluster.k8s-zonal-cluster.master.0.version_info.0.current_version
}

output "k8s_zonal_cluster_status" {
  value = data.yandex_kubernetes_cluster.k8s-zonal-cluster.status
}

output "k8s_node_gr_status" {
  value = data.yandex_kubernetes_node_group.k8s-node-group.status
}

# output "my_node_group_nat" {
#   value = "${data.yandex_kubernetes_node_group.my_node_group.instance_template[0].network_interface.0.nat}"
# }

# output "external_ip_address_k8s_master" {
#   value = [
#     for inst in yandex_compute_instance.k8s_master :
#     "IP of ${inst.name} is ${inst.network_interface.0.nat_ip_address}"
#   ]
# }

# output "external_ip_address_k8s_worker" {
#   value = [
#     for inst in yandex_compute_instance.k8s_worker :
#     "IP of ${inst.name} is ${inst.network_interface.0.nat_ip_address}"
#   ]
# }

# output "external_ip_address_lb" {
#   value = yandex_lb_network_load_balancer.lb.listener[*].external_address_spec[*].address
# }

# output "external_ip_address_lb" {
#   value = tolist(tolist(yandex_lb_network_load_balancer.lb.listener)[0].external_address_spec)[0].address
# }
