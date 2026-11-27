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

# Create a private bucket with versioning
resource "airtelcloudgcc_storage_bucket" "private_bucket" {
  name              = "${var.resource_prefix}-obj-bucket"
  replication_type  = "Local"
  replication_tag   = "south_S1"
  availability_zone = "S1"
  versioning        = true
  object_locking    = false

  tags = {
    Environment = "example"
    Type        = "private"
    Versioning  = "enabled"
  }
}

# Output bucket details
output "private_bucket_id" {
  description = "ID of the private bucket"
  value       = airtelcloudgcc_storage_bucket.private_bucket.id
}

output "private_bucket_name" {
  description = "Name of the private bucket"
  value       = airtelcloudgcc_storage_bucket.private_bucket.name
}

output "private_bucket_s3_endpoint" {
  description = "S3 endpoint for the private bucket"
  value       = airtelcloudgcc_storage_bucket.private_bucket.s3_endpoint
}

output "private_bucket_public_endpoint" {
  description = "Public endpoint for the private bucket"
  value       = airtelcloudgcc_storage_bucket.private_bucket.public_endpoint
}

output "private_bucket_state" {
  description = "State of the private bucket"
  value       = airtelcloudgcc_storage_bucket.private_bucket.state
}
