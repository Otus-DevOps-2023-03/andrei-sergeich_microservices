provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_kubernetes_cluster" "k8s-zonal-cluster" {
  name       = "k8s-zonal-cluster"
  network_id = yandex_vpc_network.k8s-net.id

  master {
    version            = var.k8s_version
    security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
    zonal {
      zone      = yandex_vpc_subnet.k8s-subnet.zone
      subnet_id = yandex_vpc_subnet.k8s-subnet.id
    }
    public_ip = true
  }

  service_account_id      = yandex_iam_service_account.k8s-account.id
  node_service_account_id = yandex_iam_service_account.k8s-account.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller
  ]

  release_channel         = "RAPID"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

resource "yandex_kubernetes_node_group" "k8s-node-group" {
  cluster_id = yandex_kubernetes_cluster.k8s-zonal-cluster.id
  name       = "k8s-node-group"
  version    = var.k8s_version

  instance_template {
    platform_id = "standard-v2"
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.k8s-subnet.id}"]
    }

    resources {
      memory = 4
      cores  = 4
    }

    boot_disk {
      type = "network-ssd"
      size = 40
    }

    scheduling_policy {
      preemptible = false
    }

    metadata = {
      ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
    }
  }

  scale_policy {
    auto_scale {
      min     = 2
      max     = 5
      initial = 2
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
