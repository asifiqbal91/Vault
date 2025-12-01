# Vault

[![License MIT](https://img.shields.io/badge/License-MIT-blue)](https://choosealicense.com/licenses/mit)

Vault is a self-hosted way to keep passwords under your control. Deploy it to your own infrastructure so your data stays private and under your lock and key.

## What you get

- Self-hosted password storage with configurable networking and hostname
- Terraform-first deployment so you can spin up or tear down environments quickly
- Sensible defaults via example variables to get running locally fast

## Prerequisites

- Terraform installed locally
- Access to the target infrastructure (networks, DNS, and database reachable from where Terraform runs)

## Quick start

1) Copy example variables:
   ```bash
   cp infra/environments/local/terraform.tfvars.example infra/environments/local/terraform.tfvars
   ```
2) Set required values in `infra/environments/local/terraform.tfvars`:
   - `vault_admin_token`
   - `vault_database_url`
   - `vault_hostname`
   - network names if they differ: `public_network_name`, `kitchen_network_name`
3) Deploy the local environment:
   ```bash
   cd infra/environments/local
   terraform init
   terraform apply
   ```

## Repo layout

- `infra/` — Terraform modules and per-environment configs for the Vault service

## Operations

- Upgrade or destroy: rerun `terraform apply` or `terraform destroy` from `infra/environments/<env>`.
- Config changes: edit the `terraform.tfvars` for your environment, then apply.

## Report An Issue

Encountered a problem or unexpected behavior? Please open an issue and follow the steps in our [Quick Guide to Reporting Issues](REPORTING.md)

## Contributing

We’re excited to have you! Check out our [Contribution Guide](CONTRIBUTING.md) to learn how to make pull requests, and more ways to help shape this project.

## Support Us

Love this project? Show your support by spreading the word, sharing on social media, and helping fellow users. You can also consider [donating](https://asifiqbal.rocks/donation) to fund development and open-source initiatives.

## License

This is released under the [MIT](https://choosealicense.com/licenses/mit) license.
