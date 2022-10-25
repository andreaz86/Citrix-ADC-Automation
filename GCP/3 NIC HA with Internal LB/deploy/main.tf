module "vpc" {
  source     = "./modules/vpc"
  vpc_config = var.vpc_config
  gcp_region = var.gcp_region
  adc_vm     = var.adc_vm
}

module "loadbalancer" {
  source               = "./modules/loadbalancer"
  vpc_config           = var.vpc_config
  client_subnetself_id = module.vpc.client_subnetself_id
  client_vpcself_id    = module.vpc.client_vpcself_id
  adc01_id             = module.adc.adc01_id
  adc02_id             = module.adc.adc02_id
  vip_ip               = var.vip_ip
  adc01_self_link      = module.adc.adc01_self_link
  adc02_self_link      = module.adc.adc02_self_link
}

module "adc" {
  source               = "./modules/compute_instances/adc"
  adc_vm               = var.adc_vm
  vmname_prefix        = var.vmname_prefix
  server_subnetself_id = module.vpc.server_subnetself_id
  mgmt_subnetself_id   = module.vpc.mgmt_subnetself_id
  client_subnetself_id = module.vpc.client_subnetself_id
}

module "backend" {
  source               = "./modules/compute_instances/backend"
  backend_vm           = var.backend_vm
  vmname_prefix        = var.vmname_prefix
  server_subnetself_id = module.vpc.server_subnetself_id
}

module "client" {
  source               = "./modules/compute_instances/client"
  client_vm             = var.client_vm
  vmname_prefix        = var.vmname_prefix
  client_subnetself_id = module.vpc.client_subnetself_id
  username             = var.username
  password             = var.password
}

module "monitoring" {
  source               = "./modules/compute_instances/monitoring"
  vpc_selfid           = module.vpc.server_vpcself_id
  monitoring_vm        = var.monitoring_vm
  server_subnetself_id = module.vpc.server_subnetself_id
  username             = var.username
  password             = var.password
  vmname_prefix        = var.vmname_prefix
}


