### VPC ###

variable "credentials" {
  description = "Either the path to or the contents of a service account key file in JSON format."
  default     = ""
}

variable "project" {
  description = "The default project to manage resources in."
  default     = ""
}

variable "region" {
  description = "The default region to manage resources in."
  default     = ""
}

variable "circleci_network_name" {
  description = "Name of the VPC network for hosting CircleCI Server"
  default     = ""
}

variable "subnet_name" {
  description = "The name of the subnet for deploying CircleCI Server VMs"
  default     = ""
}



### VM Instances ###

variable "services_machine_type" {
  description = "The machine type of your services VM instance"
  default     = "n2-standard-8"
}

variable "nomad_client_machine_type" {
  description = "The machine type of your nomad-client VM instance"
  default     = "n2-standard-8"
}

variable "default_image" {
  description = "The default OS image used for CircleCI VM instances"
  default     = "ubuntu-os-cloud/ubuntu-1604-lts"
}

variable "circleci_zone" {
  description = "The default zone region for the CircleCI VM instances"
  default     = ""
}
