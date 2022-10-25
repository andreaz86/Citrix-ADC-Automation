resource "google_compute_firewall" "default-allow-server-internalnet" {
  name    = "default-allow-server-internalnet"
  network = google_compute_network.vpc_server.self_link
  allow {
    protocol = "all"
  }
  source_ranges = [var.vpc_config.server.subnet_cidr]
}

resource "google_compute_firewall" "allow-rdp-server" {
  name    = "allow-server-rdp"
  network = google_compute_network.vpc_server.self_link
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  target_tags   = ["rdp"]
}

resource "google_compute_firewall" "allow-ssh-server" {
  name    = "allow-server-ssh"
  network = google_compute_network.vpc_server.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "allow-graylog-server" {
  name    = "allow-server-graylog"
  network = google_compute_network.vpc_server.self_link
  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }
  source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  target_tags   = ["monitoring"]
}