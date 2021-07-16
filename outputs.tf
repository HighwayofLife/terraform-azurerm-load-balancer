output "lb_id" {
  description = "The id for the azurerm_lb resource"
  value       = azurerm_lb.lb.id
}

output "lb_frontend_ip_configuration" {
  description = "The frontend_ip_configuration for the azurerm_lb resource"
  value       = azurerm_lb.lb.frontend_ip_configuration
}

output "lb_probe_ids" {
  description = "The ids for the azurerm_lb_probe resources"
  value       = azurerm_lb_probe.azlb.*.id
}

output "lb_nat_rule_ids" {
  description = "The ids for the azurerm_lb_nat_rule resources"
  value       = azurerm_lb_nat_rule.azlb.*.id
}

output "public_ip_id" {
  description = "The id for the azurerm_lb_public_ip resource"
  value       = azurerm_public_ip.ip.*.id
}

output "public_ip_address" {
  description = "The ip address for the azurerm_lb_public_ip resource"
  value       = azurerm_public_ip.ip.*.ip_address
}

output "lb_backend_address_pool_id" {
  description = "The id for the azurerm_lb_backend_address_pool resource"
  value       = azurerm_lb_backend_address_pool.azlb.id
}

output "lb_private_ip_address" {
  description = "The first private IP address assigned to the load balancer in frontend_ip_configuration blocks, if any."
  value       = azurerm_lb.lb.private_ip_address
}

