# Azure load balancer module
data "azurerm_resource_group" "group" {
  name = var.resource_group_name
}

locals {
  location            = var.location != "" ? var.location : data.azurerm_resource_group.group.location
  resource_group_name = data.azurerm_resource_group.group.name
  type                = lower(var.type)
  allocation_method   = var.private_ip_address != "" ? "Static" : "Dynamic"
  tags                = merge(data.azurerm_resource_group.group.tags, var.tags)
}

resource "azurerm_public_ip" "ip" {
  count               = local.type == "public" ? 1 : 0
  name                = "${var.prefix}-publicIP"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = local.allocation_method
  tags                = local.tags
}

resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-lb"
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  frontend_ip_configuration {
    name                          = var.frontend_name
    public_ip_address_id          = local.type == "public" ? azurerm_public_ip.ip[0].id : ""
    subnet_id                     = var.subnet_id
    private_ip_address            = var.private_ip_address
    private_ip_address_allocation = local.allocation_method
  }
}

resource "azurerm_lb_backend_address_pool" "azlb" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "azlb" {
  count               = length(var.remote_port)
  resource_group_name = local.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "VM-${count.index}"

  protocol      = "tcp"
  frontend_port = 50000 + count.index + 1
  backend_port  = element(var.remote_port[element(keys(var.remote_port), count.index)], 1)

  frontend_ip_configuration_name = var.frontend_name
}

resource "azurerm_lb_probe" "azlb" {
  count               = length(var.lb_port)
  resource_group_name = local.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id

  name     = element(keys(var.lb_port), count.index)
  protocol = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
  port     = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)

  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
}

resource "azurerm_lb_rule" "azlb" {
  count               = length(var.lb_port)
  resource_group_name = local.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id

  name          = element(keys(var.lb_port), count.index)
  protocol      = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
  frontend_port = element(var.lb_port[element(keys(var.lb_port), count.index)], 0)
  backend_port  = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)

  frontend_ip_configuration_name = var.frontend_name
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.azlb.id

  idle_timeout_in_minutes = 5
  probe_id                = element(azurerm_lb_probe.azlb.*.id, count.index)
  depends_on              = [azurerm_lb_probe.azlb]
}

