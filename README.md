Azure Load Balancer Terraform Module
==========

A terraform module to provide load balancers in Azure.

Usage
-----

### Public loadbalancer example:

```hcl
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = "westus"

  tags = {
    environment = "nonprod"
    costcenter  = "12345"
    ppm         = "N/A"
    fgid        = "1234"
    appname     = "myapp"
  }
}

module "public-lb" {
  source              = "git::ssh://git@github.com/terraform-modules/azure_load_balancer"
  type                = "Public"
  resource_group_name = azurerm_resource_group.main.name
  prefix              = "terraform-test"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http = ["443", "Tcp", "443"]
  }

  depends_on = {
    azurerm_resource_group.main
  }
}
```

### Private Load Balancer Example:

```hcl
resource "azurerm_resource_group" "group" {
  name     = var.resource_group_name
  location = "westus"

  tags = {
    environment = "nonprod"
    costcenter  = "12345"
    ppm         = "N/A"
    fgid        = "1234"
    appname     = "myapp"
  }
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

module "private-lb" {
  source              = "highwayoflife/terraform-azurerm-load-balancer"
  type                = "private"
  prefix              = "MyTerraformLB"
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  # Define a static IP, if empty or not defined, IP will be dynamic
  private_ip_address = "10.0.1.6"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    https = ["443", "Tcp", "443"]
  }

  depends_on = {
    azurerm_resource_group.group
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_nat_rule.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_rule) | resource |
| [azurerm_lb_probe.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_public_ip.ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Required) Default prefix to use with your resource names. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the existing resource group where the load balancer resources will be placed. | `string` | n/a | yes |
| <a name="input_frontend_name"></a> [frontend\_name](#input\_frontend\_name) | (Optional) Specifies the name of the frontend ip configuration. | `string` | `"FrontendIP"` | no |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port) | Protocols to be used for lb health probes and rules. [frontend\_port, protocol, backend\_port] | `map(list(string))` | `{}` | no |
| <a name="input_lb_probe_interval"></a> [lb\_probe\_interval](#input\_lb\_probe\_interval) | Interval in seconds the load balancer health probe rule does a check | `number` | `5` | no |
| <a name="input_lb_probe_unhealthy_threshold"></a> [lb\_probe\_unhealthy\_threshold](#input\_lb\_probe\_unhealthy\_threshold) | (Optional) Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy. Default = 2. | `number` | `2` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location/region where the load balancer will be created. If not provided, will use the location of the resource group. | `string` | `""` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | (Optional) Private ip address to assign to frontend. Use it with type = private | `string` | `""` | no |
| <a name="input_remote_port"></a> [remote\_port](#input\_remote\_port) | Protocols to be used for remote vm access. [protocol, backend\_port].  Frontend port will be automatically generated starting at 50000 and in the output. | `map(list(string))` | `{}` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Optional) Frontend subnet id to use when in private mode | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (optional) Tags to use in addition to tags assigned to the resource group. | `map(string)` | <pre>{<br>  "source": "terraform"<br>}</pre> | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) Defined if the loadbalancer is private or public. Default private. | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_backend_address_pool_id"></a> [lb\_backend\_address\_pool\_id](#output\_lb\_backend\_address\_pool\_id) | The id for the azurerm\_lb\_backend\_address\_pool resource |
| <a name="output_lb_frontend_ip_configuration"></a> [lb\_frontend\_ip\_configuration](#output\_lb\_frontend\_ip\_configuration) | The frontend\_ip\_configuration for the azurerm\_lb resource |
| <a name="output_lb_id"></a> [lb\_id](#output\_lb\_id) | The id for the azurerm\_lb resource |
| <a name="output_lb_nat_rule_ids"></a> [lb\_nat\_rule\_ids](#output\_lb\_nat\_rule\_ids) | The ids for the azurerm\_lb\_nat\_rule resources |
| <a name="output_lb_private_ip_address"></a> [lb\_private\_ip\_address](#output\_lb\_private\_ip\_address) | The first private IP address assigned to the load balancer in frontend\_ip\_configuration blocks, if any. |
| <a name="output_lb_probe_ids"></a> [lb\_probe\_ids](#output\_lb\_probe\_ids) | The ids for the azurerm\_lb\_probe resources |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The ip address for the azurerm\_lb\_public\_ip resource |
| <a name="output_public_ip_id"></a> [public\_ip\_id](#output\_public\_ip\_id) | The id for the azurerm\_lb\_public\_ip resource |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Contributors
-----

* [David Lewis](https://github.com/highwayolife)
* Originally based on [terraform-azurerm-loadbalancer](https://github.com/Azure/terraform-azurerm-loadbalancer) by [David Tesar](https://github.com/dtzar) 

License
------

[MIT](LICENSE)

