output "base_vm_ip" {
  value     = yandex_compute_instance.base_vm.network_interface.0.nat_ip_address
  sensitive = false
}

# output "mysql_vm_id" {
#   value     = yandex_compute_instance.base_vm.id
#   sensitive = false
# }

# output "mysql_managed_id" {
#   value     = yandex_mdb_mysql_cluster.mysql_managed.id
#   sensitive = false
# }

# output "datalens_address" {
#   value     = "to be decided"
#   sensitive = false
# }