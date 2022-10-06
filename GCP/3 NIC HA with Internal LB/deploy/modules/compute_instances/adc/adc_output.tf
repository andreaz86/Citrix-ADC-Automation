output "adc01_id" {
  value = google_compute_instance.vm_adc01.id
}
output "adc01_self_link" {
  value = google_compute_instance.vm_adc01.self_link
}
output "adc02_id" {
  value = google_compute_instance.vm_adc02.id
}
output "adc02_self_link" {
  value = google_compute_instance.vm_adc02.self_link
}
output "adc01_public_ip" {
  value = google_compute_instance.vm_adc01.network_interface.1.access_config.0.nat_ip
}

output "adc02_public_ip" {
  value = google_compute_instance.vm_adc02.network_interface.1.access_config.0.nat_ip
}

output "adc01_instance_id" {
  value = google_compute_instance.vm_adc01.instance_id
}

output "adc02_instance_id" {
  value = google_compute_instance.vm_adc02.instance_id
}