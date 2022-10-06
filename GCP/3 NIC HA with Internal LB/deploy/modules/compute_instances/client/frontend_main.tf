resource "google_compute_instance" "client_vm" {
  name         = "${var.vmname_prefix}${var.client_vm.name}"
  machine_type = var.client_vm.vmtype
  zone         = var.client_vm.zone
  tags         = ["ssh", "rdp", "cloudconnector"]
  scheduling {
    provisioning_model          = "SPOT"
    preemptible                 = "true"
    automatic_restart           = "false"
    instance_termination_action = "STOP"
  }
  boot_disk {
    initialize_params {
      image = var.client_vm.vmimage
      type  = var.client_vm.disktype
    }
  }
  network_interface {
    subnetwork = var.client_subnetself_id
    network_ip = var.client_vm.ip
    access_config {

    }
  }
  metadata = {
    windows-startup-script-cmd = "net user ${var.username} \"${var.password}\" /add /y & wmic UserAccount where Name=\"${var.username}\" set PasswordExpires=False & net localgroup administrators ${var.username} /add & powershell Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 & powershell New-ItemProperty -Path \"HKLM:\\SOFTWARE\\OpenSSH\" -Name DefaultShell -Value \"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe\" -PropertyType String -Force  & powershell Start-Service sshd & powershell Set-Service -Name sshd -StartupType 'Automatic' & powershell New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 & powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"Set-ExecutionPolicy -ExecutionPolicy bypass -Force\""
  }
}