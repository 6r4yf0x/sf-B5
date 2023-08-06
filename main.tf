terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-01" {

  name                      = "vm-01"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"

  resources {
    cores         = "2"
    core_fraction = "5"
    memory        = "1"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8bkgba66kkf9eenpkb"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-dmz.id
    nat       = true
  }

  metadata = {
    ssh-keys  = "${var.ssh-login}:${var.ssh-key}"
    user-data = "${file("nginx.sh")}"
  }

  scheduling_policy {
    preemptible = true
  }
}
resource "yandex_compute_instance" "vm-02" {

  name                      = "vm-02"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"

  resources {
    cores         = "2"
    core_fraction = "5"
    memory        = "1"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8bkgba66kkf9eenpkb"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-dmz.id
    nat       = true
  }

  metadata = {
    ssh-keys  = "${var.ssh-login}:${var.ssh-key}"
    user-data = "${file("apache.sh")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_vpc_network" "dmz" {
  name = "dmz1"
}

resource "yandex_vpc_subnet" "subnet-dmz" {
  name           = "subnetdmz1"
  v4_cidr_blocks = ["192.168.0.0/24"]
  network_id     = yandex_vpc_network.dmz.id
}

resource "yandex_lb_network_load_balancer" "sfnlb" {
  name                = "sfnlb"
  deletion_protection = "false"
  listener {
    name = "listener"
    port = 80
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.tg-1.id
    healthcheck {
      name = "tg1"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.tg-2.id
    healthcheck {
      name = "tg2"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

resource "yandex_lb_target_group" "tg-1" {
  name = "tg-1"
  target {
    subnet_id = yandex_vpc_subnet.subnet-dmz.id
    address   = data.yandex_compute_instance.vm-01.network_interface.0.ip_address
  }
}
resource "yandex_lb_target_group" "tg-2" {
  name = "tg-2"
  target {
    subnet_id = yandex_vpc_subnet.subnet-dmz.id
    address   = data.yandex_compute_instance.vm-02.network_interface.0.ip_address
  }
}

data "yandex_compute_instance" "vm-01" {
  instance_id = yandex_compute_instance.vm-01.id
}

output "instance_internal_ip_vm-01" {
  value = data.yandex_compute_instance.vm-01.network_interface.0.nat_ip_address
}

data "yandex_compute_instance" "vm-02" {
  instance_id = yandex_compute_instance.vm-02.id
}

output "instance_internal_ip_vm-02" {
  value = data.yandex_compute_instance.vm-02.network_interface.0.nat_ip_address
}

data "yandex_lb_network_load_balancer" "sfnlb" {
  nlb-ip = listener.external_address_spec.address
}

output "nlb-ip" {
  value = data.yandex_lb_network_load_balancer.sfnlb.listener.address
}
