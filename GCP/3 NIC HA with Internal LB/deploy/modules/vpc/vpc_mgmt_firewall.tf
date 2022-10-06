data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "google_compute_firewall" "default-allow-mgmt-internalnet" {
  name    = "default-allow-mgmt-internalnet"
  network = google_compute_network.vpc_mgmt.self_link
  allow {
    protocol = "all"
  }
  source_ranges = [var.vpc_config.mgmt.subnet_cidr]
}

resource "google_compute_firewall" "allow-https-adc" {
  name    = "allow-https-adc"
  network = google_compute_network.vpc_mgmt.self_link
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  target_tags   = ["adc"]
}