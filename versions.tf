/**
 * Created by WANTED.solutions s.r.o.
 */
terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.20.0"
    }
  }

  
}