output "instances" {
  value = {
    details = google_compute_instance_from_template.centos_example
  }
}

output "ips" {
  value = google_compute_address.instance_centos_ips
}
