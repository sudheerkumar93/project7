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
}

# Service Plan (must exist or be created)
resource "azurerm_service_plan" "plan" {
  name                = "sunny-service-plan"
  location            = "canadacentral"
  resource_group_name = "pipeline"   # existing RG
  os_type             = "Linux"
  sku_name            = "S1"
}

# Linux Web App
resource "azurerm_linux_web_app" "web" {
  name                = "sunny-web-app-jenkins-3"
  location            = "canadacentral"
  resource_group_name = "pipeline"   # existing RG
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    linux_fx_version = "JAVA|21"
  }
}

