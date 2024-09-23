resource "yandex_compute_snapshot" "vm1_snap" {
  name           = "init-snapshot-vm1"
  source_disk_id = yandex_compute_instance.vm1.boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "vm2_snap" {
  name           = "init-snapshot-vm2"
  source_disk_id = yandex_compute_instance.vm1.boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "bastion_snap" {
  name           = "init-snapshot-bastion"
  source_disk_id = yandex_compute_instance.bastion_host.boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "zabbix_snap" {
  name           = "init-snapshot-zabbix"
  source_disk_id = yandex_compute_instance.zabbix_host.boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "elastic_snap" {
  name           = "init-snapshot-elastic"
  source_disk_id = yandex_compute_instance.elastic_host.boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "kibana_snap" {
  name           = "init-snapshot-kibana"
  source_disk_id = yandex_compute_instance.kibana_host.boot_disk[0].disk_id
}

