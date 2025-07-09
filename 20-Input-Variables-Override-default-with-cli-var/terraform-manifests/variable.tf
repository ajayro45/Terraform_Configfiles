variable "business_unit" {
  type        = string
  description = "business unit"
  default     = "hr"
}

variable "environment" {
  type        = string
  description = "project environment"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "rg name"
  default     = "myrg1"
}

variable "location_name" {
  type        = string
  description = "location name"
  default     = "East US"
}

variable "virtual_network" {
  type        = string
  description = "vnet name"
  default     = "myvnet1"
}