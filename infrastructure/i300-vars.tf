variable "image_version" {
  type    = string
  default = "c2cab33608f927f496ef944ac3e1509547e62f7e"
}

variable "repository_name" {
  type    = string
  default = "lawandorga-synapse-service"
}

variable "certificate_name" {
  type    = string
  default = "lawandorga-synapse-service-certificate"
}

variable "env_vars" {
  type      = map(string)
  sensitive = true
}

variable "signal_db_password" {
  type      = string
  sensitive = true
}

variable "signal_as_token" {
  type      = string
  sensitive = true
}

variable "signal_hs_token" {
  type      = string
  sensitive = true
}

variable "signal_pickle_key" {
  type      = string
  sensitive = true
}
