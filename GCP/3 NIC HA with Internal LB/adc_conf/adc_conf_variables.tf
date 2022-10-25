
variable "password" {
    default = "Aa123456!"
}


data "terraform_remote_state" "adc" {
  backend = "local"
  config = {
    path = "../deploy/terraform.tfstate"
  }
}

