resource "google_compute_health_check" "tcp-health-check" {
  name = "tcp-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_instance_group" "instance_group_adc01" {
  name = "ig-adc01"
  instances = [
    var.adc01_self_link
  ]
  zone = "europe-west4-a"
}

resource "google_compute_instance_group" "instance_group_adc02" {
  name = "ig-adc02"
  instances = [
    var.adc02_self_link
  ]
  zone = "europe-west4-b"
}


resource "google_compute_region_backend_service" "adc-be" {
  name             = "backend-service"
  health_checks    = [google_compute_health_check.tcp-health-check.id]
  protocol         = "TCP"
  session_affinity = "NONE"
  dynamic "backend" {
    for_each = toset([
      google_compute_instance_group.instance_group_adc01.id,
      google_compute_instance_group.instance_group_adc02.id,
    ])
    content {
      group          = backend.key
      balancing_mode = "CONNECTION"
    }
  }
}

resource "google_compute_forwarding_rule" "lb_adc_fe" {
  all_ports             = true
  backend_service       = google_compute_region_backend_service.adc-be.id
  ip_protocol           = "TCP"
  ip_address            = var.vip_ip
  load_balancing_scheme = "INTERNAL"
  name                  = "lb-adc-fe"
  network               = var.client_vpcself_id
  network_tier          = "PREMIUM"
  region                = "europe-west4"
  subnetwork            = var.client_subnetself_id
}
