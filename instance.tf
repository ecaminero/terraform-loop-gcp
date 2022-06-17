# Create Template
## We are just going to create a template
module "template_instance_centos" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.7.0"

  name_prefix  = "centos-${local.name}"
  labels       = local.default_labels
  disk_size_gb = local.instance_config.disk_size_gb
  disk_type    = local.instance_config.disk_type
  machine_type = local.instance_config.machine_type
  source_image = local.instance_config.source_image
  auto_delete  = "true"
  subnetwork   = local.subnetwork

  tags = local.tags
  service_account = {
    email  = google_service_account.centos_instance.email
    scopes = [
      "storage-rw", 
      "logging-write", 
      "monitoring-read"
    ]
  }

  depends_on = [
    google_service_account.centos_instance
  ]
}

# We are just going to create a service account
resource "google_service_account" "centos_instance" {
  account_id   = "sa-instance-${local.name}"
  display_name = "Service account for centos instance"
}

# In this part we're going to create an Ip for each machine, this is defined by the Count
resource "google_compute_address" "instance_centos_ips" {
  count = local.instance_config.num
  
  network_tier = "PREMIUM"
  name = "instance-centos-external-ip-${count.index}"
}

# Creating an Aditional disk for each machine, this is defined by the Count
resource "google_compute_disk" "data_disks" {
  count = local.instance_config.num

  name  = "centos-disk-data-${count.index}"
  type  = "pd-ssd"
  zone  = var.zone
  size = 50
  physical_block_size_bytes = 4096
}


# Creating the amount of machines defined by the Count
resource "google_compute_instance_from_template" "centos_example" {
  count = local.instance_config.num
  
  name = "centos-${count.index}"
  source_instance_template = module.template_instance_centos.self_link
  zone = var.zone
  metadata = local.metadata # Using  the metadata to configure the instance

  // Override fields from instance template
  network_interface {
    subnetwork   = local.subnetwork

    access_config {
      nat_ip = google_compute_address.instance_centos_ips[count.index].address
    }
  }
  can_ip_forward = false
}


# Add a persistent disk to your VM 
resource "google_compute_attached_disk" "aditional_data_disk" {
  count = length(google_compute_instance_from_template.centos_example)

  disk     = google_compute_disk.data_disks[count.index].id
  instance = google_compute_instance_from_template.centos_example[count.index].id
}