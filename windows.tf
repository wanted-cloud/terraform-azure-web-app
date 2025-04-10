resource "azurerm_windows_web_app" "this" {
  count = lower(var.os_type) == "windows" ? 1 : 0

  name                                           = var.name
  resource_group_name                            = data.azurerm_resource_group.this.name
  location                                       = data.azurerm_resource_group.this.location
  service_plan_id     = var.service_plan_id != null ? var.service_plan_id : azurerm_service_plan.this[0].id
  client_affinity_enabled                        = var.client_affinity_enabled
  client_certificate_enabled                     = var.client_certificate_enabled
  client_certificate_mode                        = var.client_certificate_mode
  client_certificate_exclusion_paths             = var.client_certificate_exclusion_paths
  enabled                                        = var.enabled
  ftp_publish_basic_authentication_enabled       = var.ftp_publish_basic_authentication_enabled
  https_only                                     = var.https_only
  public_network_access_enabled                  = var.public_network_access_enabled
  key_vault_reference_identity_id                = var.key_vault_reference_identity_id
  virtual_network_subnet_id                      = var.virtual_network_subnet_id
  webdeploy_publish_basic_authentication_enabled = var.webdeploy_publish_basic_authentication_enabled
  zip_deploy_file                                = var.zip_deploy_file
  tags                                           = local.metadata.tags

  site_config {
    always_on                                     = var.site_config.always_on
    api_definition_url                            = var.site_config.api_definition_url
    api_management_api_id                         = var.site_config.api_management_api_id
    app_command_line                              = var.site_config.app_command_line
    container_registry_managed_identity_client_id = var.site_config.container_registry_managed_identity_client_id
    container_registry_use_managed_identity       = var.site_config.container_registry_use_managed_identity
    default_documents                             = var.site_config.default_documents
    ftps_state                                    = var.site_config.ftps_state
    health_check_path                             = var.site_config.health_check_path
    health_check_eviction_time_in_min             = var.site_config.health_check_eviction_time_in_min
    http2_enabled                                 = var.site_config.http2_enabled
    load_balancing_mode                           = var.site_config.load_balancing_mode
    local_mysql_enabled                           = var.site_config.local_mysql_enabled
    managed_pipeline_mode                         = var.site_config.managed_pipeline_mode
    minimum_tls_version                           = var.site_config.minimum_tls_version
    remote_debugging_enabled                      = var.site_config.remote_debugging_enabled
    remote_debugging_version                      = var.site_config.remote_debugging_version
    scm_minimum_tls_version                       = var.site_config.scm_minimum_tls_version
    scm_use_main_ip_restriction                   = var.site_config.scm_use_main_ip_restriction
    use_32_bit_worker                             = var.site_config.use_32_bit_worker
    vnet_route_all_enabled                        = var.site_config.vnet_route_all_enabled
    websockets_enabled                            = var.site_config.websockets_enabled
    worker_count                                  = var.site_config.worker_count

    dynamic "application_stack" {
      for_each = var.site_config.application_stack == null ? [] : [var.site_config.application_stack]

      content {
        current_stack                = application_stack.value.current_stack
        docker_image_name            = application_stack.value.docker_image_name
        docker_registry_url          = application_stack.value.docker_registry_url
        docker_registry_username     = application_stack.value.docker_registry_username
        docker_registry_password     = application_stack.value.docker_registry_password
        dotnet_version               = application_stack.value.dotnet_version
        dotnet_core_version          = application_stack.value.dotnet_core_version
        tomcat_version               = application_stack.value.tomcat_version
        java_embedded_server_enabled = application_stack.value.java_embedded_server_enabled
        java_version                 = application_stack.value.java_version
        node_version                 = application_stack.value.node_version
        php_version                  = application_stack.value.php_version
        python                       = application_stack.value.python
      }
    }

    dynamic "auto_heal_setting" {
      for_each = var.site_config.auto_heal_setting == null ? [] : [var.site_config.auto_heal_setting]

      content {
        dynamic "action" {
          for_each = auto_heal_setting.value.action == null ? [] : [auto_heal_setting.value.action]

          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = action.value.minimum_process_execution_time

            dynamic "custom_action" {
              for_each = action.value.custom_action == null ? [] : [action.value.custom_action]

              content {
                executable = custom_action.value.executable
                parameters = custom_action.value.parameters
              }
            }
          }
        }

        dynamic "trigger" {
          for_each = auto_heal_setting.value.trigger == null ? null : [auto_heal_setting.value.trigger]

          content {
            private_memory_kb = trigger.value.private_memory_kb

            dynamic "requests" {
              for_each = trigger.value.requests == null ? [] : trigger.value.requests

              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }

            dynamic "slow_request" {
              for_each = trigger.value.slow_request == null ? [] : trigger.value.slow_request

              content {
                count      = slow_request.value.count
                interval   = slow_request.value.interval
                time_taken = slow_request.value.time_taken
              }
            }

            dynamic "status_code" {
              for_each = trigger.value.status_code == null ? [] : trigger.value.status_code
              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = status_code.value.path
                sub_status        = status_code.value.sub_status
                win32_status_code = status_code.value.win32_status_code
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = var.site_config.cors == null ? [] : [var.site_config.cors]

      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = cors.value.support_credentials
      }
    }

    dynamic "ip_restriction" {
      for_each = var.site_config.ip_restriction == null ? [] : var.site_config.ip_restriction

      content {
        action = ip_restriction.value.action

        dynamic "headers" {
          for_each = ip_restriction.value.headers == null ? [] : [ip_restriction.value.headers]

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }

        ip_address                = ip_restriction.value.ip_address
        name                      = ip_restriction.value.name
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = var.site_config.scm_ip_restriction == null ? [] : var.site_config.scm_ip_restriction

      content {
        action = scm_ip_restriction.value.action

        dynamic "headers" {
          for_each = scm_ip_restriction.value.headers == null ? [] : [scm_ip_restriction.value.headers]

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }

        ip_address                = scm_ip_restriction.value.ip_address
        name                      = scm_ip_restriction.value.name
        priority                  = scm_ip_restriction.value.priority
        service_tag               = scm_ip_restriction.value.service_tag
        virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
      }
    }
  }

  dynamic "auth_settings" {
    for_each = var.auth_settings == null ? [] : [var.auth_settings]

    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = auth_settings.value.additional_login_parameters
      allowed_external_redirect_urls = auth_settings.value.allowed_external_redirect_urls
      default_provider               = auth_settings.value.default_provider
      issuer                         = auth_settings.value.issuer
      runtime_version                = auth_settings.value.runtime_version
      token_refresh_extension_hours  = auth_settings.value.token_refresh_extension_hours
      token_store_enabled            = auth_settings.value.token_store_enabled
      unauthenticated_client_action  = auth_settings.value.unauthenticated_client_action

      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory == null ? [] : [auth_settings.value.active_directory]

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.client_id
          client_secret              = active_directory.value.client_id
          client_secret_setting_name = active_directory.value.client_id
        }
      }

      dynamic "facebook" {
        for_each = auth_settings.value.facebook == null ? [] : [auth_settings.value.facebook]

        content {
          app_id                  = facebook.value.app_id
          app_secret              = facebook.value.app_secret
          app_secret_setting_name = facebook.value.app_secret_setting_name
          oauth_scopes            = facebook.value.oauth_scopes
        }
      }

      dynamic "github" {
        for_each = auth_settings.value.github == null ? [] : [auth_settings.value.github]

        content {
          client_id                  = github.value.client_id
          client_secret              = github.value.client_secret
          client_secret_setting_name = github.value.client_secret_setting_name
          oauth_scopes               = github.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = auth_settings.value.google == null ? [] : [auth_settings.value.google]

        content {
          client_id                  = google.value.client_id
          client_secret              = google.value.client_secret
          client_secret_setting_name = google.value.client_secret_setting_name
          oauth_scopes               = google.value.oauth_scopes
        }
      }

      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft == null ? [] : [auth_settings.value.microsoft]

        content {
          client_id                  = microsoft.value.client_id
          client_secret              = microsoft.value.client_secret
          client_secret_setting_name = microsoft.value.client_secret_setting_name
          oauth_scopes               = microsoft.value.oauth_scopes
        }
      }

      dynamic "twitter" {
        for_each = auth_settings.value.twitter == null ? [] : [auth_settings.value.twitter]

        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = twitter.value.consumer_secret
          consumer_secret_setting_name = twitter.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = var.auth_settings_v2 == null ? [] : [var.auth_settings_v2]

    content {
      auth_enabled                            = auth_settings_v2.value.auth_enabled
      runtime_version                         = auth_settings_v2.value.runtime_version
      config_file_path                        = auth_settings_v2.value.config_file_path
      require_authentication                  = auth_settings_v2.value.require_authentication
      unauthenticated_action                  = auth_settings_v2.value.unauthenticated_action
      default_provider                        = auth_settings_v2.value.default_provider
      excluded_paths                          = auth_settings_v2.value.excluded_paths
      require_https                           = auth_settings_v2.value.require_https
      http_route_api_prefix                   = auth_settings_v2.value.http_route_api_prefix
      forward_proxy_convention                = auth_settings_v2.value.forward_proxy_convention
      forward_proxy_custom_host_header_name   = auth_settings_v2.value.forward_proxy_custom_host_header_name
      forward_proxy_custom_scheme_header_name = auth_settings_v2.value.forward_proxy_custom_scheme_header_name

      dynamic "apple_v2" {
        for_each = auth_settings_v2.value.apple_v2 == null ? [] : [auth_settings_v2.value.apple_v2]

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes
        }
      }

      dynamic "active_directory_v2" {
        for_each = auth_settings_v2.value.active_directory_v2 == null ? [] : [auth_settings_v2.value.active_directory_v2]

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = active_directory_v2.value.client_secret_setting_name
          client_secret_certificate_thumbprint = active_directory_v2.value.client_secret_certificate_thumbprint
          jwt_allowed_groups                   = active_directory_v2.value.jwt_allowed_groups
          jwt_allowed_client_applications      = active_directory_v2.value.jwt_allowed_client_applications
          www_authentication_disabled          = active_directory_v2.value.www_authentication_disabled
          allowed_groups                       = active_directory_v2.value.allowed_groups
          allowed_identities                   = active_directory_v2.value.allowed_identities
          allowed_applications                 = active_directory_v2.value.allowed_applications
          login_parameters                     = active_directory_v2.value.login_parameters
          allowed_audiences                    = active_directory_v2.value.allowed_audiences
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = auth_settings_v2.value.azure_static_web_app_v2 == null ? [] : [auth_settings_v2.value.azure_static_web_app_v2]

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = auth_settings_v2.value.custom_oidc_v2 == null ? [] : [auth_settings_v2.value.custom_oidc_v2]

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = custom_oidc_v2.value.name_claim_type
          scopes                        = custom_oidc_v2.value.scopes
          client_credential_method      = custom_oidc_v2.value.client_credential_method
          client_secret_setting_name    = custom_oidc_v2.value.client_secret_setting_name
          authorisation_endpoint        = custom_oidc_v2.value.authorisation_endpoint
          token_endpoint                = custom_oidc_v2.value.token_endpoint
          issuer_endpoint               = custom_oidc_v2.value.issuer_endpoint
          certification_uri             = custom_oidc_v2.value.certification_uri
        }
      }

      dynamic "facebook_v2" {
        for_each = auth_settings_v2.value.facebook_v2 == null ? [] : [auth_settings_v2.value.facebook_v2]

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = facebook_v2.value.graph_api_version
          login_scopes            = facebook_v2.value.login_scopes
        }
      }

      dynamic "github_v2" {
        for_each = auth_settings_v2.value.github_v2 == null ? [] : [auth_settings_v2.value.github_v2]

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = github_v2.value.login_scopes
        }
      }

      dynamic "google_v2" {
        for_each = auth_settings_v2.value.google_v2 == null ? [] : [auth_settings_v2.value.google_v2]

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = google_v2.value.allowed_audiences
          login_scopes               = google_v2.value.login_scopes
        }
      }

      dynamic "microsoft_v2" {
        for_each = auth_settings_v2.value.microsoft_v2 == null ? [] : [auth_settings_v2.value.microsoft_v2]

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = microsoft_v2.value.allowed_audiences
          login_scopes               = microsoft_v2.value.login_scopes
        }
      }

      dynamic "twitter_v2" {
        for_each = auth_settings_v2.value.twitter_v2 == null ? [] : [auth_settings_v2.value.twitter_v2]

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }

      login {
        logout_endpoint                   = auth_settings_v2.value.login.logout_endpoint
        token_store_enabled               = auth_settings_v2.value.login.token_store_enabled
        token_refresh_extension_time      = auth_settings_v2.value.login.token_refresh_extension_time
        token_store_path                  = auth_settings_v2.value.login.token_store_path
        token_store_sas_setting_name      = auth_settings_v2.value.login.token_store_sas_setting_name
        preserve_url_fragments_for_logins = auth_settings_v2.value.login.preserve_url_fragments_for_logins
        allowed_external_redirect_urls    = auth_settings_v2.value.login.allowed_external_redirect_urls
        cookie_expiration_convention      = auth_settings_v2.value.login.cookie_expiration_convention
        cookie_expiration_time            = auth_settings_v2.value.login.cookie_expiration_time
        validate_nonce                    = auth_settings_v2.value.login.validate_nonce
        nonce_expiration_time             = auth_settings_v2.value.login.nonce_expiration_time
      }
    }
  }

  dynamic "backup" {
    for_each = var.backup == null ? [] : [var.backup]

    content {
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url
      enabled             = backup.value.enabled

      dynamic "schedule" {
        for_each = backup.value.schedule

        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = schedule.value.keep_at_least_one_backup
          retention_period_days    = schedule.value.retention_period_days
          start_time               = schedule.value.start_time
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings == null ? [] : var.connection_strings

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "logs" {
    for_each = var.logs == null ? [] : [var.logs]

    content {
      detailed_error_messages = logs.value.detailed_error_messages
      failed_request_tracing  = logs.value.failed_request_tracing

      dynamic "application_logs" {
        for_each = logs.value.application_logs == null ? [] : [logs.value.application_logs]

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage == null ? [] : [application_logs.value.azure_blob_storage]

            content {
              level             = azure_blob_storage.value.level
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = logs.value.http_logs == null ? [] : [logs.value.http_logs]

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage == null ? [] : [http_logs.value.azure_blob_storage]

            content {
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }

          dynamic "file_system" {
            for_each = http_logs.value.file_system

            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = var.storage_account == null ? [] : var.storage_account

    content {
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      name         = storage_account.value.name
      share_name   = storage_account.value.share_name
      type         = storage_account.value.type
      mount_path   = storage_account.value.mount_path
    }
  }

  dynamic "sticky_settings" {
    for_each = var.sticky_settings == null ? [] : [var.sticky_settings]

    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  lifecycle {
    precondition {
      condition     = var.site_config.application_stack.current_stack == null ? true : contains(["dotnet", "dotnetcore", "node", "python", "php", "java"], var.site_config.application_stack.current_stack)
      error_message = "Err: The Application Stack for the Windows Web App must be dotnet, dotnetcore, node, python, php, or java."
    }
    precondition {
      condition     = var.site_config.application_stack.dotnet_version == null ? true : contains(["v2.0", "v3.0", "v4.0", "v5.0", "v6.0", "v7.0", "v8.0"], var.site_config.application_stack.dotnet_version)
      error_message = "Err: The .NET version to use must be v2.0,v3.0, v4.0, v5.0, v6.0, v7.0 or v8.0."
    }

    precondition {
      condition     = var.site_config.application_stack.java_embedded_server_enabled == null ? true : can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.site_config.application_stack.java_embedded_server_enabled))
      error_message = "Err: A boolean variable is restricted to true or false."
    }

    precondition {
      condition     = var.site_config.application_stack.node_version == null ? true : contains(["~12", "~14", "~16", "~18"], var.site_config.application_stack.node_version)
      error_message = "Err: The Node version to use must be ~12, ~14, ~16, or ~18."
    }

    precondition {
      condition     = var.site_config.application_stack.php_version == null ? true : contains(["7.1", "7.4", "Off"], var.site_config.application_stack.php_version)
      error_message = "Err: The PHP version to use must be 7.1, 7.4 or Off."
    }

    precondition {
      condition     = var.site_config.application_stack.python == null ? true : can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.site_config.application_stack.python))
      error_message = "Err: A boolean variable is restricted to true or false."
    }

    precondition {
      condition     = try(var.site_config.auto_heal_setting == null || var.site_config.auto_heal_setting.action == null || contains(["Recycle", "LogEvent", "CustomAction"], var.site_config.auto_heal_setting.action.action_type), true)
      error_message = "Err: The predefined actions for an Auto Heal trigger include: Recycle, LogEvent, or CustomAction."
    }

    precondition {
      condition     = try(var.site_config.auto_heal_setting == null || var.site_config.auto_heal_setting.trigger == null || (var.site_config.auto_heal_setting.action.action_type >= 102400 && var.site_config.auto_heal_setting.action.action_type <= 13631488), true)
      error_message = "Err: The predefined actions for an Auto Heal trigger include: Recycle, LogEvent, or CustomAction."
    }

    precondition {
      condition     = try(var.auth_settings == null || contains(["AzureActiveDirectory", "Facebook", "Google", "MicrosoftAccount", "Twitter", "Github"], var.auth_settings.default_provider), true)
      error_message = "Err: The default authentication provider to use must be one of the following: AzureActiveDirectory, Facebook, Google, MicrosoftAccount, Twitter, Github."
    }

    precondition {
      condition     = try(var.auth_settings_v2 == null || (var.auth_settings_v2.unauthenticated_action == "RedirectToLoginPage" && contains(["apple", "azureactivedirectory", "facebook", "github", "google", "twitter", var.auth_settings_v2.custom_oidc_v2.name], var.auth_settings_v2.default_provider)), true)
      error_message = "Err: When the unauthenticated_action is set to RedirectToLoginPage, the Default Authentication Provider might be apple, azureactivedirectory, facebook, github, google, twitter, and the name of the custom_oidc_v2 provider."
    }
  }
}

resource "azurerm_windows_web_app_slot" "this" {
  for_each = { for slot in var.web_app_slots : slot.name => slot if lower(var.os_type) == "windows" }

  name                                           = each.value.name
  app_service_id                                 = azurerm_windows_web_app.this[0].id
  app_settings                                   = each.value.app_settings
  client_affinity_enabled                        = each.value.client_affinity_enabled
  client_certificate_enabled                     = each.value.client_certificate_enabled
  client_certificate_mode                        = each.value.client_certificate_mode
  client_certificate_exclusion_paths             = each.value.client_certificate_exclusion_paths
  enabled                                        = each.value.enabled
  ftp_publish_basic_authentication_enabled       = each.value.ftp_publish_basic_authentication_enabled
  https_only                                     = each.value.https_only
  public_network_access_enabled                  = each.value.public_network_access_enabled
  key_vault_reference_identity_id                = each.value.key_vault_reference_identity_id
  virtual_network_subnet_id                      = each.value.virtual_network_subnet_id
  webdeploy_publish_basic_authentication_enabled = each.value.webdeploy_publish_basic_authentication_enabled
  zip_deploy_file                                = each.value.zip_deploy_file
  tags                                           = local.metadata.tags

  site_config {
    always_on                                     = each.value.site_config.always_on
    api_definition_url                            = each.value.site_config.api_definition_url
    api_management_api_id                         = each.value.site_config.api_management_api_id
    app_command_line                              = each.value.site_config.app_command_line
    container_registry_managed_identity_client_id = each.value.site_config.container_registry_managed_identity_client_id
    container_registry_use_managed_identity       = each.value.site_config.container_registry_use_managed_identity
    default_documents                             = each.value.site_config.default_documents
    ftps_state                                    = each.value.site_config.ftps_state
    health_check_path                             = each.value.site_config.health_check_path
    health_check_eviction_time_in_min             = each.value.site_config.health_check_eviction_time_in_min
    http2_enabled                                 = each.value.site_config.http2_enabled
    load_balancing_mode                           = each.value.site_config.load_balancing_mode
    local_mysql_enabled                           = each.value.site_config.local_mysql_enabled
    managed_pipeline_mode                         = each.value.site_config.managed_pipeline_mode
    minimum_tls_version                           = each.value.site_config.minimum_tls_version
    remote_debugging_enabled                      = each.value.site_config.remote_debugging_enabled
    remote_debugging_version                      = each.value.site_config.remote_debugging_version
    scm_minimum_tls_version                       = each.value.site_config.scm_minimum_tls_version
    scm_use_main_ip_restriction                   = each.value.site_config.scm_use_main_ip_restriction
    use_32_bit_worker                             = each.value.site_config.use_32_bit_worker
    vnet_route_all_enabled                        = each.value.site_config.vnet_route_all_enabled
    websockets_enabled                            = each.value.site_config.websockets_enabled
    worker_count                                  = each.value.site_config.worker_count

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack == null ? [] : [each.value.site_config.application_stack]

      content {
        current_stack                = application_stack.value.current_stack
        docker_image_name            = application_stack.value.docker_image_name
        docker_registry_url          = application_stack.value.docker_registry_url
        docker_registry_username     = application_stack.value.docker_registry_username
        docker_registry_password     = application_stack.value.docker_registry_password
        dotnet_version               = application_stack.value.dotnet_version
        dotnet_core_version          = application_stack.value.dotnet_core_version
        tomcat_version               = application_stack.value.tomcat_version
        java_embedded_server_enabled = application_stack.value.java_embedded_server_enabled
        java_version                 = application_stack.value.java_version
        node_version                 = application_stack.value.node_version
        php_version                  = application_stack.value.php_version
        python                       = application_stack.value.python
      }
    }

    dynamic "auto_heal_setting" {
      for_each = each.value.site_config.auto_heal_setting == null ? [] : [each.value.site_config.auto_heal_setting]

      content {
        dynamic "action" {
          for_each = auto_heal_setting.value.action == null ? [] : [auto_heal_setting.value.action]

          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = action.value.minimum_process_execution_time
          }
        }

        dynamic "trigger" {
          for_each = auto_heal_setting.value.trigger == null ? null : [auto_heal_setting.value.trigger]

          content {
            private_memory_kb = trigger.value.private_memory_kb

            dynamic "requests" {
              for_each = trigger.value.requests == null ? [] : trigger.value.requests

              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }

            dynamic "slow_request" {
              for_each = trigger.value.slow_request == null ? [] : trigger.value.slow_request

              content {
                count      = slow_request.value.count
                interval   = slow_request.value.interval
                time_taken = slow_request.value.time_taken
              }
            }

            dynamic "status_code" {
              for_each = trigger.value.status_code == null ? [] : trigger.value.status_code
              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = status_code.value.path
                sub_status        = status_code.value.sub_status
                win32_status_code = status_code.value.win32_status_code
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = each.value.site_config.cors == null ? [] : [each.value.site_config.cors]

      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = cors.value.support_credentials
      }
    }

    dynamic "ip_restriction" {
      for_each = each.value.site_config.ip_restriction == null ? [] : each.value.site_config.ip_restriction

      content {
        action = ip_restriction.value.action

        dynamic "headers" {
          for_each = ip_restriction.value.headers == null ? [] : [ip_restriction.value.headers]

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }

        ip_address                = ip_restriction.value.ip_address
        name                      = ip_restriction.value.name
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = each.value.site_config.scm_ip_restriction == null ? [] : each.value.site_config.scm_ip_restriction

      content {
        action = scm_ip_restriction.value.action

        dynamic "headers" {
          for_each = scm_ip_restriction.value.headers == null ? [] : [scm_ip_restriction.value.headers]

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }

        ip_address                = scm_ip_restriction.value.ip_address
        name                      = scm_ip_restriction.value.name
        priority                  = scm_ip_restriction.value.priority
        service_tag               = scm_ip_restriction.value.service_tag
        virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
      }
    }
  }

  dynamic "auth_settings" {
    for_each = each.value.auth_settings == null ? [] : [var.auth_settings]

    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = auth_settings.value.additional_login_parameters
      allowed_external_redirect_urls = auth_settings.value.allowed_external_redirect_urls
      default_provider               = auth_settings.value.default_provider
      issuer                         = auth_settings.value.issuer
      runtime_version                = auth_settings.value.runtime_version
      token_refresh_extension_hours  = auth_settings.value.token_refresh_extension_hours
      token_store_enabled            = auth_settings.value.token_store_enabled
      unauthenticated_client_action  = auth_settings.value.unauthenticated_client_action

      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory == null ? [] : [auth_settings.value.active_directory]

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.client_id
          client_secret              = active_directory.value.client_id
          client_secret_setting_name = active_directory.value.client_id
        }
      }

      dynamic "facebook" {
        for_each = auth_settings.value.facebook == null ? [] : [auth_settings.value.facebook]

        content {
          app_id                  = facebook.value.app_id
          app_secret              = facebook.value.app_secret
          app_secret_setting_name = facebook.value.app_secret_setting_name
          oauth_scopes            = facebook.value.oauth_scopes
        }
      }

      dynamic "github" {
        for_each = auth_settings.value.github == null ? [] : [auth_settings.value.github]

        content {
          client_id                  = github.value.client_id
          client_secret              = github.value.client_secret
          client_secret_setting_name = github.value.client_secret_setting_name
          oauth_scopes               = github.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = auth_settings.value.google == null ? [] : [auth_settings.value.google]

        content {
          client_id                  = google.value.client_id
          client_secret              = google.value.client_secret
          client_secret_setting_name = google.value.client_secret_setting_name
          oauth_scopes               = google.value.oauth_scopes
        }
      }

      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft == null ? [] : [auth_settings.value.microsoft]

        content {
          client_id                  = microsoft.value.client_id
          client_secret              = microsoft.value.client_secret
          client_secret_setting_name = microsoft.value.client_secret_setting_name
          oauth_scopes               = microsoft.value.oauth_scopes
        }
      }

      dynamic "twitter" {
        for_each = auth_settings.value.twitter == null ? [] : [auth_settings.value.twitter]

        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = twitter.value.consumer_secret
          consumer_secret_setting_name = twitter.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = lookup(each.value.auth_settings_v2, "auth_enabled", false) ? [each.value.auth_settings_v2] : []

    content {
      auth_enabled                            = auth_settings_v2.value.auth_enabled
      runtime_version                         = auth_settings_v2.value.runtime_version
      config_file_path                        = auth_settings_v2.value.config_file_path
      require_authentication                  = auth_settings_v2.value.require_authentication
      unauthenticated_action                  = auth_settings_v2.value.unauthenticated_action
      default_provider                        = auth_settings_v2.value.default_provider
      excluded_paths                          = auth_settings_v2.value.excluded_paths
      require_https                           = auth_settings_v2.value.require_https
      http_route_api_prefix                   = auth_settings_v2.value.http_route_api_prefix
      forward_proxy_convention                = auth_settings_v2.value.forward_proxy_convention
      forward_proxy_custom_host_header_name   = auth_settings_v2.value.forward_proxy_custom_host_header_name
      forward_proxy_custom_scheme_header_name = auth_settings_v2.value.forward_proxy_custom_scheme_header_name

      dynamic "apple_v2" {
        for_each = auth_settings_v2.value.apple_v2 == null ? [] : [auth_settings_v2.value.apple_v2]

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes
        }
      }

      dynamic "active_directory_v2" {
        for_each = auth_settings_v2.value.active_directory_v2 == null ? [] : [auth_settings_v2.value.active_directory_v2]

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = active_directory_v2.value.client_secret_setting_name
          client_secret_certificate_thumbprint = active_directory_v2.value.client_secret_certificate_thumbprint
          jwt_allowed_groups                   = active_directory_v2.value.jwt_allowed_groups
          jwt_allowed_client_applications      = active_directory_v2.value.jwt_allowed_client_applications
          www_authentication_disabled          = active_directory_v2.value.www_authentication_disabled
          allowed_groups                       = active_directory_v2.value.allowed_groups
          allowed_identities                   = active_directory_v2.value.allowed_identities
          allowed_applications                 = active_directory_v2.value.allowed_applications
          login_parameters                     = active_directory_v2.value.login_parameters
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = auth_settings_v2.value.azure_static_web_app_v2 == null ? [] : [auth_settings_v2.value.azure_static_web_app_v2]

        content {
          client_id = lookup(azure_static_web_app_v2.value, "client_id", null)
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = auth_settings_v2.value.custom_oidc_v2 == null ? [] : [auth_settings_v2.value.custom_oidc_v2]

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = custom_oidc_v2.value.name_claim_type
          scopes                        = custom_oidc_v2.value.scopes
          client_credential_method      = custom_oidc_v2.value.client_credential_method
          client_secret_setting_name    = custom_oidc_v2.value.client_secret_setting_name
          authorisation_endpoint        = custom_oidc_v2.value.authorisation_endpoint
          token_endpoint                = custom_oidc_v2.value.token_endpoint
          issuer_endpoint               = custom_oidc_v2.value.issuer_endpoint
          certification_uri             = custom_oidc_v2.value.certification_uri
        }
      }

      dynamic "facebook_v2" {
        for_each = auth_settings_v2.value.facebook_v2 == null ? [] : [auth_settings_v2.value.facebook_v2]

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = facebook_v2.value.graph_api_version
          login_scopes            = facebook_v2.value.login_scopes
        }
      }

      dynamic "github_v2" {
        for_each = auth_settings_v2.value.github_v2 == null ? [] : [auth_settings_v2.value.github_v2]

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = github_v2.value.login_scopes
        }
      }

      dynamic "google_v2" {
        for_each = auth_settings_v2.value.google_v2 == null ? [] : [auth_settings_v2.value.google_v2]

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = google_v2.value.allowed_audiences
          login_scopes               = google_v2.value.login_scopes
        }
      }

      dynamic "microsoft_v2" {
        for_each = auth_settings_v2.value.microsoft_v2 == null ? [] : [auth_settings_v2.value.microsoft_v2]

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = microsoft_v2.value.allowed_audiences
          login_scopes               = microsoft_v2.value.login_scopes
        }
      }

      dynamic "twitter_v2" {
        for_each = auth_settings_v2.value.twitter_v2 == null ? [] : [auth_settings_v2.value.twitter_v2]

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }

      login {
        logout_endpoint                   = auth_settings_v2.value.login.logout_endpoint
        token_store_enabled               = auth_settings_v2.value.login.token_store_enabled
        token_refresh_extension_time      = auth_settings_v2.value.login.token_refresh_extension_time
        token_store_path                  = auth_settings_v2.value.login.token_store_path
        token_store_sas_setting_name      = auth_settings_v2.value.login.token_store_sas_setting_name
        preserve_url_fragments_for_logins = auth_settings_v2.value.login.preserve_url_fragments_for_logins
        allowed_external_redirect_urls    = auth_settings_v2.value.login.allowed_external_redirect_urls
        cookie_expiration_convention      = auth_settings_v2.value.login.cookie_expiration_convention
        cookie_expiration_time            = auth_settings_v2.value.login.cookie_expiration_time
        validate_nonce                    = auth_settings_v2.value.login.validate_nonce
        nonce_expiration_time             = auth_settings_v2.value.login.nonce_expiration_time
      }
    }
  }

  dynamic "backup" {
    for_each = each.value.backup == null ? [] : [each.value.backup]

    content {
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url
      enabled             = backup.value.enabled

      dynamic "schedule" {
        for_each = backup.value.schedule

        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = schedule.value.keep_at_least_one_backup
          retention_period_days    = schedule.value.retention_period_days
          start_time               = schedule.value.start_time
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = each.value.connection_strings == null ? [] : each.value.connection_strings

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "logs" {
    for_each = each.value.logs == null ? [] : [each.value.logs]

    content {
      detailed_error_messages = logs.value.detailed_error_messages
      failed_request_tracing  = logs.value.failed_request_tracing

      dynamic "application_logs" {
        for_each = logs.value.application_logs == null ? [] : [logs.value.application_logs]

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage == null ? [] : [application_logs.value.azure_blob_storage]

            content {
              level             = azure_blob_storage.value.level
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = logs.value.http_logs == null ? [] : [logs.value.http_logs]

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage == null ? [] : [http_logs.value.azure_blob_storage]

            content {
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }

          dynamic "file_system" {
            for_each = http_logs.value.file_system

            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = each.value.storage_account == null ? [] : each.value.storage_account

    content {
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      name         = storage_account.value.name
      share_name   = storage_account.value.share_name
      type         = storage_account.value.type
      mount_path   = storage_account.value.mount_path
    }
  }

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}