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

# Allocate a VIP port for a Load Balancer Service.
# The VIP is auto-assigned from the LB service's network.
resource "airtelcloudgcc_lb_vip" "example" {
  lb_service_id = "ac238c5b-6334-49b9-b9c0-decc0aaf63d6"
}

output "vip_id" {
  description = "ID of the VIP port"
  value       = airtelcloudgcc_lb_vip.example.id
}

output "vip_fixed_ips" {
  description = "Fixed IP addresses assigned to the VIP"
  value       = airtelcloudgcc_lb_vip.example.fixed_ips
}

output "vip_status" {
  description = "Status of the VIP port"
  value       = airtelcloudgcc_lb_vip.example.status
}
