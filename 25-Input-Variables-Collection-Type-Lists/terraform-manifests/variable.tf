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
  default     = "vnet1"
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "vnet address space"
  default     = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}