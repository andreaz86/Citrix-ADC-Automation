resource "google_compute_instance" "backend_vm" {
  for_each     = var.backend_vm
  name         = "${var.vmname_prefix}${each.value.name}"
  machine_type = each.value.vmtype
  zone         = each.value.zone
  tags         = ["ssh", "monitoring"]
  scheduling {
    provisioning_model          = "SPOT"
    preemptible                 = "true"
    automatic_restart           = "false"
    instance_termination_action = "STOP"
  }
  boot_disk {
    initialize_params {
      image = each.value.vmimage
      type  = each.value.disktype
      size  = each.value.disksize
    }
  }
  network_interface {
    subnetwork = var.server_subnetself_id
    network_ip = each.value.ip
    access_config {
  }

  }
  metadata = {
    ssh-keys = "${var.ssh_username}:${var.ssh_key}"
    startup-script = <<-EOF1
      #! /bin/bash
      set -euo pipefail

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx-light jq

      NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
      IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")

      cat <<EOF > /var/www/html/index.html
      <pre>
      Name: $NAME
      IP: $IP
      </pre>
      EOF
    EOF1
  }
}