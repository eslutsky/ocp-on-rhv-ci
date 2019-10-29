#todo: create firewal rules for 22



provider "google" {
  project = "openshift-gce-devel"
  region  = "us-central1"
  zone    = "us-central1-b"
}
resource "google_compute_network" "rhv-network"{
    name = "ocp-rhv-network"
}

resource "google_compute_subnetwork" "rhv-subnetwork"{
    name = "ocp-rhv-subnetwork"
    network = "${google_compute_network.rhv-network.self_link}"
    ip_cidr_range = "10.0.0.0/24"
    #gateway_address = "10.0.0.1"
    private_ip_google_access = true
}

#firewall rules from all sources
resource "google_compute_firewall" "ocp-rhv-firewall-all" {
  name    = "ocp-rhv-firewall-all"
  network = "${google_compute_network.rhv-network.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["6443", "443", "22"]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

#allow all communications internally
resource "google_compute_firewall" "ocp-rhv-firewall-internal" {
  name    = "ocp-rhv-firewall-internal"
  network = "${google_compute_network.rhv-network.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    #ports    = ["6443", "443", "80"]
  }

  source_ranges = [ "10.0.0.0/24" ]
}

resource "google_compute_network" "default" {
  name = "test-network"
}
resource "google_compute_instance" "engine-instance" {
  name         = "${var.rhv-engine-name}"
  machine_type = "custom-${var.rhv-engine-vcpu}-${var.rhv-engine-memory}"
  boot_disk {
    initialize_params {
      image = "${var.rhv-base-image}"
      size = "${var.rhv-engine-disk-size}"
    }
  }
network_interface {
    # A default network is created for all GCP projects
    network       = "${google_compute_network.rhv-network.self_link}"
    subnetwork = "${google_compute_subnetwork.rhv-subnetwork.self_link}"
    access_config {
    }
  }

 metadata = {
    ssh-keys =  "${var.gce-ssh-user}:${file(var.gce-ssh-pub-key-file)}"
  }
}


/*
#
resource "google_compute_disk" "host-nested-disk" {
  name  = "rhv-host-nested-disk"
  image = "${var.rhv-base-image}"
  size = 200
}


#image creation requires compute.images.create' permission - it comes in "Compute Admin " Roles
resource "google_compute_image" "host-nested-image" {
  name = "rhv-host-nested-image"
  source_disk = "rhv-host-nested-disk"
  licenses = [
      "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
  ]
  #disk_size_gb = 200
  #source_disk = "host-nested-disk"
}
*/

resource "google_compute_instance" "host-instance" {
  name         = "${var.rhv-host-name}"
  machine_type = "custom-${var.rhv-host-vcpu}-${var.rhv-host-memory}"
  boot_disk {
    initialize_params {
      image = "gzaidman-nested-vm-image-1"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "${google_compute_network.rhv-network.self_link}"
    subnetwork = "${google_compute_subnetwork.rhv-subnetwork.self_link}"
    access_config {
    }
  }

  metadata = {
    ssh-keys =  "${var.gce-ssh-user}:${file(var.gce-ssh-pub-key-file)}"
  }
}
