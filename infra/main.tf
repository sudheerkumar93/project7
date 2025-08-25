terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "75279c7b-6f2e-4e76-ae48-b6aeab569b34"
  tenant_id       = "766ef0d9-c1c7-4a7f-93ca-5e74124c5fc9"
  client_id       = "7b66f0b0-c43e-4682-9024-666bf29bda03"
  client_secret   = "cnE8Q~eYwUibzVv7llCNXxM8IgR_LQbmw2fj2csF"
}

# Service Plan (must exist or be created)
resource "azurerm_service_plan" "plan" {
  name                = "sunny-service-plan"
  location            = "canadacentral"
  resource_group_name = "pipeline"    # existing RG
  os_type             = "Linux"
  sku_name            = "S1"
}

# Linux Web App
resource "azurerm_linux_web_app" "web" {
  name                = "sunny-web-app-jenkins-3"
  location            = "canadacentral"
  resource_group_name = "pipeline"    # existing RG
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {} # Removed the linux_fx_version as it's auto-configured
}

