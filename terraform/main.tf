terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  backend "s3" {
  }
}

provider "yandex" {
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zones[0]
}



resource "yandex_vpc_network" "dez_project_net" {
  name = var.net_name
}

resource "yandex_vpc_subnet" "dez_project_subnet" {
  name           = var.subnet_name
  zone           = var.yc_zones[0]
  network_id     = yandex_vpc_network.dez_project_net.id
  v4_cidr_blocks = var.subnet_v4_cidr
  depends_on     = [yandex_vpc_network.dez_project_net]
}


data "yandex_compute_image" "ubuntu_20_04" {
  family = var.yandex_compute_image_family
}

resource "yandex_compute_instance" "base_vm" {
  name        = var.vm_name
  platform_id = var.vm_platform
  zone        = yandex_vpc_subnet.dez_project_subnet.zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_20_04.id
      type = var.vm_disk_type
      size = var.vm_disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.dez_project_subnet.id
    nat       = var.vm_nat
  }

  hostname = var.vm_name

  metadata = {
    ssh-keys = "${var.vm_username}:${file(var.vm_ssh_pub_key_path)}"
  }

  allow_stopping_for_update = true
  depends_on = [yandex_vpc_subnet.dez_project_subnet]
}


resource "yandex_mdb_clickhouse_cluster" "clickhouse-cluster" {
  name        = var.clkhs_cluster_name
  environment = var.clkhs_cluster_env
  network_id  = yandex_vpc_network.dez_project_net.id

  clickhouse {
    resources {
      resource_preset_id = var.clkhs_resource_preset_id
      disk_type_id       = var.clkhs_disk_type
      disk_size          = var.clkhs_disk_size
    }
  }

  database {
    name = var.clkhs_db_name
  }

  user {
    name     = var.clkhs_user_name
    password = var.clkhs_user_pass
    permission {
      database_name = var.clkhs_db_name
    }
  }

  host {
    type             = "CLICKHOUSE"
    zone             = var.yc_zones[0]
    subnet_id        = yandex_vpc_subnet.dez_project_subnet.id
    assign_public_ip = var.clkhs_host_public_ip
  }

  access {
    data_lens = var.clkhs_access_data_lens
    web_sql   = var.clkhs_access_web_sql
  }

  cloud_storage {
    enabled = var.clkhs_cloud_storage_enabled
    move_factor = var.clkhs_cloud_storage_move_factor
  }

  depends_on = [yandex_vpc_subnet.dez_project_subnet,
  yandex_vpc_network.dez_project_net]
}