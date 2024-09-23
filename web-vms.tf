data "yandex_compute_image" "ubuntu-2204-lts" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm1" {
  name        = "web-vm1"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname    = "web-vm1"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2204-lts.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_1.id
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm2" {
  name        = "web-vm2"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"
  hostname    = "web-vm2"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2204-lts.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_2.id
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
 }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

