variable "yandex_compute_image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "yc_folder_id" {
  type      = string
  sensitive = true
}

variable "yc_cloud_id" {
  type      = string
  sensitive = true
}

variable "yc_zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "region" {
  type    = string
  default = "ru-central1"
}

## Compute instance

variable "vm_nat" {
  type    = bool
  default = true
}

variable "vm_name" {
  type    = string
  default = "dez"
}

variable "vm_cores" {
  type    = number
  default = 4
}

variable "vm_memory" {
  type    = number
  default = 8
}

variable "vm_core_fraction" {
  type    = number
  default = 50
}

variable "vm_platform" {
  type    = string
  default = "standard-v2"
}

variable "vm_image" {
  type    = string
  default = "fd80f8mhk83hmvp10vh2" # ubuntu 20.04 lts https://cloud.yandex.ru/marketplace/products/yc/ubuntu-20-04-lts
}

variable "vm_disk_size" {
  type    = number
  default = 30
}

variable "vm_disk_type" {
  type    = string
  default = "network-hdd"
}

variable "vm_username" {
  type    = string
  default = "ubuntu"
}

variable "vm_ssh_pub_key_path" {
  type      = string
  sensitive = true
}

variable "vm_ssh_pvt_key_path" {
  type      = string
  sensitive = true
}

## networks

variable "net_name" {
  type    = string
  default = "dez_net"
}

variable "subnet_name" {
  type    = string
  default = "dez_subnet"
}

variable "subnet_v4_cidr" {
  type    = list(string)
  default = ["10.5.0.0/24"]
}

## clickhouse

variable "clkhs_cluster_version" {
  type    = string
  default = "4.4"
}

variable "clkhs_cluster_name" {
  type    = string
  default = "dez-cluster"
}

variable "clkhs_cluster_env" {
  type    = string
  default = "PRESTABLE"
}

variable "clkhs_resource_preset_id" {
  type    = string
  default = "b2.medium"
}

variable "clkhs_disk_size" {
  type    = number
  default = 20
}

variable "clkhs_disk_type" {
  type    = string
  default = "network-hdd"
}

variable "clkhs_user_name" {
  type      = string
  sensitive = true
}

variable "clkhs_user_pass" {
  type      = string
  sensitive = true
}

variable "clkhs_db_name" {
  type    = string
  default = "dezdb"
}

variable "clkhs_user_roles" {
  type    = list(string)
  default = ["mdbDbAdmin"]
}

variable "clkhs_config" {
  type = map(any)
  default = {
    log_level                       = "TRACE",
    max_connections                 = 100,
    max_concurrent_queries          = 50,
    keep_alive_timeout              = 3000,
    uncompressed_cache_size         = 8589934592,
    mark_cache_size                 = 5368709120,
    max_table_size_to_drop          = 53687091200,
    max_partition_size_to_drop      = 53687091200,
    timezone                        = "UTC",
    geobase_uri                     = "",
    query_log_retention_size        = 1073741824,
    query_log_retention_time        = 2592000,
    query_thread_log_enabled        = true,
    query_thread_log_retention_size = 536870912,
    query_thread_log_retention_time = 2592000,
    part_log_retention_size         = 536870912,
    part_log_retention_time         = 2592000,
    metric_log_enabled              = true,
    metric_log_retention_size       = 536870912,
    metric_log_retention_time       = 2592000,
    trace_log_enabled               = true,
    trace_log_retention_size        = 536870912,
    trace_log_retention_time        = 2592000,
    text_log_enabled                = true,
    text_log_retention_size         = 536870912,
    text_log_retention_time         = 2592000,
    text_log_level                  = "TRACE",
    background_pool_size            = 16,
    background_schedule_pool_size   = 16
  }
}

variable "clkhs_admin_pass" {
  type      = string
  sensitive = true
}

variable "clkhs_host_public_ip" {
  type    = bool
  default = true
}

variable "clkhs_access_data_lens" {
  type    = bool
  default = true
}

variable "clkhs_access_web_sql" {
  type    = bool
  default = true
}

variable "clkhs_cloud_storage_enabled" {
  type    = bool
  default = true
}

variable "clkhs_cloud_storage_move_factor" {
  type    = number
  default = 0.15
}