data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "null_resource" "ibmcloud_login" {
  provisioner "local-exec" {
    command = "ibmcloud login -r ${var.cluster_region} -g ${var.resource_group_name} --apikey $${APIKEY} > /dev/null"

    environment = {
      REGION         = var.cluster_region
      RESOURCE_GROUP = var.resource_group_name
      APIKEY         = var.ibmcloud_api_key
    }
  }
}

locals {
  config_values = {
    kubernetes = {
      type      = "kubernetes"
      type_code = "kubernetes"
      version   = ""
    }
    iks        = {
      type      = "kubernetes"
      type_code = "kubernetes"
      version   = ""
    }
    openshift  = {
      type      = "openshift"
      type_code = "ocp3"
      version   = "3.1"
    }
    ocp3  = {
      type      = "openshift"
      type_code = "ocp3"
      version   = "3.1"
    }
    ocp43  = {
      type      = "openshift"
      type_code = "ocp4"
      version   = "4.3"
    }
    ocp44  = {
      type      = "openshift"
      type_code = "ocp4"
      version   = "4.4"
    }
    ocp45  = {
      type      = "openshift"
      type_code = "ocp4"
      version   = "4.5"
    }
    ocp46  = {
      type      = "openshift"
      type_code = "ocp4"
      version   = "4.6"
    }
  }
  cluster_config_dir    = "${path.cwd}/.kube"
  cluster_config        = "${local.cluster_config_dir}/config"
  cluster_type_file     = "${path.cwd}/.tmp/cluster_type.val"
  name_prefix           = var.name_prefix != "" ? var.name_prefix : var.resource_group_name
  name_list             = [local.name_prefix, "cluster"]
  cluster_name          = var.cluster_name != "" ? var.cluster_name : join("-", local.name_list)
  tmp_dir               = "${path.cwd}/.tmp"
  config_namespace      = "default"
  server_url            = var.is_vpc ? length(data.ibm_container_vpc_cluster.config) > 0 ? data.ibm_container_vpc_cluster.config[0].public_service_endpoint_url : "" : length(data.ibm_container_cluster.config) > 0 ? data.ibm_container_cluster.config[0].public_service_endpoint_url : ""
  ingress_hostname      = var.is_vpc ? length(data.ibm_container_vpc_cluster.config) > 0 ? data.ibm_container_vpc_cluster.config[0].ingress_hostname : "" : length(data.ibm_container_cluster.config) > 0 ? data.ibm_container_cluster.config[0].ingress_hostname : ""
  tls_secret            = var.is_vpc ? length(data.ibm_container_vpc_cluster.config) > 0 ? data.ibm_container_vpc_cluster.config[0].ingress_secret : "" : length(data.ibm_container_cluster.config) > 0 ? data.ibm_container_cluster.config[0].ingress_secret : ""
  openshift_versions    = {
  for version in data.ibm_container_cluster_versions.cluster_versions.valid_openshift_versions:
  substr(version, 0, 3) => "${version}_openshift"
  }
  cluster_regex         = "(${join("|", keys(local.config_values))}|ocp4).*"
  cluster_type_cleaned  = regex(local.cluster_regex, var.cluster_type)[0] == "ocp4" ? "ocp46" : regex(local.cluster_regex, var.cluster_type)[0]
  cluster_type          = local.config_values[local.cluster_type_cleaned].type
  # value should be ocp4, ocp3, or kubernetes
  cluster_type_code     = local.config_values[local.cluster_type_cleaned].type_code
  cluster_type_tag      = local.cluster_type == "kubernetes" ? "iks" : "ocp"
  cluster_version       = local.cluster_type == "openshift" ? local.openshift_versions[local.config_values[local.cluster_type_cleaned].version] : ""
  ibmcloud_release_name = "ibmcloud-config"
}

resource "null_resource" "create_dirs" {
  provisioner "local-exec" {
    command = "echo 'regex: ${local.cluster_regex}'"
  }
  provisioner "local-exec" {
    command = "echo 'cluster_type_cleaned: ${local.cluster_type_cleaned}'"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${local.tmp_dir}"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${local.cluster_config_dir}"
  }
}

data "ibm_container_cluster_versions" "cluster_versions" {
  depends_on = [null_resource.create_dirs]

  resource_group_id = data.ibm_resource_group.resource_group.id
}
