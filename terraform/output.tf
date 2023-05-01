output "base_vm_ip" {
  value     = yandex_compute_instance.base_vm.network_interface.0.nat_ip_address
  sensitive = false
}