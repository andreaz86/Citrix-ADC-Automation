resource "google_compute_instance" "vm_adc01" {
  name         = "${var.vmname_prefix}${var.adc_vm.adc01.name}"
  machine_type = var.adc_vm.adc01.vmtype
  zone         = var.adc_vm.adc01.zone
  tags         = ["ssh", "adc", "https"]

  boot_disk {
    device_name = "boot"
    auto_delete = true
    initialize_params {
      image = var.adc_vm.adc01.vmimage
    }
  }

  scheduling {
    provisioning_model          = "SPOT"
    preemptible                 = "true"
    automatic_restart           = "false"
    instance_termination_action = "STOP"
  }

  # Client
  network_interface {
    subnetwork = var.client_subnetself_id
    network_ip = var.adc_vm.adc01.client_ip
  }

  network_interface {
    subnetwork = var.mgmt_subnetself_id
    network_ip = var.adc_vm.adc01.mgmt_ip
    access_config {
    }
  }

  network_interface {
    subnetwork = var.server_subnetself_id
    network_ip = var.adc_vm.adc01.server_ip
  }

  service_account {
    email = "562786585484-compute@developer.gserviceaccount.com"
    #email = "default"
    scopes = ["cloud-platform"]
  }
  allow_stopping_for_update = true
  metadata_startup_script   = <<EOT
  <NS-PRE-BOOT-CONFIG>
	<NS-BOOTSTRAP>
		<SKIP-DEFAULT-BOOTSTRAP>YES</SKIP-DEFAULT-BOOTSTRAP>
		<NEW-BOOTSTRAP-SEQUENCE>YES</NEW-BOOTSTRAP-SEQUENCE>
		
		<MGMT-INTERFACE-CONFIG>
			<INTERFACE-NUM>eth1</INTERFACE-NUM>
		</MGMT-INTERFACE-CONFIG>
		
		<CLIENT-INTERFACE-CONFIG>
			<INTERFACE-NUM>eth0</INTERFACE-NUM>
		</CLIENT-INTERFACE-CONFIG>
		
		<SERVER-INTERFACE-CONFIG>
			<INTERFACE-NUM>eth2</INTERFACE-NUM>
		</SERVER-INTERFACE-CONFIG>
	</NS-BOOTSTRAP>
</NS-PRE-BOOT-CONFIG>
EOT
}
