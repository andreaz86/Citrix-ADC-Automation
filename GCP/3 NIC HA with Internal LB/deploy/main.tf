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

# resource "time_sleep" "wait_30_seconds" {
#   depends_on = [null_resource.previous]

#   destroy_duration = "30s"
# }

# module "adc_config" {
#   source              = "./modules/adc_config"
#   providers = {
#     citrixadc.adc01 = citrixadc.primary
#     citrixadc.adc02 = citrixadc.secondary
#   }
#   adc01_instance_id = module.adc.adc01_instance_id
#   adc02_instance_id = module.adc.adc02_instance_id
#   password = var.password
#   depends_on = [
#     module.adc
#   ]
# }