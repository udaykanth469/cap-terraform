variable "generated-cluster-name" {
  type    = "string"
} 

variable "vpc-id" {
    type = "string"
}

variable "app_subnet_ids" {
    type = list(string)
}

variable "workstation_cidr_block" {
    type = "string"
}

variable "keypair_name" {
    type = "string"
}

variable "eks_version" {
    type = "string"
}

variable "cluster_labels" {
    type = "map"
}

variable "aws-ig-dependency-id" {
    type = "string"
}

