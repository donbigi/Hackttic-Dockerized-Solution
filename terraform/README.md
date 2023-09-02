
create a yaml file  `main.tf`
```yaml

# Configure the Google Cloud provider
provider "google" {
  credentials = file("path-to-your-service-account.json") # Replace with the path to your service account key file
  project     = "PROJECT_ID" # Replace with your GCP Project ID
  region      = "REGION" # Replace with your desired region
  zone         = "ZONE" # Replace with your desired zone
}

# Reference the existing static IP address
data "google_compute_address" "existing_static_ip" {
  name = "server-registry" # Replace with the name of your existing static IP
}

# Create a firewall rule to allow incoming traffic on port 443
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default" # Replace with your desired network name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"] # You can restrict this to specific IP ranges if needed
  target_tags   = ["https-allow"] # Apply this rule to VMs with the "https-allow" tag
}

# Create an Ubuntu LTS 20.04 instance and use the existing static IP
resource "google_compute_instance" "my_instance" {
  name         = "local-server-registry" # Replace with your desired VM instance name
  machine_type = "n1-standard-1" # Replace with your desired machine type
  tags         = ["https-allow"]
  labels = {
    registry_server = ""
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts" # Ubuntu LTS 20.04 image
    }
  }

  # Use the existing static IP address
  network_interface {
    network = "default" # Replace with your desired network name
    access_config {
      nat_ip = data.google_compute_address.existing_static_ip.address
    }
  }

}
```

Initialise terraform on folder:
```shell
terraform init
```

Plan terraform:
```shell
terraform plan
```

Apply terraform:
```shell
terraform apply 
```
