---
page_title: "airtelcloudgcc_dns_zone Resource - Airtel Cloud"
subcategory: "DNS"
description: |-
  Manages an Airtel Cloud DNS zone (DNSaaS).
---

# airtelcloudgcc_dns_zone (Resource)

Manages an Airtel Cloud DNS zone. DNS zones are the foundation for managing DNS records (see `airtelcloudgcc_dns_record`).

## Example Usage

### Forward zone

```terraform
resource "airtelcloudgcc_dns_zone" "example" {
  zone_name   = "example.com"
  zone_type   = "forward"
  description = "Primary DNS zone for example.com"
}
```

### Multiple zones

```terraform
resource "airtelcloudgcc_dns_zone" "internal" {
  zone_name   = "internal.example.com"
  zone_type   = "forward"
  description = "Internal services DNS zone"
}

resource "airtelcloudgcc_dns_zone" "public" {
  zone_name   = "public.example.com"
  description = "Public services DNS zone"
}
```

### Using the exported attributes

```terraform
output "zone_id" {
  value = airtelcloudgcc_dns_zone.example.id
}

output "zone_details" {
  value = {
    template   = airtelcloudgcc_dns_zone.example.dns_zone_template
    org_name   = airtelcloudgcc_dns_zone.example.org_name
    org_id     = airtelcloudgcc_dns_zone.example.org_id
    created_by = airtelcloudgcc_dns_zone.example.created_by
    created_at = airtelcloudgcc_dns_zone.example.created_at
    updated_at = airtelcloudgcc_dns_zone.example.updated_at
  }
}
```

## Argument Reference

### Required

- `zone_name` (String) - The name of the DNS zone (e.g., `example.com`). Forces new resource if changed.

### Optional

- `zone_type` (String) - The type of DNS zone. Valid values: `forward`, `reverse`. Default: `forward`. Forces new resource if changed.
- `description` (String) - A description for the DNS zone. Can be updated in place.

## Attribute Reference

In addition to all arguments above, the following attributes are exported:

- `id` (String) - The unique identifier (UUID) of the DNS zone.
- `dns_zone_template` (String) - The DNS zone template.
- `org_name` (String) - The organization name associated with the zone.
- `org_id` (String) - The organization ID associated with the zone.
- `created_by` (String) - The user who created the zone.
- `created_at` (Number) - The creation timestamp (Unix timestamp).
- `updated_at` (Number) - The last updated timestamp (Unix timestamp).

## Import

DNS zones can be imported using the zone `id` (UUID):

```shell
terraform import airtelcloudgcc_dns_zone.example <zone-id>
```
