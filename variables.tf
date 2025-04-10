// Place for module variables configuration

variable "create_service_plan" {
  type    = bool
  default = true
}

variable "location" {
  description = "The Azure Region where the Windows Web App should exist. Changing this forces a new Windows Web App to be created."
  type        = string
  default     = "North Europe"


  validation {
    error_message = local.metadata.validator_error_messages.location
    condition     = can(regex(local.metadata.validator_expressions.location, var.location))
  }

}

variable "name" {
  description = " The name which should be used for this Windows Web App. Changing this forces a new Windows Web App to be created."
  type        = string

}

variable "resource_group_name" {
  description = "The name of the Resource Group where the Windows Web App should exist. Changing this forces a new Windows Web App to be created."
  type        = string

}

variable "os_type" {
  type        = string
  description = "The O/S type for the App Services to be hosted in this plan."
  default     = "Windows"

  validation {
    error_message = local.metadata.validator_error_messages.os_type
    condition = can(
      regex(
        local.metadata.validator_expressions.os_type,
        var.os_type
      )
    )
  }

}

variable "sku_name" {

  description = "Sku name of the Windows Web App"
  type        = string

  validation {
    error_message = local.metadata.validator_error_messages.sku_name
    condition = can(
      regex(
        local.metadata.validator_expressions.sku_name,
        var.sku_name
      )
    )
  }

}

variable "app_service_environment_id" {
  type        = string
  description = "The ID of the App Service Environment to create this Service Plan in."
  default     = null
}



variable "service_plan_id" {
  description = "The ID of the Service Plan that this Windows App Service will be created in."
  type        = string
}

variable "site_config" {
  type = object({
    always_on                                     = optional(bool, true)
    api_definition_url                            = optional(string)
    api_management_api_id                         = optional(string)
    app_command_line                              = optional(string)
    container_registry_managed_identity_client_id = optional(string)
    container_registry_use_managed_identity       = optional(bool)
    default_documents                             = optional(list(string))
    ftps_state                                    = optional(string, "Disabled")
    health_check_path                             = optional(string)
    health_check_eviction_time_in_min             = optional(number)
    http2_enabled                                 = optional(bool)
    load_balancing_mode                           = optional(string, "LeastRequests")
    local_mysql_enabled                           = optional(bool, false)
    managed_pipeline_mode                         = optional(string, "Integrated")
    minimum_tls_version                           = optional(string, "1.2")
    remote_debugging_enabled                      = optional(bool, false)
    remote_debugging_version                      = optional(string)
    scm_minimum_tls_version                       = optional(string, "1.2")
    scm_use_main_ip_restriction                   = optional(bool)
    use_32_bit_worker                             = optional(bool, true)
    vnet_route_all_enabled                        = optional(bool, false)
    websockets_enabled                            = optional(bool, false)
    worker_count                                  = optional(number)
    application_stack = optional(object({
      docker_image_name            = optional(string)
      docker_registry_url          = optional(string)
      docker_registry_username     = optional(string)
      docker_registry_password     = optional(string)
      dotnet_version               = optional(string)
      go_version                   = optional(string)
      java_server                  = optional(string)
      java_server_version          = optional(string)
      java_version                 = optional(string)
      node_version                 = optional(string)
      php_version                  = optional(string)
      python_version               = optional(string)
      ruby_version                 = optional(string)
      current_stack                = optional(string) # Windows
      docker_container_name        = optional(string) # Windows
      docker_container_tag         = optional(string) # Windows
      dotnet_core_version          = optional(string) # Windows
      tomcat_version               = optional(string) # Windows
      java_embedded_server_enabled = optional(bool)   # Windows
      python                       = optional(bool)   # Windows
    }))
    auto_heal_setting = optional(object({
      action = optional(object({
        action_type                    = string
        minimum_process_execution_time = optional(string)
      }))
      trigger = optional(object({
        private_memory_kb = optional(number) # Windows
        requests = optional(object({
          count    = number
          interval = string
        }))
        slow_request = optional(list(object({
          count      = number
          interval   = string
          time_taken = string
          path       = optional(string)
        })))
        status_code = optional(list(object({
          count             = number
          interval          = string
          status_code_range = string
          path              = optional(string)
          sub_status        = optional(number)
          win32_status_code = optional(number)
        })))
      }))
    }))
    cors = optional(object({
      allowed_origins     = list(string)
      support_credentials = optional(bool, false)
    }))
    ip_restriction = optional(list(object({
      action = optional(string, "Allow")
      headers = optional(object({
        x_azure_fdid      = optional(string)
        x_fd_health_probe = optional(number)
        x_forwarded_for   = optional(list(string))
        x_forwarded_host  = optional(list(string))
      }))
      ip_address                = optional(string)
      name                      = optional(string)
      priority                  = optional(number, 65000)
      service_tag               = optional(string)
      virtual_network_subnet_id = optional(string)
    })))
    scm_ip_restriction = optional(list(object({
      action = optional(string)
      headers = optional(object({
        x_azure_fdid      = optional(list(string))
        x_fd_health_probe = optional(list(string))
        x_forwarded_for   = optional(list(string))
        x_forwarded_host  = optional(list(string))
      }))
      ip_address                = optional(string)
      name                      = optional(string)
      priority                  = optional(number, 65000)
      service_tag               = optional(string)
      virtual_network_subnet_id = optional(string)
    })))
  })
  description = <<EOT
  Site Configuration for App Service

  always_on                                     = If this Web App is Always On enabled. Defaults to true.
  api_definition_url                            = The URL to the API Definition for this Web App.
  api_management_api_id                         = The ID of the API Management API ID this Web App is associated with.
  app_command_line                              = The command line used to launch this app.
  container_registry_managed_identity_client_id = The Client ID of the Managed Service Identity to use for connections to the Azure Container Registry.
  container_registry_use_managed_identity       = Do connections for Azure Container Registry use Managed Identity.
  default_documents                             = The list of Default Documents for the Web App.
  ftps_state                                    = The State of FTP / FTPS service.
  health_check_path                             = The path to the Health Check.
  health_check_eviction_time_in_min             = The amount of time in minutes that a node can be unhealthy before being removed from the load balancer.
  http2_enabled                                 = Should the HTTP2 be enabled?
  load_balancing_mode                           = The Site load balancing.
  local_mysql_enabled                           = Is the Local MySQL enabled.
  managed_pipeline_mode                         = Managed pipeline mode.
  minimum_tls_version                           = The Minimum version of TLS for requests.
  remote_debugging_enabled                      = Is Remote Debugging enabled.
  remote_debugging_version                      = The Remote Debugging Version.
  scm_minimum_tls_version                       = The Minimum version of TLS for requests to SCM.
  scm_use_main_ip_restriction                   = Should the Web App ip_restriction configuration be used for the SCM also.
  use_32_bit_worker                             = Does the  Web App use a 32-bit worker.
  vnet_route_all_enabled                        = Should all outbound traffic have NAT Gateways, Network Security Groups and User Defined Routes applied?
  websockets_enabled                            = Should Web Sockets be enabled?
  worker_count                                  = The number of Workers for this App Service.

  An application_stack block supports the following:
  docker_image_name            = The docker image, including tag, used by this Web App.
  docker_registry_url          = The URL of the container registry where the docker_image_name is located. e.g. https://index.docker.io or https://mcr.microsoft.com. This value is required with docker_image_name.
  docker_registry_username     = The username to use for authentication against the registry to pull the image.
  docker_registry_password     = The password used for authentication with the Docker registry.
  dotnet_version               = The version of .NET in use.
  go_version                   = Defines the version of Go to use for the web app.
  java_server                  = The Java server type.
  java_server_version          = The version of the Java server in use.
  java_version                 = Specifies the version of Java to use for the web app.
  node_version                 = Defines the version of Node.js to use for the web app.
  php_version                  = Sets the version of PHP to use for the web app.
  python_version               = Specifies the version of Python to use for the web app.
  ruby_version                 = Determines the version of Ruby to use for the web app.
  current_stack                = Used in Windows web apps to specify the current stack version.
  docker_container_name        = Specifies the Docker container name for Windows web apps.
  docker_container_tag         = Defines the tag of the Docker container for Windows web apps.
  dotnet_core_version          = Specifies the version of .NET Core to use for the web app (Windows).
  tomcat_version               = Sets the version of Tomcat to use for the web app (Windows).
  java_embedded_server_enabled = Indicates whether a Java embedded server is enabled for the web app (Windows).
  python                       = A flag to indicate the use of Python for the web app (Windows).

  An auto_heal_setting block supports the following:
  action = This is an optional setting that defines the action to take when a specific set of criteria is met for auto-healing. Within the action block, the following arguments can be specified:
    action_type: Specifies the type of action that the auto-heal will perform.
    minimum_process_execution_time: Defines the minimum amount of time a process must execute before the action can be taken.
  trigger = This optional setting defines the conditions or triggers that cause the auto-heal action to execute. Within the trigger block, the following arguments can be specified:
    private_memory_kb: Specifies the amount of private memory usage (in kilobytes) on Windows that triggers the auto-heal action.
    requests: This is an optional object that defines a request-based trigger. It contains:
      count: The number of requests.
      interval: The time period during which the count of requests is evaluated.
    slow_request: An optional list of objects that define a slow request-based trigger. Each object contains:
      count: The number of slow requests.
      interval: The time period during which the count of slow requests is evaluated.
      time_taken: The threshold time that defines what is considered a slow request.
      path: An optional path that the slow request must match.
    status_code: An optional list of objects that define a status code-based trigger. Each object contains:
      count: The number of times a status code occurs.
      interval: The time period during which the count of status codes is evaluated.
      status_code_range: The range of status codes that trigger the action.
      path: An optional path that the request must match to be counted.
      sub_status: An optional sub-status code to further refine the trigger.
      win32_status_code: An optional Win32 status code to further refine the trigger.
  
  A cors block supports the following:
  allowed_origins     = This is a list that specifies the origins which should be allowed to make cross-origin requests to your web app. It's used to define which domains can access resources on your web app from a different domain.
  support_credentials = This is an optional argument that specifies whether the browser should send credentials, such as cookies or authorization headers, with cross-origin requests to your web app. Setting this to true allows credentials for cross-origin requests, while false disallows them. The default value is false if not specified.

  The ip_restriction block in the azurerm_linux_web_app and azurerm_windows_web_app resources in Terraform is used to define network access restrictions based on IP addresses or service tags. Here's a breakdown of each argument in this block:
    action: This optional argument specifies the action to apply to the traffic that matches the restriction rule. It determines whether to allow or deny traffic.
    headers: This optional argument is an object that allows specifying additional headers for more granular control. Within the headers block, the following arguments can be specified:
        x_azure_fdid: An optional header used to specify the Azure Front Door instance ID.
        x_fd_health_probe: An optional numeric value used for the health probe header.
        x_forwarded_for: An optional list of strings specifying the forwarded-for headers.
        x_forwarded_host: An optional list of strings specifying the forwarded-host headers.
    ip_address: This optional argument specifies a specific IP address or a range of IP addresses in CIDR notation. Traffic from these IP addresses will be subject to the specified action.
    name: An optional name for the IP restriction rule, which can be useful for identification purposes.
    priority: An optional numeric value that specifies the priority of the rule. Rules are processed in order of priority. The default value is 65000.
    service_tag: An optional argument used to specify an Azure service tag. A service tag represents a group of IP address prefixes to help minimize complexity for security rule creation.
    virtual_network_subnet_id: An optional argument used to specify a subnet ID in a virtual network. This allows traffic from that subnet to be subject to the specified action.
  
  A scm_ip_restriction block supports the following:
  action  = An optional argument to define the action to take when the restriction rule is matched.
  headers = An optional nested object that can include:
    x_azure_fdid: An optional list of strings to specify the Azure Front Door instance IDs.
    x_fd_health_probe: An optional list of strings for the Front Door health probe.
    x_forwarded_for: An optional list of strings for forwarded-for headers.
    x_forwarded_host: An optional list of strings for forwarded host headers.
  ip_address                = An optional argument to specify the IP address or CIDR block for the restriction.
  name                      = An optional argument to name the IP restriction rule.
  priority                  = An optional argument to set the priority of the rule, defaulting to 65000 if not specified.
  service_tag               = An optional argument to specify the service tag for the restriction.
  virtual_network_subnet_id = An optional argument to link the restriction to a specific virtual network subnet ID.
  EOT
  default     = {}

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.always_on", local.metadata.validator_expressions["default"]), tostring(var.site_config.always_on)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.always_on", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.ftps_state", local.metadata.validator_expressions["default"]), tostring(var.site_config.ftps_state)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.ftps_state", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.health_check_eviction_time_in_min", local.metadata.validator_expressions["default"]), tostring(var.site_config.health_check_eviction_time_in_min)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.health_check_eviction_time_in_min", local.metadata.validator_error_messages["default"])
  }

  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.http2_enabled", local.metadata.validator_expressions["default"]), tostring(var.site_config.http2_enabled)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.http2_enabled", local.metadata.validator_error_messages["default"])
  # }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.load_balancing_mode", local.metadata.validator_expressions["default"]), tostring(var.site_config.load_balancing_mode)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.load_balancing_mode", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.local_mysql_enabled", local.metadata.validator_expressions["default"]), tostring(var.site_config.local_mysql_enabled)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.local_mysql_enabled", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.managed_pipeline_mode", local.metadata.validator_expressions["default"]), tostring(var.site_config.managed_pipeline_mode)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.managed_pipeline_mode", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.minimum_tls_version", local.metadata.validator_expressions["default"]), tostring(var.site_config.minimum_tls_version)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.minimum_tls_versions_on", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.remote_debugging_enabled", local.metadata.validator_expressions["default"]), tostring(var.site_config.remote_debugging_enabled)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.remote_debugging_enabled", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.remote_debugging_version", local.metadata.validator_expressions["default"]), tostring(var.site_config.remote_debugging_version)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.remote_debugging_version", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.scm_minimum_tls_version", local.metadata.validator_expressions["default"]), tostring(var.site_config.scm_minimum_tls_version)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.scm_minimum_tls_version", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.scm_use_main_ip_restriction", local.metadata.validator_expressions["default"]), tostring(var.site_config.scm_use_main_ip_restriction)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.scm_use_main_ip_restriction", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.use_32_bit_worker", local.metadata.validator_expressions["default"]), tostring(var.site_config.use_32_bit_worker)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.use_32_bit_worker", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.vnet_route_all_enabled", local.metadata.validator_expressions["default"]), tostring(var.site_config.vnet_route_all_enabled)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.vnet_route_all_enabled", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.websockets_enabled", local.metadata.validator_expressions["default"]), tostring(var.site_config.websockets_enabled)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.websockets_enabled", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.worker_count", local.metadata.validator_expressions["default"]), tostring(var.site_config.worker_count)))
    error_message = lookup(local.metadata.validator_error_messages, "site_config.worker_count", local.metadata.validator_error_messages["default"])
  }
  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.auto_heal_setting_action_time", local.metadata.validator_expressions["default"]), tostring(var.site_config.auto_heal_setting.action.minimum_process_execution_time)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_action_time", local.metadata.validator_error_messages["default"])
  # }

  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.auto_heal_setting_trigger_requests_count", local.metadata.validator_expressions["default"]), tostring(var.site_config.auto_heal_setting.trigger.requests.count)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_trigger_requests_count", local.metadata.validator_error_messages["default"])
  # }

  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.auto_heal_setting_trigger_requests_interval", local.metadata.validator_expressions["default"]), tostring(var.site_config.auto_heal_setting.trigger.requests.interval)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_trigger_requests_interval", local.metadata.validator_error_messages["default"])
  # }

  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.auto_heal_setting_trigger_slow_request_count", local.metadata.validator_expressions["default"]), tostring(var.site_config.auto_heal_setting.trigger.slow_request.count)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_trigger_slow_request_count", local.metadata.validator_error_messages["default"])
  # }

  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.auto_heal_setting_trigger_slow_request_interval", local.metadata.validator_expressions["default"]), tostring(var.site_config.auto_heal_setting.trigger.slow_request.interval)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_trigger_slow_request_interval", local.metadata.validator_error_messages["default"])
  # }

  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.auto_heal_setting_trigger_slow_request_time_taken", local.metadata.validator_expressions["default"]), tostring(var.site_config.auto_heal_setting.trigger.slow_request.time_taken)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_trigger_slow_request_time_taken", local.metadata.validator_error_messages["default"])
  # }

  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.auto_heal_setting_trigger_status_code_count", local.metadata.validator_expressions["default"]), tostring(var.site_config.auto_heal_setting.trigger.status_code.count)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_trigger_status_code_count", local.metadata.validator_error_messages["default"])
  # }

  # validation {
  #   condition     = can(regex(lookup(local.metadata.validator_expressions, "site_config.auto_heal_setting_trigger_status_code_interval", local.metadata.validator_expressions["default"]), tostring(var.site_config.auto_heal_setting.trigger.status_code.interval)))
  #   error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_trigger_status_code_interval", local.metadata.validator_error_messages["default"])
  # }

  validation {
    condition = try(
      var.site_config.auto_heal_setting == null ||
      (
        (length(split("-", var.site_config.auto_heal_setting.trigger.status_code.status_code_range)) == 1 &&
          tonumber(var.site_config.auto_heal_setting.trigger.status_code.status_code_range) >= 101 &&
        tonumber(var.site_config.auto_heal_setting.trigger.status_code.status_code_range) <= 599)
        ||
        (length(split("-", var.site_config.auto_heal_setting.trigger.status_code.status_code_range)) == 2 &&
          tonumber(split("-", var.site_config.auto_heal_setting.trigger.status_code.status_code_range)[0]) >= 101 &&
          tonumber(split("-", var.site_config.auto_heal_setting.trigger.status_code.status_code_range)[1]) <= 599 &&
          tonumber(split("-", var.site_config.auto_heal_setting.trigger.status_code.status_code_range)[0]) <
          tonumber(split("-", var.site_config.auto_heal_setting.trigger.status_code.status_code_range)[1])
        )
      ),
      true
    )
    error_message = lookup(local.metadata.validator_error_messages, "site_config.auto_heal_setting_trigger_status_code_range", local.metadata.validator_error_messages["default"])
  }


  validation {
    condition = (
      can(var.site_config.ip_restriction) == false ||
      (
        can(var.site_config.ip_restriction.action) == false ||
        (
          can(tostring(var.site_config.ip_restriction.action)) &&
          can(regex(
            lookup(local.metadata.validator_expressions, "site_config.ip_restriction_action", local.metadata.validator_expressions["default"]),
            tostring(var.site_config.ip_restriction.action)
          ))
        )
      )
    )
    error_message = lookup(local.metadata.validator_error_messages, "site_config.ip_restriction_action", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition = (
      can(var.site_config.ip_restriction) == false ||
      (
        can(var.site_config.ip_restriction.ip_address) == false ||
        (
          can(tostring(var.site_config.ip_restriction.ip_address)) &&
          can(regex(
            lookup(local.metadata.validator_expressions, "site_config.ip_restriction_ip_address", local.metadata.validator_expressions["default"]),
            tostring(var.site_config.ip_restriction.ip_address)
          ))
        )
      )
    )
    error_message = lookup(local.metadata.validator_error_messages, "site_config.ip_restriction_ip_address", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition = (
      can(var.site_config.scm_ip_restriction) == false ||
      (
        can(var.site_config.scm_ip_restriction.action) == false ||
        (
          can(tostring(var.site_config.scm_ip_restriction.action)) &&
          can(regex(
            lookup(local.metadata.validator_expressions, "site_config.scm_ip_restriction_action", local.metadata.validator_expressions["default"]),
            tostring(var.site_config.scm_ip_restriction.action)
          ))
        )
      )
    )
    error_message = lookup(local.metadata.validator_error_messages, "site_config.scm_ip_restriction_action", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition = (
      can(var.site_config.scm_ip_restriction) == false ||
      (
        can(var.site_config.scm_ip_restriction.ip_address) == false ||
        (
          can(tostring(var.site_config.scm_ip_restriction.ip_address)) &&
          can(regex(
            lookup(local.metadata.validator_expressions, "site_config.scm_ip_restriction_ip_address", local.metadata.validator_expressions["default"]),
            tostring(var.site_config.scm_ip_restriction.ip_address)
          ))
        )
      )
    )
    error_message = lookup(local.metadata.validator_error_messages, "site_config.scm_ip_restriction_ip_address", local.metadata.validator_error_messages["default"])
  }



}


variable "auth_settings" {
  type = object({
    enabled                        = bool
    additional_login_parameters    = optional(map(string))
    allowed_external_redirect_urls = optional(list(string))
    default_provider               = optional(string)
    issuer                         = optional(string)
    runtime_version                = optional(string)
    token_refresh_extension_hours  = optional(number, 72)
    token_store_enabled            = optional(bool, false)
    unauthenticated_client_action  = optional(string)
    active_directory = optional(object({
      client_id                  = string
      allowed_audiences          = optional(list(string))
      client_secret              = optional(string)
      client_secret_setting_name = optional(string)
    }))
    facebook = optional(object({
      app_id                  = string
      app_secret              = optional(string)
      app_secret_setting_name = optional(string)
      oauth_scopes            = optional(list(string))
    }))
    github = optional(object({
      client_id                  = string
      client_secret              = optional(string)
      client_secret_setting_name = optional(string)
      oauth_scopes               = optional(list(string))
    }))
    google = optional(object({
      client_id                  = string
      client_secret              = optional(string)
      client_secret_setting_name = optional(string)
      oauth_scopes               = optional(list(string))
    }))
    microsoft = optional(object({
      client_id                  = string
      client_secret              = optional(string)
      client_secret_setting_name = optional(string)
      oauth_scopes               = optional(list(string))
    }))
    twitter = optional(object({
      consumer_key                 = string
      consumer_secret              = optional(string)
      consumer_secret_setting_name = optional(string)
    }))
  })
  description = <<EOT
  Authentication settings for App Service

  enabled                        = Should the Authentication / Authorization feature be enabled for the Web App?
  additional_login_parameters    = A map of login Parameters to send to the OpenID Connect authorization endpoint when a user logs in.
  allowed_external_redirect_urls = A list of External URLs that can be redirected to as part of logging in or logging out of the Web App.
  default_provider               = The default authentication provider to use when multiple providers are configured.
  issuer                         = The OpenID Connect Issuer URI that represents the entity that issues access tokens for this Web App.
  runtime_version                = The RuntimeVersion of the Authentication / Authorization feature in use for the Web App.
  token_refresh_extension_hours  = The number of hours after session token expiration that a session token can be used to call the token refresh API. Defaults to 72 hours.
  token_store_enabled            = Should the Web App durably store platform-specific security tokens that are obtained during login flows? Defaults to false.
  unauthenticated_client_action  = The action to take when an unauthenticated client attempts to access the app. Possible values include: RedirectToLoginPage, AllowAnonymous.

  An active_directory block supports the following:
  client_id                  = The ID of the Client to use to authenticate with Azure Active Directory.
  allowed_audiences          = A list of Allowed audience values to consider when validating JWTs issued by Azure Active Directory.
  client_secret              = The Client Secret for the Client ID. Cannot be used with client_secret_setting_name.
  client_secret_setting_name = The App Setting name that contains the client secret of the Client. Cannot be used with client_secret.
  
  A facebook block supports the following:
  app_id                  = The App ID of the Facebook app used for login.
  app_secret              = The App Secret of the Facebook app used for Facebook login. Cannot be specified with app_secret_setting_name.
  app_secret_setting_name = The app setting name that contains the app_secret value used for Facebook login. Cannot be specified with app_secret.
  oauth_scopes            = A list of OAuth 2.0 scopes to be requested as part of Facebook login authentication.

  A github block supports the following:
  client_id                  = The ID of the GitHub app used for login.
  client_secret              = The Client Secret of the GitHub app used for GitHub login. Cannot be specified with client_secret_setting_name.
  client_secret_setting_name = The app setting name that contains the client_secret value used for GitHub login. Cannot be specified with client_secret.
  oauth_scopes               = A list of OAuth 2.0 scopes that will be requested as part of GitHub login authentication.

  A google block supports the following:
  client_id                  = The OpenID Connect Client ID for the Google web application.
  client_secret              = The client secret associated with the Google web application. Cannot be specified with client_secret_setting_name.
  client_secret_setting_name = The app setting name that contains the client_secret value used for Google login. Cannot be specified with client_secret.
  oauth_scopes               = A list of OAuth 2.0 scopes that will be requested as part of Google Sign-In authentication. If not specified, openid, profile, and email are used as default scopes.

  A microsoft block supports the following:
  client_id                  = The OAuth 2.0 client ID that was created for the app used for authentication.
  client_secret              = The OAuth 2.0 client secret that was created for the app used for authentication. Cannot be specified with client_secret_setting_name.
  client_secret_setting_name = The app setting name containing the OAuth 2.0 client secret that was created for the app used for authentication. Cannot be specified with client_secret.
  oauth_scopes               = A list of OAuth 2.0 scopes that will be requested as part of Microsoft Account authentication. If not specified, "wl.basic" is used as the default scope.
  
  A twitter block supports the following:
  consumer_key                 = The OAuth 1.0a consumer key of the Twitter application used for sign-in.
  consumer_secret              = The OAuth 1.0a consumer secret of the Twitter application used for sign-in. Cannot be specified with consumer_secret_setting_name.
  consumer_secret_setting_name = The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in. Cannot be specified with consumer_secret.
  EOT
  default     = null

  #  validation {
  #     condition     = can(regex(lookup(local.metadata.validator_expressions, "auth_settings_enabled", local.metadata.validator_expressions["default"]), tostring(var.auth_settings.enabled)))
  #     error_message = lookup(local.metadata.validator_error_messages, "auth_settings_enabled", local.metadata.validator_error_messages["default"])
  #   }

  #   validation {
  #     condition     = can(regex(lookup(local.metadata.validator_expressions, "auth_settings_token_refresh_extension_hours", local.metadata.validator_expressions["default"]), tostring(var.auth_settings.token_refresh_extension_hours)))
  #     error_message = lookup(local.metadata.validator_error_messages, "auth_settings_token_refresh_extension_hours", local.metadata.validator_error_messages["default"])
  #   }

  #   validation {
  #     condition     = can(regex(lookup(local.metadata.validator_expressions, "auth_settings_token_store_enabled", local.metadata.validator_expressions["default"]), tostring(var.auth_settings.token_store_enabled)))
  #     error_message = lookup(local.metadata.validator_error_messages, "auth_settings_token_store_enabled", local.metadata.validator_error_messages["default"])
  #   }

  # validation {
  #   condition = try(
  #     var.auth_settings == null ||
  #     contains(
  #       lookup(local.metadata.validator_expressions, "auth_settings_unauthenticated_client_action", ["RedirectToLoginPage", "AllowAnonymous"]),
  #       var.auth_settings.unauthenticated_client_action
  #     ),
  #     true
  #   )
  #   error_message = lookup(local.metadata.validator_error_messages, "auth_settings_unauthenticated_client_action", local.metadata.validator_error_messages["default"])
  # }


}

variable "auth_settings_v2" {
  default = null
  type = object({
    auth_enabled                            = optional(bool, false)
    runtime_version                         = optional(string, "~1")
    config_file_path                        = optional(string)
    require_authentication                  = optional(bool)
    unauthenticated_action                  = optional(string, "RedirectToLoginPage")
    default_provider                        = optional(string)
    excluded_paths                          = optional(list(string))
    require_https                           = optional(bool, true)
    http_route_api_prefix                   = optional(string, "/.auth")
    forward_proxy_convention                = optional(string, "NoProxy")
    forward_proxy_custom_host_header_name   = optional(string)
    forward_proxy_custom_scheme_header_name = optional(string)
    apple_v2 = optional(object({
      client_id                  = string
      client_secret_setting_name = string
      login_scopes               = list(string)
    }))
    active_directory_v2 = optional(object({
      client_id                            = string
      tenant_auth_endpoint                 = string
      client_secret_setting_name           = optional(string)
      client_secret_certificate_thumbprint = optional(string)
      jwt_allowed_groups                   = optional(list(string))
      jwt_allowed_client_applications      = optional(list(string))
      www_authentication_disabled          = optional(bool, false)
      allowed_groups                       = optional(list(string))
      allowed_identities                   = optional(list(string))
      allowed_applications                 = optional(list(string))
      login_parameters                     = optional(map(string))
      allowed_audiences                    = optional(list(string))
    }))
    azure_static_web_app_v2 = optional(object({
      client_id = string
    }))
    custom_oidc_v2 = optional(object({
      name                          = string
      client_id                     = string
      openid_configuration_endpoint = string
      name_claim_type               = optional(string)
      scopes                        = optional(list(string))
      client_credential_method      = optional(string)
      client_secret_setting_name    = optional(string)
      authorisation_endpoint        = optional(string)
      token_endpoint                = optional(string)
      issuer_endpoint               = optional(string)
      certification_uri             = optional(string)
    }))
    facebook_v2 = optional(object({
      app_id                  = string
      app_secret_setting_name = string
      graph_api_version       = optional(string)
      login_scopes            = optional(list(string))
    }))
    github_v2 = optional(object({
      client_id                  = string
      client_secret_setting_name = string
      login_scopes               = optional(list(string))
    }))
    google_v2 = optional(object({
      client_id                  = string
      client_secret_setting_name = string
      allowed_audiences          = optional(list(string))
      login_scopes               = optional(list(string))
    }))
    microsoft_v2 = optional(object({
      client_id                  = string
      client_secret_setting_name = string
      allowed_audiences          = optional(list(string))
      login_scopes               = optional(list(string))
    }))
    twitter_v2 = optional(object({
      consumer_key                 = string
      consumer_secret_setting_name = string
    }))
    login = object({
      logout_endpoint                   = optional(string)
      token_store_enabled               = optional(bool, false)
      token_refresh_extension_time      = optional(number, 72)
      token_store_path                  = optional(string)
      token_store_sas_setting_name      = optional(string)
      preserve_url_fragments_for_logins = optional(bool, false)
      allowed_external_redirect_urls    = optional(list(string))
      cookie_expiration_convention      = optional(string, "FixedTime")
      cookie_expiration_time            = optional(string, "08:00:00")
      validate_nonce                    = optional(bool, true)
      nonce_expiration_time             = optional(string, "00:05:00")
    })
  })
  description = <<EOT
  Authentication settings for App Service via the V2 format

  auth_enabled                            = Should the AuthV2 Settings be enabled. Defaults to false.
  runtime_version                         = The Runtime Version of the Authentication and Authorisation feature of this App. Defaults to ~1.
  config_file_path                        = The path to the App Auth settings. 
  require_authentication                  = Should the authentication flow be used for all requests.
  unauthenticated_action                  = The action to take for requests made without authentication.
  default_provider                        = The Default Authentication Provider to use when the unauthenticated_action is set to RedirectToLoginPage.
  excluded_paths                          = The paths which should be excluded from the unauthenticated_action when it is set to RedirectToLoginPage.
  require_https                           = Should HTTPS be required on connections? Defaults to true.
  http_route_api_prefix                   = The prefix that should precede all the authentication and authorisation paths. Defaults to /.auth.
  forward_proxy_convention                = The convention used to determine the url of the request made.
  forward_proxy_custom_host_header_name   = The name of the custom header containing the host of the request.
  forward_proxy_custom_scheme_header_name = The name of the custom header containing the scheme of the request.

  An apple_v2 block supports the following:  
  client_id                  = The OpenID Connect Client ID for the Apple web application.
  client_secret_setting_name = The app setting name that contains the client_secret value used for Apple Login.
  login_scopes               = A list of Login Scopes provided by this Authentication Provider.

  An active_directory_v2 block supports the following:
  client_id                            = The ID of the Client to use to authenticate with Azure Active Directory.
  tenant_auth_endpoint                 = The Azure Tenant Endpoint for the Authenticating Tenant.
  client_secret_setting_name           = The App Setting name that contains the client secret of the Client.
  client_secret_certificate_thumbprint = The thumbprint of the certificate used for signing purposes.
  jwt_allowed_groups                   = A list of Allowed Groups in the JWT Claim.
  jwt_allowed_client_applications      = A list of Allowed Client Applications in the JWT Claim.
  www_authentication_disabled          = Should the www-authenticate provider should be omitted from the request? Defaults to false.
  allowed_groups                       = The list of allowed Group Names for the Default Authorisation Policy.
  allowed_identities                   = The list of allowed Identities for the Default Authorisation Policy.
  allowed_applications                 = The list of allowed Applications for the Default Authorisation Policy.
  login_parameters                     = A map of key-value pairs to send to the Authorisation Endpoint when a user logs in.
  allowed_audiences                    = Specifies a list of Allowed audience values to consider when validating JWTs issued by Azure Active Directory.

  An azure_static_web_app_v2 block supports the following:
  client_id = string

  A custom_oidc_v2 block supports the following:
  name                          = The name of the Custom OIDC Authentication Provider.
  client_id                     = The ID of the Client to use to authenticate with the Custom OIDC.
  openid_configuration_endpoint = The endpoint used for OpenID Connect Discovery.
  name_claim_type               = The name of the claim that contains the users name.
  scopes                        = The list of the scopes that should be requested while authenticating.
  client_credential_method      = The Client Credential Method used.
  client_secret_setting_name    = The App Setting name that contains the secret for this Custom OIDC Client.
  authorisation_endpoint        = The endpoint to make the Authorisation Request as supplied by openid_configuration_endpoint response.
  token_endpoint                = The endpoint used to request a Token as supplied by openid_configuration_endpoint response.
  issuer_endpoint               = The endpoint that issued the Token as supplied by openid_configuration_endpoint response.
  certification_uri             = The endpoint that provides the keys necessary to validate the token as supplied by openid_configuration_endpoint response.

  A facebook_v2 block supports the following:
  app_id                  = The App ID of the Facebook app used for login.
  app_secret_setting_name = The app setting name that contains the app_secret value used for Facebook Login.
  graph_api_version       = The version of the Facebook API to be used while logging in.
  login_scopes            = The list of scopes that should be requested as part of Facebook Login authentication.

  A github_v2 block supports the following:
  client_id                  = The ID of the GitHub app used for login..
  client_secret_setting_name = The app setting name that contains the client_secret value used for GitHub Login.
  login_scopes               = The list of OAuth 2.0 scopes that should be requested as part of GitHub Login authentication.

  A google_v2 block supports the following:
  client_id                  = The OpenID Connect Client ID for the Google web application.
  client_secret_setting_name = The app setting name that contains the client_secret value used for Google Login.
  allowed_audiences          = The list of Allowed Audiences that should be requested as part of Google Sign-In authentication.
  login_scopes               = The list of OAuth 2.0 scopes that should be requested as part of Google Sign-In authentication.

  A microsoft_v2 block supports the following:
  client_id                  = The OAuth 2.0 client ID that was created for the app used for authentication.
  client_secret_setting_name = The app setting name containing the OAuth 2.0 client secret that was created for the app used for authentication.
  allowed_audiences          = The list of Allowed Audiences that will be requested as part of Microsoft Sign-In authentication.
  login_scopes               = The list of Login scopes that should be requested as part of Microsoft Account authentication.

  A twitter_v2 block supports the following:
  consumer_key                 = The OAuth 1.0a consumer key of the Twitter application used for sign-in.
  consumer_secret_setting_name = The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in.

  A login block supports the following:
  logout_endpoint                   = The endpoint to which logout requests should be made.
  token_store_enabled               = Should the Token Store configuration Enabled. Defaults to false
  token_refresh_extension_time      = The number of hours after session token expiration that a session token can be used to call the token refresh API. Defaults to 72 hours.
  token_store_path                  = The directory path in the App Filesystem in which the tokens will be stored.
  token_store_sas_setting_name      = The name of the app setting which contains the SAS URL of the blob storage containing the tokens.
  preserve_url_fragments_for_logins = Should the fragments from the request be preserved after the login request is made. Defaults to false.
  allowed_external_redirect_urls    = External URLs that can be redirected to as part of logging in or logging out of the app.
  cookie_expiration_convention      = The method by which cookies expire. Possible values include: FixedTime, and IdentityProviderDerived. Defaults to FixedTime.
  cookie_expiration_time            = The time after the request is made when the session cookie should expire. Defaults to 08:00:00.
  validate_nonce                    = Should the nonce be validated while completing the login flow. Defaults to true.
  nonce_expiration_time             = The time after the request is made when the nonce should expire. Defaults to 00:05:00.
  EOT

  validation {
    condition     = try(var.auth_settings_v2 == null || can(regex(lookup(local.metadata.validator_expressions, "auth_settings_v2_auth_enabled", local.metadata.validator_expressions["default"]), tostring(var.auth_settings_v2.auth_enabled))), true)
    error_message = lookup(local.metadata.validator_error_messages, "auth_settings_v2_auth_enabled", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = try(var.auth_settings_v2 == null || can(regex(lookup(local.metadata.validator_expressions, "auth_settings_v2_require_authentication", local.metadata.validator_expressions["default"]), tostring(var.auth_settings_v2.require_authentication))), true)
    error_message = lookup(local.metadata.validator_error_messages, "auth_settings_v2_require_authentication", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = try(var.auth_settings_v2 == null || can(regex(lookup(local.metadata.validator_expressions, "auth_settings_v2_unauthenticated_action", local.metadata.validator_expressions["default"]), tostring(var.auth_settings_v2.unauthenticated_action))), true)
    error_message = lookup(local.metadata.validator_error_messages, "auth_settings_v2_unauthenticated_action", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = try(var.auth_settings_v2 == null || can(regex(lookup(local.metadata.validator_expressions, "auth_settings_v2_require_https", local.metadata.validator_expressions["default"]), tostring(var.auth_settings_v2.require_https))), true)
    error_message = lookup(local.metadata.validator_error_messages, "auth_settings_v2_require_https", local.metadata.validator_error_messages["default"])
  }

  validation {
    condition     = try(var.auth_settings_v2 == null || can(regex(lookup(local.metadata.validator_expressions, "auth_settings_v2_forward_proxy_convention", local.metadata.validator_expressions["default"]), tostring(var.auth_settings_v2.forward_proxy_convention))), true)
    error_message = lookup(local.metadata.validator_error_messages, "auth_settings_v2_forward_proxy_convention", local.metadata.validator_error_messages["default"])
  }

}

variable "backup" {
  type = object({
    name = string
    schedule = object({
      frequency_interval       = number
      frequency_unit           = string
      keep_at_least_one_backup = optional(bool, false)
      retention_period_days    = optional(number)
      start_time               = optional(string)
    })
    storage_account_url = string
    enabled             = optional(bool, true)
  })
  description = <<EOT
  Backup configuration for App Service

  name                = The name which should be used for this Backup.
  storage_account_url = The SAS URL to the container.
  enabled             = Should this backup job be enabled? Defaults to true.

  A schedule block supports the following:
  frequency_interval       = How often the backup should be executed (e.g. for weekly backup, this should be set to 7 and frequency_unit should be set to Day).
  frequency_unit           = The unit of time for how often the backup should take place. Possible values include: Day, Hour
  keep_at_least_one_backup = Should the service keep at least one backup, regardless of the age of backup? Defaults to false.
  retention_period_days    = After how many days backups should be deleted. Defaults to 30.
  start_time               = When the schedule should start working in RFC-3339 format.
  EOT
  default     = null
}

variable "connection_strings" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = <<EOT
  Connection string for App Service

  name  = The name of the Connection String.
  type  = Type of database. Possible values include: MySQL, SQLServer, SQLAzure, Custom, NotificationHub, ServiceBus, EventHub, APIHub, DocDb, RedisCache, and PostgreSQL.
  value = The connection string value.
  EOT
  default     = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = <<EOT
  Identity configuration for App Service

  type         = The type of Managed Service Identity that should be configured on this Linux Web App. Possible values are SystemAssigned, UserAssigned, and SystemAssigned, UserAssigned (to enable both).
  identity_ids = List of User Assigned Managed Identity IDs to be assigned to this Linux Web App.
  EOT
  default     = null
}

variable "logs" {
  type = object({
    application_logs = object({
      file_system_level = string
      azure_blob_storage = optional(object({
        level             = string
        retention_in_days = number
        sas_url           = string
      }))
    })
    detailed_error_messages = optional(bool)
    failed_request_tracing  = optional(bool)
    http_logs = object({
      azure_blob_storage = optional(object({
        retention_in_days = optional(number)
        sas_url           = string
      }))
      file_system = optional(object({
        retention_in_days = number
        retention_in_mb   = number
      }))
    })
  })
  description = <<EOT
  Logs configuration for App Service

  An application_logs block supports the following:
  azure_blob_storage = An azure_blob_storage block as defined below.
  file_system_level  = Log level. Possible values include: Verbose, Information, Warning, and Error.

  An azure_blob_storage block supports the following:
  level             = The level at which to log. Possible values include Error, Warning, Information, Verbose and Off. NOTE: this field is not available for http_logs
  retention_in_days = The time in days after which to remove blobs. A value of 0 means no retention.
  sas_url           = SAS url to an Azure blob container with read/write/list/delete permissions.

  detailed_error_messages = Should detailed error messages be enabled?
  failed_request_tracing  = Should detailed error messages be enabled?

  A http_logs block may consist of an azure_blob_storage_http block and file_system block:

  An azure_blob_storage_http block supports the following:
  retention_in_days = The time in days after which to remove blobs. A value of 0 means no retention.
  sas_url           = SAS url to an Azure blob container with read/write/list/delete permissions.

  A file_system block supports the following:
  retention_in_days = The retention period in days. A value of 0 means no retention.
  retention_in_mb   = The maximum size in megabytes that log files can use.
  EOT
  default     = null
}

variable "storage_account" {
  type = list(object({
    access_key   = string
    account_name = string
    name         = string
    share_name   = string
    type         = string
    mount_path   = optional(string)
  }))
  description = <<EOT
  Storage account configuration for App Service

  access_key   = The Access key for the storage account.
  account_name = The Name of the Storage Account.
  name         = The name which should be used for this Storage Account.
  share_name   = The Name of the File Share or Container Name for Blob storage.
  type         = The Azure Storage Type. Possible values include AzureFiles and AzureBlob
  mount_path   = The path at which to mount the storage share.
  EOT
  default     = null
}

variable "sticky_settings" {
  type = object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  })
  description = <<EOT
  Sticky settings for App Service

  app_setting_names       = A list of app_setting names that the Linux Web App will not swap between Slots when a swap operation is triggered.
  connection_string_names = A list of connection_string names that the Linux Web App will not swap between Slots when a swap operation is triggered.
  EOT
  default     = null
}

variable "web_app_slots" {
  type = list(object({
    name                                           = string
    app_service_id                                 = string
    app_settings                                   = optional(map(string))
    client_affinity_enabled                        = optional(bool)
    client_certificate_enabled                     = optional(bool)
    client_certificate_mode                        = optional(string)
    client_certificate_exclusion_paths             = optional(string)
    enabled                                        = optional(bool, true)
    https_only                                     = optional(bool)
    public_network_access_enabled                  = optional(bool, true)
    key_vault_reference_identity_id                = optional(string)
    virtual_network_subnet_id                      = optional(string)
    webdeploy_publish_basic_authentication_enabled = optional(bool, true)
    zip_deploy_file                                = optional(string)
    site_config = object({
      always_on                                     = optional(bool, true)
      api_definition_url                            = optional(string)
      api_management_api_id                         = optional(string)
      app_command_line                              = optional(string)
      container_registry_managed_identity_client_id = optional(string)
      container_registry_use_managed_identity       = optional(bool)
      default_documents                             = optional(list(string))
      ftps_state                                    = optional(string)
      health_check_path                             = optional(string)
      health_check_eviction_time_in_min             = optional(number)
      http2_enabled                                 = optional(bool)
      load_balancing_mode                           = optional(string, "LeastRequests")
      local_mysql_enabled                           = optional(bool, false)
      managed_pipeline_mode                         = optional(string)
      minimum_tls_version                           = optional(string, "1.2")
      remote_debugging_enabled                      = optional(bool, false)
      remote_debugging_version                      = optional(string)
      scm_minimum_tls_version                       = optional(string, "1.2")
      scm_use_main_ip_restriction                   = optional(bool)
      use_32_bit_worker                             = optional(bool, true)
      vnet_route_all_enabled                        = optional(bool, false)
      websockets_enabled                            = optional(bool, false)
      worker_count                                  = optional(number)
      application_stack = optional(object({
        docker_image_name            = optional(string)
        docker_registry_url          = optional(string)
        docker_registry_username     = optional(string)
        docker_registry_password     = optional(string)
        dotnet_version               = optional(string)
        go_version                   = optional(string)
        java_server                  = optional(string)
        java_server_version          = optional(string)
        java_version                 = optional(string)
        node_version                 = optional(string)
        php_version                  = optional(string)
        python_version               = optional(string)
        ruby_version                 = optional(string)
        current_stack                = optional(string) # Windows
        docker_container_name        = optional(string) # Windows
        docker_container_tag         = optional(string) # Windows
        dotnet_core_version          = optional(string) # Windows
        tomcat_version               = optional(string) # Windows
        java_embedded_server_enabled = optional(bool)   # Windows
        python                       = optional(bool)   # Windows
      }))
      auto_heal_setting = optional(object({
        private_memory_kb = optional(number)
        action = optional(object({
          action_type                    = string
          minimum_process_execution_time = optional(string)
        }))
        trigger = optional(object({
          private_memory_kb = optional(number) # Windows
          requests = optional(object({
            count    = number
            interval = string
          }))
          slow_request = optional(list(object({
            count      = number
            interval   = string
            time_taken = string
            path       = optional(string)
          })))
          status_code = optional(list(object({
            count             = number
            interval          = string
            status_code_range = string
            path              = optional(string)
            sub_status        = optional(number)
            win32_status_code = optional(number)
          })))
        }))
      }))
      cors = optional(object({
        allowed_origins     = list(string)
        support_credentials = optional(bool, false)
      }))
      ip_restriction = optional(list(object({
        action = optional(string)
        headers = optional(object({
          x_azure_fdid      = optional(string)
          x_fd_health_probe = optional(number)
          x_forwarded_for   = optional(list(string))
          x_forwarded_host  = optional(list(string))
        }))
        ip_address                = optional(string)
        name                      = optional(string)
        priority                  = optional(number, 65000)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
      })))
      scm_ip_restriction = optional(list(object({
        action = optional(string)
        headers = optional(object({
          x_azure_fdid      = optional(list(string))
          x_fd_health_probe = optional(list(string))
          x_forwarded_for   = optional(list(string))
          x_forwarded_host  = optional(list(string))
        }))
        ip_address                = optional(string)
        name                      = optional(string)
        priority                  = optional(number, 65000)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
      })))
    })
    auth_settings = optional(object({
      enabled                        = bool
      additional_login_parameters    = optional(map(string))
      allowed_external_redirect_urls = optional(list(string))
      default_provider               = optional(string)
      issuer                         = optional(string)
      runtime_version                = optional(string)
      token_refresh_extension_hours  = optional(number)
      token_store_enabled            = optional(bool, false)
      unauthenticated_client_action  = optional(string)
      active_directory = optional(object({
        client_id                  = string
        allowed_audiences          = optional(list(string))
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
      }))
      facebook = optional(object({
        app_id                  = string
        app_secret              = optional(string)
        app_secret_setting_name = optional(string)
        oauth_scopes            = optional(list(string))
      }))
      github = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      google = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      microsoft = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      twitter = optional(object({
        consumer_key                 = string
        consumer_secret              = optional(string)
        consumer_secret_setting_name = optional(string)
      }))
    }))
    auth_settings_v2 = optional(object({
      auth_enabled                            = optional(bool, false)
      runtime_version                         = optional(string, "~1")
      config_file_path                        = optional(string)
      require_authentication                  = optional(bool)
      unauthenticated_action                  = optional(string, "RedirectToLoginPage")
      default_provider                        = optional(string)
      excluded_paths                          = optional(list(string))
      require_https                           = optional(bool, true)
      http_route_api_prefix                   = optional(string, "/.auth")
      forward_proxy_convention                = optional(string, "NoProxy")
      forward_proxy_custom_host_header_name   = optional(string)
      forward_proxy_custom_scheme_header_name = optional(string)
      apple_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = list(string)
      }))
      active_directory_v2 = optional(object({
        client_id                            = string
        tenant_auth_endpoint                 = string
        client_secret_setting_name           = optional(string)
        client_secret_certificate_thumbprint = optional(string)
        jwt_allowed_groups                   = optional(list(string))
        jwt_allowed_client_applications      = optional(list(string))
        www_authentication_disabled          = optional(bool, false)
        allowed_groups                       = optional(list(string))
        allowed_identities                   = optional(list(string))
        allowed_applications                 = optional(list(string))
        login_parameters                     = optional(map(string))
        allowed_audiences                    = optional(list(string))
      }))
      azure_static_web_app_v2 = optional(object({
        client_id = string
      }))
      custom_oidc_v2 = optional(object({
        name                          = string
        client_id                     = string
        openid_configuration_endpoint = string
        name_claim_type               = optional(string)
        scopes                        = optional(list(string))
        client_credential_method      = optional(string)
        client_secret_setting_name    = optional(string)
        authorisation_endpoint        = optional(string)
        token_endpoint                = optional(string)
        issuer_endpoint               = optional(string)
        certification_uri             = optional(string)
      }))
      facebook_v2 = optional(object({
        app_id                  = string
        app_secret_setting_name = string
        graph_api_version       = optional(string)
        login_scopes            = optional(list(string))
      }))
      github_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string))
      }))
      google_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string))
        login_scopes               = optional(list(string))
      }))
      microsoft_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string))
        login_scopes               = optional(list(string))
      }))
      twitter_v2 = optional(object({
        consumer_key                 = string
        consumer_secret_setting_name = string
      }))
      login = object({
        logout_endpoint                   = optional(string)
        token_store_enabled               = optional(bool, false)
        token_refresh_extension_time      = optional(number, 72)
        token_store_path                  = optional(string)
        token_store_sas_setting_name      = optional(string)
        preserve_url_fragments_for_logins = optional(bool, false)
        allowed_external_redirect_urls    = optional(list(string))
        cookie_expiration_convention      = optional(string, "FixedTime")
        cookie_expiration_time            = optional(string, "08:00:00")
        validate_nonce                    = optional(bool, true)
        nonce_expiration_time             = optional(string, "00:05:00")
      })
    }))
    backup = optional(object({
      name = string
      schedule = object({
        frequency_interval       = number
        frequency_unit           = string
        keep_at_least_one_backup = optional(bool, false)
        retention_period_days    = optional(number)
        start_time               = optional(string)
      })
      storage_account_url = string
      enabled             = optional(bool, true)
    }))
    connection_strings = optional(list(object({
      name  = string
      type  = string
      value = string
    })))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    logs = optional(object({
      application_logs = object({
        file_system_level = string
        azure_blob_storage = optional(object({
          level             = string
          retention_in_days = number
          sas_url           = string
        }))
      })
      detailed_error_messages = optional(bool)
      failed_request_tracing  = optional(bool)
      http_logs = object({
        azure_blob_storage = optional(object({
          retention_in_days = optional(number)
          sas_url           = string
        }))
        file_system = optional(object({
          retention_in_days = number
          retention_in_mb   = number
        }))
      })
    }))
    storage_account = optional(list(object({
      access_key   = string
      account_name = string
      name         = string
      share_name   = string
      type         = string
      mount_path   = optional(string)
    })))
  }))
  description = "List of Linux Web App Slots alongside their attributes."
  default     = []
}

variable "service_certificates" {
  type = list(object({
    name                = string
    use_custom_name     = optional(bool)
    byoc                = optional(bool, true)
    full_path           = optional(string)
    password            = optional(string)
    use_password        = optional(bool, false)
    key_vault_secret_id = optional(string)
  }))
  description = <<EOT
  App Service certificates

  name                = The name of the certificate.
  use_custom_name     = Enable the use of custom name for App Service certificate
  byoc                = Bring Your Own Certificate (BYOC)
  full_path           = The certificate's filesystem path.
  password            = The password to access the certificate's private key.
  use_password        = Enable the use of a password for App Service certificate
  key_vault_secret_id = The ID of the Key Vault secret.
  EOT
  default     = []
}

variable "app_settings" {
  type        = map(string)
  description = "A map of key-value pairs of App Settings."
  default     = null
}

variable "client_affinity_enabled" {
  type        = any
  description = "Should Client Affinity be enabled?"
  default     = null

  #   validation {
  #     error_message = local.metadata.validator_error_messages.client_affinity_enabled
  #     condition = can(
  #       regex(
  #         local.metadata.validator_expressions.client_affinity_enabled,
  #         var.client_affinity_enabled
  #       )
  #     )
  #   }
}

variable "client_certificate_enabled" {
  type        = bool
  description = "Should Client Certificates be enabled?"
  default     = null

  #   validation {
  #     error_message = local.metadata.validator_error_messages.client_certificate_enabled
  #     condition = can(
  #       regex(
  #         local.metadata.validator_expressions.client_certificate_enabled,
  #         var.client_certificate_enabled
  #       )
  #     )
  #   }
}

variable "client_certificate_mode" {
  type        = string
  description = "The Client Certificate mode."
  default     = null

  #   validation {
  #     error_message = local.metadata.validator_error_messages.client_certificate_mode
  #     condition = can(
  #       regex(
  #         local.metadata.validator_expressions.client_certificate_mode,
  #         var.client_certificate_mode
  #       )
  #     )
  #   }
}

variable "client_certificate_exclusion_paths" {
  type        = string
  description = "Paths to exclude when using client certificates, separated by ;"
  default     = null
}

variable "enabled" {
  type        = bool
  description = "Should the Linux Web App be enabled?"
  default     = true

  validation {
    error_message = local.metadata.validator_error_messages.enabled
    condition = can(
      regex(
        local.metadata.validator_expressions.enabled,
        var.enabled
      )
    )
  }
}

variable "ftp_publish_basic_authentication_enabled" {
  type        = bool
  description = "Should the default FTP Basic Authentication publishing profile be enabled."
  default     = true

  validation {
    error_message = local.metadata.validator_error_messages.ftp_publish_basic_authentication_enabled
    condition = can(
      regex(
        local.metadata.validator_expressions.ftp_publish_basic_authentication_enabled,
        var.ftp_publish_basic_authentication_enabled
      )
    )
  }
}

variable "https_only" {
  type        = bool
  description = "Should the Linux Web App require HTTPS connections?"
  default     = null

  # validation {
  #   error_message = local.metadata.validator_error_messages.https_only
  #   condition = can(
  #     regex(
  #       local.metadata.validator_expressions.https_only,
  #       var.https_only
  #     )
  #   )
  # }
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Should public network access be enabled for the Web App?"
  default     = true

  validation {
    error_message = local.metadata.validator_error_messages.public_network_access_enabled
    condition = can(
      regex(
        local.metadata.validator_expressions.public_network_access_enabled,
        var.public_network_access_enabled
      )
    )
  }
}

variable "key_vault_reference_identity_id" {
  type        = string
  description = "The User Assigned Identity ID used for accessing KeyVault secrets."
  default     = null
}

variable "virtual_network_subnet_id" {
  type        = string
  description = "The subnet ID which will be used by this Web App for regional virtual network integration."
  default     = null
}

variable "webdeploy_publish_basic_authentication_enabled" {
  type        = bool
  description = "Should the default WebDeploy Basic Authentication publishing credentials enabled?"
  default     = true

  validation {
    error_message = local.metadata.validator_error_messages.webdeploy_publish_basic_authentication_enabled
    condition = can(
      regex(
        local.metadata.validator_expressions.webdeploy_publish_basic_authentication_enabled,
        var.webdeploy_publish_basic_authentication_enabled
      )
    )
  }
}

variable "zip_deploy_file" {
  type        = string
  description = "The local path and filename of the Zip packaged application to deploy to this Linux Web App."
  default     = null
}

variable "custom_domains" {
  type = list(object({
    hostname         = string
    certificate_name = string
    ssl_state        = optional(string)
  }))
  description = <<EOT
  Custom Hostname Binding on App Service

  hostname         = The Custom Hostname to use for the App Service.
  certificate_name = The name of the certificate that will be used to bind to the custom domain.
  ssl_state        = The type of certificate binding. Allowed values are IpBasedEnabled or SniEnabled.
  EOT
  default     = []
}

variable "app_service_vnet_integration_subnet_id" {
  type        = string
  description = "The ID of the subnet the App Service will be associated to (the subnet must have a service_delegation configured for Microsoft.Web/serverFarms)."
  default     = null
}

variable "additional_tags" {
  type        = map(string)
  description = "User-defined tags to associate with the resource."
  default     = {}
}

variable "timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  description = <<EOT
  The resource allows configurable timeouts for `create`, `read`, `update` and `delete` operations.

  create = Used when creating the resource. Defaults to 30 minutes.
  read   = Used when retrieving the resource. Defaults to 5 minutes.
  update = Used when updating the resource. Defaults to 30 minutes.
  delete = Used when deleting the resource. Defaults to 30 minutes.
  EOT
  default = ({
    create = "30m"
    read   = "5m"
    update = "30m"
    delete = "30m"
  })
}

variable "password_length" {
  type        = number
  description = "The password length."
  default     = 16

  validation {
    condition     = var.password_length > 0 && floor(var.password_length) == var.password_length
    error_message = "Err: The value must be a positive integer."
  }
}

variable "password_min_lower" {
  type        = number
  description = "Minimum number of lowercase alphabet characters in the password."
  default     = 4

  validation {
    condition     = var.password_min_lower > 0 && floor(var.password_min_lower) == var.password_min_lower
    error_message = "Err: The value must be a positive integer."
  }
}

variable "password_min_numeric" {
  type        = number
  description = "Minimum number of numeric characters in the password."
  default     = 4

  validation {
    condition     = var.password_min_numeric > 0 && floor(var.password_min_numeric) == var.password_min_numeric
    error_message = "Err: The value must be a positive integer."
  }
}

variable "password_min_upper" {
  type        = number
  description = "Minimum number of uppercase alphabet characters in the password."
  default     = 4

  validation {
    condition     = var.password_min_upper > 0 && floor(var.password_min_upper) == var.password_min_upper
    error_message = "Err: The value must be a positive integer."
  }
}