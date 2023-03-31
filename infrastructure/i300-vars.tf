variable "image_version" {
  type = string
}

variable "repository_name" {
  type = string
  default = "lawandorga-synapse-service"
}

variable "certificate_name" {
  type = string
  default = "lawandorga-synapse-service-certificate"
}

variable "env_vars" {
  type = map(string)
  sensitive = true
}
