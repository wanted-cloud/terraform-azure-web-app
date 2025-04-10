provider "azurerm" {
  features         {}
  subscription_id = "example-subscription-id"
}

data "azurerm_resource_group" "this" {
  name = "example-rg"
}

resource "azurerm_service_plan" "example" {
  name                = "example-appserviceplan"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  os_type             = "Windows"
  sku_name            = "P1v2"

  tags = {
    environment = "dev"
  }
}

module "windows_web_app" {
  source                = "../.."
  name                  = "example-webapp"
  location              = data.azurerm_resource_group.this.location
  resource_group_name   = data.azurerm_resource_group.this.name
  os_type               = "Windows"
  sku_name              = "P1v2"
  create_service_plan = false
    service_plan_id     = azurerm_service_plan.example.id

  app_settings = {}

  site_config = {
    always_on                         = true
    ftps_state                        = "Disabled"
    http2_enabled                     = true
    websockets_enabled                = true
    worker_count                      = 1
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 5
    remote_debugging_enabled          = false
    remote_debugging_version          = "VS2022"
    scm_use_main_ip_restriction       = false
    application_stack = {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  client_affinity_enabled                        = false
  client_certificate_enabled                     = false
  client_certificate_mode                        = "Optional"
  enabled                                        = true
  ftp_publish_basic_authentication_enabled       = false
  https_only                                     = true
  public_network_access_enabled                  = true
  webdeploy_publish_basic_authentication_enabled = false
  zip_deploy_file                                = null

  metadata = {
    tags = {
      environment = "dev"
      module      = "windows_web_app"
    }
    resource_timeouts = {}
  }

  timeouts = {
    create = "30m"
    read   = "5m"
    update = "30m"
    delete = "30m"
  }
}
