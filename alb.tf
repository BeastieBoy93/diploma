resource "yandex_alb_target_group" "terr_alb" {
  name      = "terr-alb-tg"

  target {
    subnet_id = "${yandex_vpc_subnet.private_1.id}"
    ip_address   = "${yandex_compute_instance.vm1.network_interface.0.ip_address}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.private_2.id}"
    ip_address   = "${yandex_compute_instance.vm2.network_interface.0.ip_address}"
  }
}

resource "yandex_alb_backend_group" "terr_bg" {
  name      = "terr-bg"

  http_backend {
    name = "terr-back"
    weight = 1
    port = 80
    target_group_ids = ["${yandex_alb_target_group.terr_alb.id}"]
    load_balancing_config {
      panic_threshold = 90
      mode            = "ROUND_ROBIN"
    }    
    healthcheck {
      timeout = "10s"
      interval = "5s"
      healthcheck_port = 80
      http_healthcheck {
        path  = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "terr_http_rt" {
  name          = "terr-http-rt"
}

resource "yandex_alb_virtual_host" "terr_vm" {
  name                    = "terr-vm"
  http_router_id          = yandex_alb_http_router.terr_http_rt.id
  route {
    name                  = "web-vm"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.terr_bg.id
        timeout           = "60s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "terr_balancer" {
  name        = "terr-balancer"

  network_id  = yandex_vpc_network.terr.id
  
  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public.id 
    }
  }
  
  listener {
    name = "terr-listner"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.terr_http_rt.id
      }
    }
  }
}
