# This will create an inventory file to be used from ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("./templates/hosts.tftpl",
    {
      monitoring                          = module.monitoring.monitoring_external_ip
      windowsvda                          = module.win_vda.vda_external_ip
      terraform_user                      = var.username
      terraform_pwd                       = var.password
      admin_password                      = var.admin_password
    }
  )
  filename = "./ansible/inventory.ini"
}
