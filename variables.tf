# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "The name of the IBM Cloud resource group where the cluster will be created/can be found."
}

# Cluster Variables
variable "cluster_name" {
  type        = string
  description = "The name of the cluster that will be created within the resource group"
}

# Cluster Variables
variable "cluster_hardware" {
  type        = string
  description = "The type of hardware for the cluster (shared, dedicated)"
  default     = "shared"
}

# Cluster Variables
variable "cluster_worker_count" {
  type        = number
  description = "The number of worker nodes that should be provisioned for classic infrastructure"
  default     = 3
}

variable "cluster_machine_type" {
  type        = string
  description = "(Deprecated, use VPC) The machine type that will be provisioned for classic infrastructure"
  default     = "b3c.4x16"
}

variable "flavor" {
  type        = string
  description = "The machine type that will be provisioned for VPC infrastructure"
  default     = "bx2.4x16"
}

variable "vlan_datacenter" {
  type        = string
  description = "(Deprecated, use VPC) The datacenter that should be used for classic infrastructure provisioning"
  default     = ""
}

variable "private_vlan_id" {
  type        = string
  description = "(Deprecated, use VPC) The private vlan id that should be used for classic infrastructure provisioning"
  default     = ""
}

variable "public_vlan_id" {
  type        = string
  description = "(Deprecated, use VPC) The public vlan id that should be used for classic infrastructure provisioning"
  default     = ""
}

# VPC Variables
variable "vpc_zone_count" {
  type        = number
  description = "Number of vpc zones"
  default     = 0
}

variable "cluster_region" {
  type        = string
  description = "The IBM Cloud region where the cluster will be/has been installed."
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster that should be created (openshift or ocp3 or ocp4 or kubernetes)"
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api token"
}

variable "cluster_exists" {
  type        = bool
  description = "Flag indicating if the cluster already exists (true or false)"
}

variable "login_user" {
  type        = string
  description = "The username to log in to openshift"
  default     = "apikey"
}

variable "name_prefix" {
  type        = string
  description = "The prefix name for the service. If not provided it will default to the resource group name"
  default     = ""
}

variable "is_vpc" {
  type        = bool
  description = "Flag indicating that the cluster uses vpc infrastructure"
  default     = false
}

variable "ocp_entitlement" {
  type        = string
  description = "Value that is applied to the entitlements for OCP cluster provisioning"
  default     = "cloud_pak"
}

variable "cos_name" {
  type        = string
  description = "(optional) The name of the cos instance that will be used for the OCP 4 vpc instance"
  default     = ""
}

variable "provision_cos" {
  type        = bool
  description = "Flag indicating that the cos instance should be provisioned, if necessary"
  default     = true
}

variable "gitops_dir" {
  type        = string
  description = "Directory where the gitops repo content should be written"
  default     = ""
}
