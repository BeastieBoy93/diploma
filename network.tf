resource "yandex_vpc_network" "terr" {
  name = "terr"
}

resource "yandex_vpc_address" "bastion" {
  name = "bastion"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

#resource "yandex_vpc_address" "alb" {
#  name = "alb"
#  external_ipv4_address {
#    zone_id = "ru-central1-a"
#  }
#}

resource "yandex_vpc_gateway" "terr_nat_gateway" {
  name = "terr-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.terr.id
  v4_cidr_blocks = ["10.0.0.0/24"]
  route_table_id = yandex_vpc_route_table.terr_rt.id
}


resource "yandex_vpc_subnet" "private_1" {
  name           = "private-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.terr.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.terr_rt.id
}


resource "yandex_vpc_subnet" "private_2" {
  name           = "private-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.terr.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.terr_rt.id
}

resource "yandex_vpc_route_table" "terr_rt" {
  name       = "terr-route-table"
  network_id = yandex_vpc_network.terr.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.terr_nat_gateway.id
  }
}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg"
  network_id = yandex_vpc_network.terr.id

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port          = 22
  }

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port          = 80
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port           = 10050
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_1.v4_cidr_blocks[0]]
    port           = 10050
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_2.v4_cidr_blocks[0]]
    port           = 10050
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.terr.id

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port          = 22
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_vpc_security_group" "zabbix_sg" {
  name       = "zabbix-sg"
  network_id = yandex_vpc_network.terr.id

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port          = 22
  }

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port          = 80
  }

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port          = 8080
  }
 
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port           = 10050
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_1.v4_cidr_blocks[0]]
    port           = 10050
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_2.v4_cidr_blocks[0]]
    port           = 10050
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port           = 10051
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_1.v4_cidr_blocks[0]]
    port           = 10051
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_2.v4_cidr_blocks[0]]
    port           = 10051
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_1.v4_cidr_blocks[0]]
    port           = 5432
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_vpc_security_group" "elastic_sg" {
  name       = "elastic-sg"
  network_id = yandex_vpc_network.terr.id

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port          = 22
  }

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port          = 80
  }

  ingress {
    protocol      = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port          = 9200
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.public.v4_cidr_blocks[0]]
    port           = 10050
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_1.v4_cidr_blocks[0]]
    port           = 9200
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = [yandex_vpc_subnet.private_2.v4_cidr_blocks[0]]
    port           = 9200
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

output "BASTION_IP" {
  value = yandex_compute_instance.bastion_host.network_interface.0.nat_ip_address
}

output "ZABBIX_IP" {
  value = yandex_compute_instance.zabbix_host.network_interface.0.nat_ip_address
}

output "KIBANA_IP" {
  value = yandex_compute_instance.kibana_host.network_interface.0.nat_ip_address
}
