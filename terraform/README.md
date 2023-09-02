# Provision VM in GCP Using Terraform, Configure firewall rule and add static IP

## Google Cloud Provider Configuration

This README.md file provides instructions for configuring the Google Cloud provider and creating resources like a static IP address, firewall rule, and a virtual machine instance using Terraform.

### Step 1: Configure the Google Cloud Provider

In the Terraform script provided, you need to configure the Google Cloud provider with your service account credentials, GCP Project ID, desired region, and zone. Make sure you replace the placeholders with your own values.

```hcl
provider "google" {
  credentials = file("path-to-your-service-account.json") # Replace with the path to your service account key file
  project     = "PROJECT_ID" # Replace with your GCP Project ID
  region      = "REGION" # Replace with your desired region
  zone        = "ZONE" # Replace with your desired zone
}
```

### Step 2: Reference the Existing Static IP Address

The Terraform script references an existing static IP address named "server-registry." Ensure that you replace this name with the name of your existing static IP if it differs.

```hcl
data "google_compute_address" "existing_static_ip" {
  name = "server-registry" # Replace with the name of your existing static IP
}
```

### Step 3: Create a Firewall Rule

A firewall rule named "allow-https" is created to allow incoming traffic on port 443. You can customize the network name, protocol, and source ranges as needed.

```hcl
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
```

### Step 4: Create an Ubuntu LTS 20.04 Instance

This Terraform script creates a virtual machine instance using an Ubuntu LTS 20.04 image. Make sure to specify your desired instance name, machine type, and network name. The existing static IP address is associated with this instance.

```hcl
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

These steps guide you through configuring the Google Cloud provider and creating essential resources using Terraform. Make sure to execute the Terraform script to provision the resources in your Google Cloud environment.

create a yaml file  `main.tf`

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
