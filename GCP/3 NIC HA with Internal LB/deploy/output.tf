output "adc01_instance_id" {
  value = module.adc.adc01_instance_id
}

output "adc02_instance_id" {
  value = module.adc.adc02_instance_id
}

output "adc01_public_ip" {
  value = module.adc.adc01_public_ip
}

output "adc02_public_ip" {
  value = module.adc.adc02_public_ip
}

output "adc01_nsip" {
  value = var.adc_vm.adc01.mgmt_ip
}

output "adc02_nsip" {
  value = var.adc_vm.adc02.mgmt_ip
}

output "vip_ip" {
  value = var.vip_ip
}

output "backend_ip" {
  value = var.backend_vm.mon01.ip
}