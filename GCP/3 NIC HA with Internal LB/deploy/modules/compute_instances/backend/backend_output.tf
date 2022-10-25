output "backend_vm_internal_ip" {
  value = {
    for k, backend_vm in google_compute_instance.backend_vm : k => backend_vm.network_interface.0.network_ip
  }
}

