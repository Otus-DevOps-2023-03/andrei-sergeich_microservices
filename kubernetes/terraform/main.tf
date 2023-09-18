provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_compute_instance" "k8s_master" {
  count = var.inst_count
  name  = "k8s-master"
  zone  = var.zone

  resources {
    cores         = 4
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type = "network-ssd"
      size = 40
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }


  labels = {
    type = "k8s"
    kind = "k8s-master"
  }
}

resource "yandex_compute_instance" "k8s_worker" {
  count = var.inst_count
  name  = "k8s-worker"
  zone  = var.zone

  resources {
    cores         = 4
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type = "network-ssd"
      size = 40
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }


  labels = {
    type = "k8s"
    kind = "k8s-worker"
  }
}

resource "local_file" "hosts_inventory" {
  content = templatefile("${path.module}/ansible_inventory_ini.tpl",
    {
      master = yandex_compute_instance.k8s_master[*].network_interface.0.nat_ip_address
      worker = yandex_compute_instance.k8s_worker[*].network_interface.0.nat_ip_address
    }
  )
  filename = "../ansible/inventory"
}
