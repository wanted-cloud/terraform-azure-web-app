locals {
  definitions = {
    tags = { ManagedBy = "Terraform" }

    validator_expressions = {
      default                                        = ".*"
      resource_tags                                  = "^[a-zA-Z0-9_\\-\\.]{1,512}$"
      location                                     = "^(southafricanorth|southafricawest|australiacentral|australiacentral2|australiaeast|australiasoutheast|centralindia|eastasia|japaneast|japanwest|jioindiacentral|jioindiawest|koreacentral|koreasouth|newzealandnorth|southindia|southeastasia|westindia|canadacentral|canadaeast|francecentral|francesouth|germanynorth|germanywestcentral|italynorth|northeurope|norwayeast|norwaywest|polandcentral|spaincentral|swedencentral|switzerlandnorth|switzerlandwest|uksouth|ukwest|westeurope|mexicocentral|israelcentral|qatarcentral|uaecentral|uaenorth|brazilsouth|brazilsoutheast|brazilus|centralus|centraluseuap|eastus|eastus2|eastus2euap|eastusstg|northcentralus|southcentralus|southcentralusstg|westcentralus|westus|westus2|westus3)$"
      timeout                                        = "^(create|read|update|delete)$"
      os_type                                        = "^(Windows|Linux|WindowsContainer)$"
      sku_name                                       = "^(B1|B2|B3|D1|F1|I1|I2|I3|I1v2|I2v2|I3v2|I4v2|I5v2|I6v2|P1v2|P2v2|P3v2|P0v3|P1v3|P2v3|P3v3|P1mv3|P2mv3|P3mv3|P4mv3|P5mv3|S1|S2|S3|SHARED|EP1|EP2|EP3|FC1|WS1|WS2|WS3|Y1)$"
      maximum_elastic_worker_count                   = "^[0-9]+$"
      worker_count                                   = "^[0-9]+$"
      per_site_scaling_enabled                       = "^(true|false)$"
      client_affinity_enabled                        = "^(true|false)$"
      client_certificate_enabled                     = "^(true|false)$"
      client_certificate_mode                        = "^(Required|Optional|OptionalInteractiveUser)$"
      enabled                                        = "^(true|false)$"
      ftp_publish_basic_authentication_enabled       = "^(true|false)$"
      https_only                                     = "^(true|false)$"
      public_network_access_enabled                  = "^(true|false)$"
      webdeploy_publish_basic_authentication_enabled = "^(true|false)$"

    }
    validator_error_messages = {
      default                                        = "Unknown error during validation has occured."
      resource_tags                                  = "Resource tag keys and values must follow Azure naming conventions."
      location                                       = "The location must be a valid Azure region."
      timeout                                        = "Timeout key must be one of create, read, update, or delete, and value must follow format like 30m, 1h etc."
      os_type                                        = "The os_type variable must be one of: Windows, Linux, or WindowsContainer."
      sku_name                                       = "The sku_name variable must be one of the allowed SKU values as per official documentation."
      maximum_elastic_worker_count                   = "The maximum_elastic_worker_count must be a non-negative integer."
      worker_count                                   = "The worker_count must be a non-negative integer."
      per_site_scaling_enabled                       = "The per_site_scaling_enabled variable must be true or false."
      client_affinity_enabled                        = "The client_affinity_enabled variable must be true or false."
      client_certificate_enabled                     = "The client_certificate_enabled variable must be true or false."
      client_certificate_mode                        = "The client_certificate_mode must be one of: Required, Optional, or OptionalInteractiveUser."
      enabled                                        = "Err: A boolean variable is restricted to true or false."
      ftp_publish_basic_authentication_enabled       = "Err: A boolean variable is restricted to true or false."
      https_only                                     = "Err: A boolean variable is restricted to true or false."
      public_network_access_enabled                  = "Err: A boolean variable is restricted to true or false."
      webdeploy_publish_basic_authentication_enabled = "Err: A boolean variable is restricted to true or false."

    }
  }
}