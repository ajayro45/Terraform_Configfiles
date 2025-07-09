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
  default     = "eastus"
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

variable "publicip" {
  type        = string
  description = "piblicip name"
  default     = "newpublicip"
}

variable "publicipsku" {
  type        = map(string)
  description = "sku details"
  default = {
    "eastus"  = "Basic"
    "eastus2" = "Standard"
  }
}

variable "publicallocationmethod" {
  type = map(string)
  description = "public allocation method"
  default = {
    "eastus" = "Dynamic"
    "eastus2"= "Static"
  }
}