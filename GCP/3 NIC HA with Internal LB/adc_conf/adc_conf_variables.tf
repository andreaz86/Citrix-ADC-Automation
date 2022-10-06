
variable "password" {
    default = "!Friskies2019!"
}


data "terraform_remote_state" "adc" {
  backend = "local"

  config = {
    path = "../deploy/terraform.tfstate"
  }
}