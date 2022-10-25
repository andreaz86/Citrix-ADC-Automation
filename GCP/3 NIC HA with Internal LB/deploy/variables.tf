# GCP Project Setup
variable "gcp_project_id" {}
variable "gcp_region" {}
variable "gcp_zone" {}
variable "gcp_project_name" {}

# VM Variables
variable "vmname_prefix" {}

# Account Variables
variable "username" {}
variable "password" {}

########### VM CONFIG ##############

variable "vip_ip" {
  default = "192.168.3.4"
}

variable "monitoring_vm" {
  description = "Monitoring VM config"
  type        = map(any)
  default = {
      name     = "mon01"
      vmtype   = "n2-standard-2"
      zone     = "europe-west4-a"
      ip       = "192.168.3.5"
      vmimage  = "ubuntu-os-cloud/ubuntu-2204-lts"
      disktype = "pd-standard"
      disksize = "40"
  }
}
variable "backend_vm" {
  description = "Backend VM configuration"
  default = {
    backend01 = {
      name     = "backend01"
      vmtype   = "e2-medium"
      zone     = "europe-west4-a"
      ip       = "192.168.2.4"
      vmimage  = "debian-cloud/debian-10"
      disktype = "pd-standard"
      disksize = "10"
    }
    backend02 = {
      name     = "backend02"
      vmtype   = "e2-medium"
      zone     = "europe-west4-b"
      ip       = "192.168.2.5"
      vmimage  = "debian-cloud/debian-10"
      disktype = "pd-standard"
      disksize = "10"
    }
  }
}

variable "client_vm" {
  description = "Client VM to be used as host in the Client Network"
  default = {
      name     = "client01"
      vmtype   = "e2-medium"
      zone     = "europe-west4-a"
      ip       = "192.168.3.6"
      vmimage  = "windows-cloud/windows-2022"
      disktype = "pd-standard"
  }
}

variable "adc_vm" {
  description = "Citrix ADC "
  default = {
    adc01 = {
      name      = "adc01"
      vmtype    = "e2-standard-4"
      zone      = "europe-west4-a"
      mgmt_ip   = "192.168.1.2"
      server_ip = "192.168.2.2"
      client_ip = "192.168.3.2"
      vmimage   = "projects/citrix-master-project/global/images/citrix-adc-vpx-byol-13-1-9-60"
      disktype  = "pd-standard"
    }
    adc02 = {
      name      = "adc02"
      vmtype    = "e2-standard-4"
      zone      = "europe-west4-b"
      mgmt_ip   = "192.168.1.3"
      server_ip = "192.168.2.3"
      client_ip = "192.168.3.3"
      vmimage   = "projects/citrix-master-project/global/images/citrix-adc-vpx-byol-13-1-9-60"
      disktype  = "pd-standard"
    }
  }
}

#######################################################

# GCP VPC and Subnet Setup

variable "vpc_config" {
  description = "GCP network configs"
  type        = map(any)
  default = {
    server = {
      vpc_name    = "ctx-server-vpc"
      subnet_cidr = "192.168.2.0/24"
      subnet_name = "ctx-server-subnet"
    }
    mgmt = {
      vpc_name    = "ctx-mgmt-vpc"
      subnet_cidr = "192.168.1.0/24"
      subnet_name = "ctx-mgmt-subnet"
    }
    client = {
      vpc_name    = "ctx-client-vpc"
      subnet_cidr = "192.168.3.0/24"
      subnet_name = "ctx-client-subnet"
    }
  }
}

