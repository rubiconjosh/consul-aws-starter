This is a simple Terraform project to start an AWS environment with HashiCorp Consul installed and running.

# Usage

## Mandatory Variables

The following variables have no default nad must be declared in a terraform.tfvars file or via the CLI

- instance_key_name
- project_name
- ssh_cidr_allow

## Start Environment

```
terraform init
terraform apply
```
