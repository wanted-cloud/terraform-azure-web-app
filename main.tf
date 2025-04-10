resource "azurerm_service_plan" "this" {
  count = var.create_service_plan ? 1 : 0

  name                       = var.name
  resource_group_name        = data.azurerm_resource_group.this.name
  location                   = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  os_type                    = var.os_type
  sku_name                   = var.sku_name
  app_service_environment_id = var.app_service_environment_id
  tags                       = local.metadata.tags

  timeouts {
    create = try(var.metadata.resource_timeouts["service_plan"].create, "30m")
    read   = try(var.metadata.resource_timeouts["service_plan"].read, "5m")
    update = try(var.metadata.resource_timeouts["service_plan"].update, "30m")
    delete = try(var.metadata.resource_timeouts["service_plan"].delete, "30m")
  }
}

resource "azurerm_app_service_certificate" "this" {
  for_each = { for certificate in var.service_certificates : certificate.name => certificate }

  name                = each.key
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  app_service_plan_id = var.service_plan_id != null ? var.service_plan_id : azurerm_service_plan.this["create"].id
  key_vault_secret_id = each.value.byoc ? null : each.value.key_vault_secret_id
  tags                = local.metadata.tags

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}

resource "azurerm_app_service_custom_hostname_binding" "this" {
  for_each = { for domain in var.custom_domains : domain.hostname => domain }

  hostname            = each.key
  app_service_name    = azurerm_windows_web_app.this[0].name
  resource_group_name = data.azurerm_resource_group.this.name

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    delete = var.timeouts.delete
  }

  lifecycle {
    ignore_changes = [
      ssl_state,
      thumbprint
    ]
  }
}

resource "random_password" "this" {
  for_each = { for certificate in var.service_certificates : certificate.name => certificate if certificate.password == null }

  length      = var.password_length
  min_lower   = var.password_min_lower
  min_numeric = var.password_min_numeric
  min_upper   = var.password_min_upper
}

resource "azurerm_app_service_certificate_binding" "this" {
  for_each = { for domain in var.custom_domains : domain.hostname => domain }

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.this[each.key].id
  certificate_id      = azurerm_app_service_certificate.this[each.value.certificate_name].id
  ssl_state           = each.value.ssl_state

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    delete = var.timeouts.delete
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  count = var.app_service_vnet_integration_subnet_id == null ? 0 : 1

  app_service_id = azurerm_windows_web_app.this[0].id
  subnet_id      = var.app_service_vnet_integration_subnet_id

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}
