Release v3.0
============
* Upgrade module to Terraform 0.13+
  * Compatible with TF 0.14 and 0.15
* Add tests to validate a basic load balancer creation in Azure

Release v2.0
============

* Upgrade module to terraform 0.12
* Use terraform-docs Generator
  * Use `make docs` to update Terraform module documentation
* Fix provider trying to use AzureCLI
* Remove azurerm version constraints (can break some downstream terraform runs)
