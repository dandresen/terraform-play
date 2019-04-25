variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "us-east-2"
}

variable "key_name" {
  description = "Name of existing key pair to SSH into instances."
}
