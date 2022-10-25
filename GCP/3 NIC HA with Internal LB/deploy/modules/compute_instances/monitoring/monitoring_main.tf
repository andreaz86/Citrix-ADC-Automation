resource "google_compute_instance" "mon_vm" {
  name         = "${var.vmname_prefix}${var.monitoring_vm.name}"
  machine_type = var.monitoring_vm.vmtype
  zone         = var.monitoring_vm.zone
  tags         = ["ssh", "monitoring"]
  scheduling {
    provisioning_model          = "SPOT"
    preemptible                 = "true"
    automatic_restart           = "false"
    instance_termination_action = "STOP"
  }
  boot_disk {
    initialize_params {
      image = var.monitoring_vm.vmimage
      type  = var.monitoring_vm.disktype
      size  = var.monitoring_vm.disksize
    }
  }
  network_interface {
    subnetwork = var.server_subnetself_id
    network_ip = var.monitoring_vm.ip
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.ssh_username}:${var.ssh_key}"
  }
}