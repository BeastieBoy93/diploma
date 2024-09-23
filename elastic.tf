resource "yandex_compute_instance" "elastic_host" {
  name        = "elastic"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname     = "elastic"

  resources {
    core_fraction = 20
    cores         = 4
    memory        = 8
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2204-lts.image_id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_1.id
    security_group_ids = [yandex_vpc_security_group.elastic_sg.id]
#    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
