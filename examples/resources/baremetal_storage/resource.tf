terraform {
  required_providers {
    airtelcloudgcc = {
      source  = "Airtel-Cloud-Platform/airtelcloudgcc"
      version = "1.0.0"
    }
  }
}

provider "airtelcloudgcc" {
  api_endpoint = "https://gcc-south.cloud.airtel.in"
  api_key      = var.airtel_api_key
  api_secret   = var.airtel_api_secret
  region       = "south"
  organization = var.organization
  project_name = var.project_name
}

variable "airtel_api_key" {
  description = "Airtel Cloud API key"
  type        = string
  sensitive   = true
}

variable "airtel_api_secret" {
  description = "Airtel Cloud API secret"
  type        = string
  sensitive   = true
}

variable "organization" {
  description = "organization for the resources"
  type        = string
}

variable "project_name" {
  description = "Project for the resources"
  type        = string
}

resource "airtelcloudgcc_baremetal_storage" "data" {
  name              = "ak-store"
  availability_zone = "S1"
  size              = 10
  description       = "Create new baremetal storage"
}

output "volume_id" {
  value = airtelcloudgcc_baremetal_storage.data.id
}

output "volume_state" {
  value = airtelcloudgcc_baremetal_storage.data.state
}
