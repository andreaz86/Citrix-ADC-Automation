output "monitoring_external_ip" {
  value = google_compute_instance.mon_vm.network_interface.0.access_config.0.nat_ip
}

