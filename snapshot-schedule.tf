resource "yandex_compute_snapshot_schedule" "default" {
  schedule_policy {
	expression = "0 0 * * *"
  }

  retention_period = "168h"

  snapshot_spec {
	  description = "retention-snapshot"
  }

  disk_ids = [yandex_compute_instance.vm1.boot_disk[0].disk_id, yandex_compute_instance.vm2.boot_disk[0].disk_id, yandex_compute_instance.bastion_host.boot_disk[0].disk_id, yandex_compute_instance.zabbix_host.boot_disk[0].disk_id, yandex_compute_instance.elastic_host.boot_disk[0].disk_id, yandex_compute_instance.kibana_host.boot_disk[0].disk_id]
}
