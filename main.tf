terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = file("~/terr.json")
  cloud_id                 = "b1g6s3gc1dsquig5qr3a"
  folder_id                = "b1g41sma899n1hp1ts36"
}
