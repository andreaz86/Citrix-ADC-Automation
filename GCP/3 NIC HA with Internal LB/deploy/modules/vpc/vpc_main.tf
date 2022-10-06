# VPC
resource "google_compute_network" "vpc_server" {
  name                    = var.vpc_config.server.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_mgmt" {
  name                    = var.vpc_config.mgmt.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_client" {
  name                    = var.vpc_config.client.vpc_name
  auto_create_subnetworks = false
}

# SUBNET
resource "google_compute_subnetwork" "server_subnet" {
  name                     = var.vpc_config.server.subnet_name
  ip_cidr_range            = var.vpc_config.server.subnet_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.vpc_server.self_link
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "mgmt_subnet" {
  name                     = var.vpc_config.mgmt.subnet_name
  ip_cidr_range            = var.vpc_config.mgmt.subnet_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.vpc_mgmt.self_link
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "client_subnet" {
  name                     = var.vpc_config.client.subnet_name
  ip_cidr_range            = var.vpc_config.client.subnet_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.vpc_client.self_link
  private_ip_google_access = true
}
