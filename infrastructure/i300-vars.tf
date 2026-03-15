variable "image_version" {
  type    = string
  default = "4ff99be0e015ddbb2a44044a7b6c70650064b0ea"
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
