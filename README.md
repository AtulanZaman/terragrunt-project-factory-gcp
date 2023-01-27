# A 'state-scalable' project factory pattern with Terragrunt

## Overview
Resolves the problem of state volume explotion with project factory. Terragrunt helps with that by:
1. Providing a dynamic way to configure [remote_state](https://terragrunt.gruntwork.io/docs/features/keep-your-remote-state-configuration-dry/#keep-your-remote-state-configuration-dry) for categories of resources in directories.
1. Providing DRY configuration of source code by generating code in target directories using dynamic [source](https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/#motivation) definitions.
1. Drastically reduce time to perform `terraform plan` or `terraform apply` by supporting [parallel](https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/) execution of resource plans.

This pattern scales the 'factory' oriented approach of IaC implementation, facilitating both scalability of the Terraform state file size and also develper productivity by minimizing time to run *plans*. By providing mechanisms to create resource group definitions using both local and common data configurations through `defaults`, and implementing `DRY` code in a central `source`, it encourages a mature `Infrastructure as Data` implementation practice. 

## Requirements
1. Folders where projects will be created already exists.
1. Project where remote state files will be stored already exists.
1. Service Accounts required for executing deployment already exists.
1. The account running the deployment has the required permissions for the google public [project-factory](https://github.com/terraform-google-modules/terraform-google-project-factory) module.
1. The account has permissions to create buckets and objects in the GCP project storing the state files

## How to run
1. [Install Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
1. Create folders for categories similar to `team1`, `team2` given as sample.
1. Create project files in data \<category\>  projects similar to `*.yaml.sample` files provided to project specific configurations.
1. Create defaults.yaml file for each category similar to `defaults.yaml.sample` file provided for common configurations.
1. Create root.yaml file similar to `root.yaml.sample` for remote backend configurations.

```
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

## Variations
## Resources
* [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started)
* [*Infrastructure as Data*](https://medium.com/dzerolabs/shifting-from-infrastructure-as-code-to-infrastructure-as-data-bdb1ae1840e3) Medium link
* [Splitting a monolithic Terraform state using Terragrunt](https://medium.com/cts-technologies/murdering-monoliths-using-terragrunt-to-split-monolithic-terraform-state-up-into-multiple-stacks-17ead2d8e0e9)

# Caveats
* Terragrunt has [restrictions](https://docs.gruntwork.io/guides/working-with-code/tfc-integration) when it comes to integrating with Hashicorp's Terraform Cloud or Terraform Cloud Enterprise platform. TL;DR: You can still use TCE/TC for storing states, monitoring and auditing but cannot use the UI for Terraform runs. Initiating runs using the CLI is still possible.
