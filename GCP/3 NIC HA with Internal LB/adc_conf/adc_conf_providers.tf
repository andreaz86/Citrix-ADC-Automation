terraform {
  required_providers {
    citrixadc = {
      source  = "citrix/citrixadc"
    }
  }
}

provider "citrixadc" {
  endpoint = "https://${data.terraform_remote_state.adc.outputs.adc01_public_ip}"
  username = "nsroot"
  password = var.password
  insecure_skip_verify = true
  alias = "adc01"
}

provider "citrixadc" {
  endpoint = "https://${data.terraform_remote_state.adc.outputs.adc02_public_ip}"
  username = "nsroot"
  password = var.password
  insecure_skip_verify = true
  alias = "adc02"
}