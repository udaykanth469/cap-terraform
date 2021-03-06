resource "random_string" "cluster_name" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "cap-${random_string.cluster_name.result}"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.k8s_version

  linux_profile {
    admin_username = var.ssh_username

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  default_node_pool {
    name            = "defaultpool"
    node_count      = var.instance_count
    vm_size         = var.instance_type
    os_disk_size_gb = var.disk_size_gb
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = var.cluster_labels
}

locals {
  k8scfg = azurerm_kubernetes_cluster.k8s.kube_config_raw
  kubeconfig_file_path = "${path.module}/kubeconfig"
}

output "kube_config" {
  value = local.k8scfg
}

resource "local_file" "k8scfg" {
  content  = local.k8scfg
  filename = local.kubeconfig_file_path
}

