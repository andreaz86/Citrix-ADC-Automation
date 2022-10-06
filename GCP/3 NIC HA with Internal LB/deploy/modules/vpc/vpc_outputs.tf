
output "server_vpcself_id" {
  value = google_compute_network.vpc_server.self_link
}

output "mgmt_vpcself_id" {
  value = google_compute_network.vpc_mgmt.self_link
}

output "client_vpcself_id" {
  value = google_compute_network.vpc_client.self_link
}
# Output subnetwork selfid

output "server_subnetself_id" {
  value = google_compute_subnetwork.server_subnet.self_link
}

output "mgmt_subnetself_id" {
  value = google_compute_subnetwork.mgmt_subnet.self_link
}

output "client_subnetself_id" {
  value = google_compute_subnetwork.client_subnet.self_link
}



