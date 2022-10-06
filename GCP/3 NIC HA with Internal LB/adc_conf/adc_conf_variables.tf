
variable "password" {
    default = "!P@sSw0rd01!"
}


data "terraform_remote_state" "adc" {
  backend = "local"

  config = {
    path = "../deploy/terraform.tfstate"
  }
}