output "backend_vm_internal_ip" {
  value = {
    for k, backend_vm in google_compute_instance.backend_vm : k => backend_vm.network_interface.0.network_ip
  }
}

output "ssh_username" {
  value = split("@", data.google_client_openid_userinfo.me.email)[0]
}