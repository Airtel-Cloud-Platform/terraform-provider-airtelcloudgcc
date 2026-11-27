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

# Create a VPC with DNS support
resource "airtelcloudgcc_vpc" "main" {
  name                 = "example-vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = "example"
    Purpose     = "vpc-demo"
    Team        = "infrastructure"
  }
}

# Create a second VPC for multi-vpc scenarios
resource "airtelcloudgcc_vpc" "secondary" {
  name                 = "secondary-vpc"
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false

  tags = {
    Environment = "example"
    Purpose     = "secondary-network"
    Team        = "infrastructure"
  }
}

# Output VPC details
output "main_vpc_id" {
  description = "ID of the main VPC"
  value       = airtelcloudgcc_vpc.main.id
}

output "main_vpc_state" {
  description = "State of the main VPC"
  value       = airtelcloudgcc_vpc.main.state
}

output "main_vpc_cidr" {
  description = "CIDR block of the main VPC"
  value       = airtelcloudgcc_vpc.main.cidr_block
}

output "secondary_vpc_id" {
  description = "ID of the secondary VPC"
  value       = airtelcloudgcc_vpc.secondary.id
}
