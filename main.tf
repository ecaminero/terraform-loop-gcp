provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}


locals {
  name = "example"
  tags = ["count"]

  instance_config = {
    source_image = "centos-8-v20210420"
    disk_size_gb = "20"
    num          = 2 # Cant of instances that will be created
    machine_type = "n1-standard-2"
    disk_type    = "pd-balanced"
  }
  
  subnetwork = "default"
  additional_disks = {
    disk_type = "local-ssd"
  }
  default_labels = {
      team = "developers"
  }
  metadata = {
    startup-script = file("${path.module}/scripts/mount-disk.sh")
  }

}