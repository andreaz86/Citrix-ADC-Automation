# This will create an inventory file to be used from ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("./hosts.tftpl",
    {
      monitoring                          = module.monitoring.monitoring_external_ip
      ssh_username        = "${split("@", data.google_client_openid_userinfo.me.email)[0]}"
    }
  )
  filename = "../ansible/inventory.ini"
}
