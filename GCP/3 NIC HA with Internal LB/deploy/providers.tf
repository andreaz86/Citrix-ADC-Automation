terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    tls = {
      source = "hashicorp/tls"
    }
    citrixadc = {
      source = "citrix/citrixadc"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "tls" {
  // no config needed
}



# locals {
#   adc1_url=  format("%s%s","https://",module.adc.adc01_public_ip)
#   adc2_url=  format("%s%s","https://",module.adc.adc02_public_ip)
# }