# CircleCI-Server-Installation-GCP
This project is an automated implementation of [CircleCI Server Static Installation Scripts](https://circleci.com/docs/2.0/non-aws/) to your Google Cloud account.

Please consider the [limitations](https://circleci.com/docs/2.0/non-aws/#limitations) of the Static implementation of CircleCI Server prior to deploying and operating in production. 

Keep in mind that CircleCI only provides support for CircleCI Server deployed in non-AWS cloud providers for Platinum support customers only. Contact CircleCI support or your Customer Success Manager to get started.

## Prerequisites
1. Clone this repository
2. [Install Terraform](https://www.terraform.io/downloads.html). If you already have Terraform installed, please make sure that you are using version 0.12 or higher.
3. A VPC and public subnet with internet access available.
4. The JSON file of your service account key. You can create one by following [these instructions](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).
5. A CircleCI License file (.rli). Contact CircleCI support if you need a license.

## Installation
- Go to the root directory of this project.
- run `terraform init` to initiate terraform. This will install all terraform plugins and initiate terraform scripts.
- Run `cp terraform.tfvars.template terraform.tfvars`. Open `terraform.tfvars` and configure all of the required variables.

  | Variables | Description |
  | -------- | ----------- |
  | credentials | Either the path to or the contents of a service account key file in JSON format. |
  | project | The default GCP project to manage your CircleCI resources in. |
  | region | The default GCP region to manage your CircleCI resources in.  |
  | circleci_zone | The default GCP zone region for the CircleCI VM instances |
  | circleci_network_name | Name of the VPC network for hosting CircleCI |
  | subnet_name | The name of the subnet for deploying CircleCI VMs |

- Run `terraform apply` to install your CircleCI infrastructure.
- Your `nomad-client` VM will initially fail to install. You'll need modify the `/scripts/provision-nomad-client-ubuntu.sh` file and add the external IP address of your `circleci-services` VM to `NOMAD_SERVER_ADDRESS` environment variable.
- Run `terraform apply` again to complete your installation.
- Visit IP supplied at the end of the Terraform output
- Follow instructions to setup and configure your installation
- Once your installation has finished, you can use [our circleci-realitycheck-gcp repo](https://github.com/BoVice/circleci-realitycheck-gcp) to check basic CircleCI functionality.

## Teardown
> WARNING: This will permenantly destroy your entire CircleCI infrastructure. Please use with caution.

- Run `terraform destroy` to permanently destroy your CircleCI infrastructure.