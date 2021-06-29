provider "ibm" {
  region           = var.cluster_region
  ibmcloud_api_key = var.ibmcloud_api_key
}

provider "helm" {
  kubernetes {
    config_path = local.cluster_config
  }
}
