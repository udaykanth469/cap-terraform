module "aks-cluster" {
    source = "./cluster"

    location            = var.location
    resource_group      = var.resource_group
    dns_prefix          = var.dns_prefix
    k8s_version         = var.k8s_version
    cluster_labels      = var.cluster_labels


    ssh_username = var.ssh_username
    ssh_public_key = var.ssh_public_key

    instance_count      = var.instance_count
    instance_type       = var.instance_type
    disk_size_gb     = var.disk_size_gb

    client_id     = var.client_id
    client_secret = var.client_secret
    tenant_id     = var.tenant_id
    subscription_id = var.subscription_id
    dns_zone_name = var.dns_zone_name
    
    
    email         = var.email
    admin_password = var.admin_password
    dns_zone_resource_group = var.dns_zone_resource_group

}

resource "local_file" "k8scfg" {
  content  = module.aks-cluster.kube_config
  filename = "${path.cwd}/kubeconfig"
}

provider "helm" {
  version = "1.2.0"
  alias   = "helm-cap"

  kubernetes {
    config_path = "${path.cwd}/kubeconfig"
  }
}

module "helper-charts" {
    source = "../common/helper-charts"

    providers = {
        helm = helm.helm-cap
    }

    client_id     = var.client_id
    client_secret = var.client_secret
    tenant_id     = var.tenant_id
    subscription_id = var.subscription_id
    dns_zone_name = var.dns_zone_name

    email         = var.email
    dns_zone_resource_group = var.dns_zone_resource_group

    depends_on = [module.aks-cluster]
}

module "cap-charts" {
    source = "../common/cap-charts"

    providers = {
        helm = helm.helm-cap
    }

    cap_domain = var.cap_domain
    cap_version = var.cap_version
    cluster_url = module.aks-cluster.cluster_url

    depends_on = [module.aks-cluster,
                  module.helper-charts]
}

