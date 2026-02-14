terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.63"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
  }
  backend "s3" {
    bucket                      = "lawandorga-main-infrastructure"
    key                         = "lawandorga-synapse-service.tfstate"
    region                      = "fr-par"

    endpoints = {
      s3 = "https://s3.fr-par.scw.cloud"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true

    profile = "lawandorga"
  }
  required_version = ">= 1.0.0"
}
