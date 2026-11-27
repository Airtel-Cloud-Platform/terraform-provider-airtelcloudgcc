---
page_title: "Airtel Cloud Provider"
description: |-
  The Airtel Cloud provider for Terraform allows you to manage Airtel Cloud resources.
---

# Airtel Cloud Provider

The Airtel Cloud provider allows Terraform to manage Airtel Cloud infrastructure resources such as virtual machines, volumes, VPCs, subnets, object storage buckets, file storage (NFS), and DNS records.

-> **New to this provider?** See the [Getting Started Guide](guides/getting-started) for a full walkthrough.

-> **Complete Resource Guide:** See the [User Guide](guides/user-guide) for all 26 resources with examples, argument references, and import instructions.

## Example Usage

```terraform
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
```

## Authentication

The provider authenticates using an HMAC-SHA256 scheme that requires both an API key and an API secret. You can supply credentials in the following ways:

1. **Provider configuration** (recommended for CI/CD)
2. **Environment variables**: `AIRTEL_API_KEY`, `AIRTEL_API_SECRET` 
3. **Terraform variable files** (see below)

### Provider Configuration

```terraform
provider "airtelcloudgcc" {
  api_endpoint = "https://gcc-south.cloud.airtel.in"
  api_key      = "your-api-key-here"
  api_secret   = "your-api-secret-here"
  region       = "south"
}
```

### Environment Variables

```bash
export AIRTEL_API_KEY="your-api-key-here"
export AIRTEL_API_SECRET="your-api-secret-here"

# Optional provider setting fallbacks
export AIRTEL_API_ENDPOINT="https://gcc-south.cloud.airtel.in"
export AIRTEL_REGION="south"
export AIRTEL_ORGANIZATION="your-organization"
export AIRTEL_PROJECT_NAME="your-project"
export AIRTEL_SUBNET_ID="your-default-subnet-id"
```

### Using Variables

```terraform
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

provider "airtelcloudgcc" {
  api_endpoint = "https://gcc-south.cloud.airtel.in"
  api_key      = var.airtel_api_key
  api_secret   = var.airtel_api_secret
  region       = "south"
}
```

## Configuration Reference

The following arguments are supported in the provider configuration:

- `api_endpoint` (Optional) - The Airtel Cloud API endpoint URL. Defaults to `https://gcc-south.cloud.airtel.in`.
- `api_key` (Required) - The API key for authenticating with Airtel Cloud API. Can also be set via the `AIRTEL_API_KEY` environment variable.
- `api_secret` (Required) - The API secret for HMAC authentication. Can also be set via the `AIRTEL_API_SECRET` environment variable.
- `region` (Optional) - The default region for resources. Defaults to `south`.
- `organization` (Optional) - Organization name or domain for Airtel Cloud.
- `project_name` (Optional) - Project name for Airtel Cloud API calls.
- `subnet_id` (Optional) - Default subnet ID used for volume API provider lookup.

## Available Resources

The provider supports the following 31 resources:

**Compute:**
- [`airtelcloudgcc_vm`](resources/vm) - Virtual Machine
- [`airtelcloudgcc_asg`](resources/asg) - Autoscaling Group
- [`airtelcloudgcc_baremetal`](resources/baremetal) - Baremetal Server
- [`airtelcloudgcc_kubernetes`](resources/kubernetes) - Kubernetes Cluster (CKP)
- [`airtelcloudgcc_compute_snapshot`](resources/compute_snapshot) - Compute Snapshot

**Storage:**
- [`airtelcloudgcc_volume`](resources/volume) - Block Storage Volume
- [`airtelcloudgcc_storage_bucket`](resources/storage_bucket) - Object Storage Bucket
- [`airtelcloudgcc_storage_access_key`](resources/storage_access_key) - Object Storage Access Key
- [`airtelcloudgcc_file_storage`](resources/file_storage) - File Storage (NFS Volume)
- [`airtelcloudgcc_file_storage_export_path`](resources/file_storage_export_path) - File Storage Export Path
- [`airtelcloudgcc_baremetal_storage`](resources/baremetal_storage) - Baremetal Block Storage

**Database:**
- [`airtelcloudgcc_postgres`](resources/postgres) - PostgreSQL Cluster
- [`airtelcloudgcc_mssql`](resources/mssql) - Microsoft SQL Server Instance
- [`airtelcloudgcc_mariadb`](resources/mariadb) - MariaDB Cluster

**Networking:**
- [`airtelcloudgcc_vpc`](resources/vpc) - Virtual Private Cloud
- [`airtelcloudgcc_subnet`](resources/subnet) - VPC Subnet
- [`airtelcloudgcc_security_group`](resources/security_group) - Security Group
- [`airtelcloudgcc_security_group_rule`](resources/security_group_rule) - Security Group Rule
- [`airtelcloudgcc_vpc_peering`](resources/vpc_peering) - VPC Peering
- [`airtelcloudgcc_lb_service`](resources/lb_service) - Load Balancer Service
- [`airtelcloudgcc_lb_vip`](resources/lb_vip) - Load Balancer VIP
- [`airtelcloudgcc_lb_certificate`](resources/lb_certificate) - Load Balancer Certificate
- [`airtelcloudgcc_lb_virtual_server`](resources/lb_virtual_server) - Load Balancer Virtual Server

**Security:**
- [`airtelcloudgcc_public_ip`](resources/public_ip) - Public IP reservation
- [`airtelcloudgcc_public_ip_attachment`](resources/public_ip_attachment) - Public IP attach to VM or LB
- [`airtelcloudgcc_public_ip_policy_rule`](resources/public_ip_policy_rule) - Public IP Policy Rule

**DNS:**
- [`airtelcloudgcc_dns_zone`](resources/dns_zone) - DNS Zone
- [`airtelcloudgcc_dns_record`](resources/dns_record) - DNS Record

**Alerting:**
- [`airtelcloudgcc_alert`](resources/alert) - Metric Alert

**Backup:**
- [`airtelcloudgcc_protection_plan`](resources/protection_plan) - Protection Plan
- [`airtelcloudgcc_protection`](resources/protection) - Protection Policy

## Example Infrastructure

Here's an example that creates an object storage bucket and an NFS volume with an export path:

```terraform
# Create a private bucket with versioning
resource "airtelcloudgcc_storage_bucket" "private_bucket" {
  name              = "tf-private-bucket"
  replication_type  = "Local"
  replication_tag   = "south_S1"
  availability_zone = "S1"
  versioning        = true
  object_locking    = false
}

# Create an NFS volume
resource "airtelcloudgcc_file_storage" "basic" {
  name              = "basic-nfs"
  size              = "300"
  availability_zone = "S2"
}

# Create an NFS export path
resource "airtelcloudgcc_file_storage_export_path" "nfsv4_export" {
  volume              = airtelcloudgcc_file_storage.basic.name
  description         = "NFSv4 export for application servers"
  protocol            = "NFSv4"
  availability_zone   = "S2"
  nfs_export_path     = "/exports/app"
  default_access_type = "ReadWrite"
  default_user_squash = "RootSquash"
}
```

For a more complete example, see [`examples/complete/main.tf`](https://github.com/Airtel-Cloud-Platform/terraform-provider-airtelcloudgcc/tree/main/examples/complete).

## Support and Contributing

For support, please refer to the [GitHub repository](https://github.com/Airtel-Cloud-Platform/terraform-provider-airtelcloudgcc) or open an issue.

Contributions are welcome! Please read the contributing guidelines before submitting pull requests.
