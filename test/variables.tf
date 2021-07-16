variable "client_id" {
  description = "SPN Client ID"
  type        = string
}

variable "client_secret" {
  description = "SPN Client Secret"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "Subscription to create resources"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the VNet"
  type        = string
}

variable "vnet_resource_group_name" {
  description = "Resource group name for the VNet"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to use for the test (will be created)"
  type        = string
  default     = "terraform-test"
}

variable "location" {
  description = "Location for the resources"
  default     = "westus"
  type        = string
}
