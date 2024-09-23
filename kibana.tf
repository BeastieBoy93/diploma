resource "yandex_compute_instance" "kibana_host" {
  name        = "kibana"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname    = "kibana"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
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
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = [yandex_vpc_security_group.elastic_sg.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
