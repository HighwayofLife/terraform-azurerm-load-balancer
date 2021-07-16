resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "test-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "private-lb" {
  source              = "../"
  type                = "Private"
  resource_group_name = azurerm_resource_group.main.name
  prefix              = "terraform-test"
  subnet_id           = azurerm_subnet.subnet.id

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http = ["443", "Tcp", "443"]
  }

  depends_on = [
    azurerm_resource_group.main
  ]
}

output "private-lb-id" {
  description = "Private Load Balancer ID"
  value       = module.private-lb.lb_id
}
