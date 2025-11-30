# Vault

[![License MIT](https://img.shields.io/badge/License-MIT-blue)](https://choosealicense.com/licenses/mit)

Take control of your passwords. Store them securely on your own server, keeping your data private and under your lock.

## Quick start

- Copy an example vars file:
  `cp infra/environments/local/terraform.tfvars.example infra/environments/local/terraform.tfvars`
- Fill in Vault settings: `vault_admin_token`, `vault_database_url`, `vault_hostname`, and network names if they differ (`public_network_name`, `kitchen_network_name`).
- Deploy: `cd infra/environments/local && terraform init && terraform apply`

## Repo layout

- `infra/` – Terraform modules and env configs for the Vault service

## Report An Issue

Encountered a problem or unexpected behavior? Please open an issue and follow the steps in our [Quick Guide to Reporting Issues](REPORTING.md)

## Contributing

We’re excited to have you! Check out our [Contribution Guide](CONTRIBUTING.md) to learn how to make pull requests, and more ways to help shape this project.

## Support Us

Love this project? Show your support by spreading the word, sharing on social media, and helping fellow users. You can also consider [donating](https://asifiqbal.rocks/donation) to fund development and open-source initiatives.

## License

This is released under the [MIT](https://choosealicense.com/licenses/mit) license.
