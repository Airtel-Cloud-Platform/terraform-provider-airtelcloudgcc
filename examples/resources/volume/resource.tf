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

variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "tft"
}

# Create a block storage volume with all common attributes
resource "airtelcloudgcc_volume" "data_volume" {
  name              = "${var.resource_prefix}-storage-volume"
  size              = 50
  type              = "s1_wkld_ntp02_4iops_backend"
  availability_zone = "S1"
  compute_name      = "my-instance"

  # Networking
  vpc_name    = "copper-vpc01"
  subnet_name = "subnet-26jun"

  is_encrypted = false
  bootable     = false
}

# Create a secondary volume (alternative configuration)
#resource "airtelcloudgcc_volume" "backup_volume" {
#  name              = "${var.resource_prefix}-backup-volume"
#  size              = 100
#  type              = "s1_wkld_ntp02_4iops_backend"
#  availability_zone = "S1"
#  compute_name      = "my-instance"
#
#  vpc_name    = "copper-vpc01"
#  subnet_name = "subnet-26jun"
#
#  is_encrypted = true
#  bootable     = false
#}

# Output volume details
output "data_volume_uuid" {
  description = "UUID of the data volume"
  value       = airtelcloudgcc_volume.data_volume.uuid
}

output "data_volume_status" {
  description = "Status of the data volume"
  value       = airtelcloudgcc_volume.data_volume.status
}

#output "backup_volume_uuid" {
#  description = "UUID of the backup volume"
#  value       = airtelcloudgcc_volume.backup_volume.uuid
#}
