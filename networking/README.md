# Networking Sub-Modules

This directory contains standalone Terraform modules for managing AWS VPC infrastructure. These modules are designed to be applied independently to allow for granular control over network components.

## 📂 Module Catalog

| Module | Description | Dependencies |
| :--- | :--- | :--- |
| `vpc` | Core VPC infrastructure | None |
| `subnets` | Public, Private-App, and Private-DB tiers | `vpc_id` |
| `internet_gateway` | VPC Internet Gateway | `vpc_id` |
| `eip` | Elastic IPs for NAT Gateways | None |
| `nat_gateway` | NAT Gateways for private outbound traffic | `eip_allocation_ids`, `public_subnet_ids` |
| `route_table` | Routing logic and subnet associations | `vpc_id`, `subnet_ids`, `igw_id`, `nat_gw_ids` |
| `vpn` | Client VPN Endpoint (Optional) | `vpc_id`, `subnet_ids` |

## 🚀 How to Use as Modules

These modules are designed to be consumed by provisioning repositories (e.g., `iac-provisioning`). To maintain stability, always reference them using Git tags and specific sub-paths.

### Dependency Chain

When using these modules in a root configuration, chain them together using outputs:

```hcl
# 1. Base VPC
module "vpc" {
  source  = "git::https://gitlab.com/your-org/iac-modules.git//networking/vpc?ref=v1.0.0"
  project = "bitmatrix"
  env     = "nonprod"
  # ... other inputs
}

# 2. Subnets
module "subnets" {
  source = "git::https://gitlab.com/your-org/iac-modules.git//networking/subnets?ref=v1.0.0"
  vpc_id = module.vpc.vpc_id
  # ... other inputs
}

# 3. Routing (Requires outputs from VPC, Subnets, IGW, and NAT GWs)
module "route_table" {
  source              = "git::https://gitlab.com/your-org/iac-modules.git//networking/route_table?ref=v1.0.0"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.subnets.public_subnet_ids
  internet_gateway_id = module.igw.internet_gateway_id
  nat_gateway_ids     = module.nat.nat_gateway_ids
  # ...
}
```

---

## 🛠 Provisioning Sequence

If you are applying these modules in separate state files (recommended for large environments), follow this order to ensure dependencies are met:

1.  **`networking/vpc`**: Creates the VPC ID.
2.  **`networking/subnets`**: Uses `vpc_id`.
3.  **`networking/internet_gateway`**: Uses `vpc_id`.
4.  **`networking/eip`**: Reserves IPs for NAT.
5.  **`networking/nat_gateway`**: Uses `eip_allocation_ids` and `public_subnet_ids`.
6.  **`networking/route_table`**: The "Connector" - uses IDs from all above.
7.  **`networking/vpn`**: (Optional) Administrative access.

---

## 🏗 Composition Guidelines

- **Remote State**: If applying separately, use `terraform_remote_state` or `data` sources (tags/filters) to fetch IDs between stages.
- **Versioning**: Never point to the `main` branch. Always use a semantic version tag (e.g., `?ref=v1.2.0`).
- **Standard Tags**: Every module automatically applies `Project`, `Environment`, `ManagedBy`, and `ModuleSource` tags.
