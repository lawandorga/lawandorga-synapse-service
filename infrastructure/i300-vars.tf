variable "image_version" {
  type    = string
  default = "e62639d9259512090cb99aaac3749db028adc943"
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
