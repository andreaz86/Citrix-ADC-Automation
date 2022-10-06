
resource "google_compute_firewall" "default-allow-client-internalnet" {
  name    = "default-allow-client-internalnet"
  network = google_compute_network.vpc_client.self_link
  allow {
    protocol = "all"
  }
  source_ranges = [var.vpc_config.client.subnet_cidr]
}



resource "google_compute_firewall" "allow-healthcheck-client" {
  name    = "allow-healthcheck-client"
  network = google_compute_network.vpc_client.self_link
  allow {
    protocol = "all"
  }
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

