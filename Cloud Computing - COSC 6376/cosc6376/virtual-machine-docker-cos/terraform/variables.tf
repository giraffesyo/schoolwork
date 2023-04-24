variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type        = string
  description = "The GCP zone to deploy instances into"
  default     = "us-central1-c"
}
variable "project_id" {
  type    = string
  default = "cosc-6376-383820"
}

variable "instance_name" {
  description = "The desired name to assign to the deployed instance"
  default     = "nodejs-app-cos"
}

variable "container_image" {
  description = "The container image to deploy"
  default     = "giraffesyo/cosc6376:latest"
}
