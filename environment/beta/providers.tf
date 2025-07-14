terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.32.0"
    }
  }
}

provider "azurerm" {
  features {}
  tenant_id = "c3a55f95-a381-4915-a75d-0bfb1f99b220"
  subscription_id = "c316f505-7597-4175-b5db-d2949009d506"
}