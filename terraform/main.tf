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
  # service_account_key_file = file("./key.json") # if runs without OAuth token
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
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "base_vm" {
  name        = var.vm_name
  platform_id = var.vm_platform
  zone        = yandex_vpc_subnet.dez_project_subnet.zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_20_04.id
      type = "network-hdd"
      size = var.vm_disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.dez_project_subnet.id
    nat       = var.vm_nat
  }

  hostname = var.vm_hostname

  metadata = {
    ssh-keys = "ubuntu:${file(var.vm_ssh_pub_key_path)}"
  }

  service_account_id = "ajehanko46l81jme0724"

#   provisioner "remote-exec" {
#     inline = [
#       "echo '${var.vm_ssh_user}:${var.vm_password}' | sudo chpasswd" #,
#       # "sudo apt-get update -y"
#     ]
#     connection {
#       type = "ssh"
#       user = var.vm_ssh_user
#       private_key = file(var.vm_ssh_pvt_key_path)
#       host = self.network_interface[0].nat_ip_address
#     }
#   }

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
    assign_public_ip = true
  }

  access {
    data_lens = true
    web_sql   = true
  }

  cloud_storage {
    enabled = true
    move_factor = 0.15
  }

  depends_on = [yandex_vpc_subnet.dez_project_subnet,
  yandex_vpc_network.dez_project_net]

#   maintenance_window {
#     type = "ANYTIME"
#   }

#   admin_password = var.clkhs_admin_pass
#   sql_user_management     = true
#   sql_database_management = true
  service_account_id = "ajehanko46l81jme0724"

}












# resource "yandex_mdb_mysql_cluster" "mysql_managed" {
#   name        = var.mysql_mng_name
#   environment = var.mysql_mng_environment
#   network_id  = yandex_vpc_network.dez_project_net.id
#   version     = var.mysql_mng_version

#   resources {
#     resource_preset_id = var.mysql_mng_preset
#     disk_type_id       = var.mysql_mng_disk_type
#     disk_size          = var.mysql_mng_disk_size
#   }

#   host {
#     zone             = yandex_vpc_subnet.dez_project_subnet.zone
#     subnet_id        = yandex_vpc_subnet.dez_project_subnet.id
#     assign_public_ip = var.mysql_mng_public_id
#   }

#   access {
#     data_lens     = var.mysql_mng_access_lens
#     data_transfer = var.mysql_mng_access_transfer
#     web_sql       = var.mysql_mng_access_websql
#   }

#   maintenance_window {
#     type = var.mysql_mng_maintenance_type
#     day  = var.mysql_mng_maintenance_day
#     hour = var.mysql_mng_maintenance_hour
#   }
#   depends_on = [yandex_vpc_subnet.dez_project_subnet,
#   yandex_vpc_network.dez_project_net]
# }


# resource "yandex_mdb_mysql_database" "mysql_managed_db" {
#   cluster_id = yandex_mdb_mysql_cluster.mysql_managed.id
#   name       = var.mysql_mng_db
#   depends_on = [yandex_mdb_mysql_cluster.mysql_managed]
# }


# resource "yandex_mdb_mysql_user" "mysql_managed_user" {
#   cluster_id = yandex_mdb_mysql_cluster.mysql_managed.id
#   name       = var.mysql_mng_user_name
#   password   = var.mysql_mng_user_pass

#   permission {
#     database_name = yandex_mdb_mysql_database.mysql_managed_db.name
#     roles         = var.mysql_mng_user_roles
#   }

#   global_permissions = var.mysql_mng_global_permissions

#   authentication_plugin = var.mysql_mng_auth_plugin
#   depends_on = [yandex_mdb_mysql_cluster.mysql_managed,
#   yandex_mdb_mysql_database.mysql_managed_db]
# }


# resource "yandex_datatransfer_endpoint" "mysql_source" {
#   name = var.endpnt_mysql_src_name
#   settings {
#     mysql_source {
#       connection {
#         on_premise {
#           hosts = [yandex_compute_instance.base_vm.network_interface.0.nat_ip_address]
#           port  = var.mysql_port
#         }
#       }
#       database = var.mysql_db_name
#       user     = var.mysql_user_name
#       password {
#         raw = var.mysql_user_pass
#       }
#       include_tables_regex = var.endpnt_mysql_src_incl_tab_regex_list
#     }
#   }
#   depends_on = [yandex_compute_instance.base_vm]
# }


# resource "yandex_datatransfer_endpoint" "mysql_target" {
#   name = var.endpnt_mysql_tgt_name
#   settings {
#     mysql_target {
#       connection {
#         mdb_cluster_id = yandex_mdb_mysql_cluster.mysql_managed.id
#       }
#       database = var.mysql_mng_db
#       user     = var.mysql_mng_user_name
#       password {
#         raw = var.mysql_mng_user_pass
#       }
#       skip_constraint_checks = var.endpnt_mysql_tgt_skip_constr_check
#     }
#   }
#   depends_on = [yandex_mdb_mysql_cluster.mysql_managed]
# }


# resource "yandex_datatransfer_transfer" "mysql_mysql_transfer" {
#   name      = var.data_transfer_name
#   source_id = yandex_datatransfer_endpoint.mysql_source.id
#   target_id = yandex_datatransfer_endpoint.mysql_target.id
#   type      = var.data_transfer_type
#   depends_on = [yandex_datatransfer_endpoint.mysql_source,
#   yandex_datatransfer_endpoint.mysql_target]
# }
