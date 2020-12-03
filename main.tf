# Deploy sample app on Azure App Services in a standalone manner, no database required.
terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform"
    storage_account_name = "mbopsterraformstorage"
    container_name       = "tfstate"
    key                  = "festive.terraform.tfstate"
  }
}
# Configure the AzureRM provider (using v2.1)
provider "azurerm" {
    version         = "~>2.14.0"
    subscription_id = var.subscription_id
    features {}
}

# Provision a resource group to hold all Azure resources
resource "azurerm_resource_group" "rg" {
    name            = "${var.resource_prefix}-RG"
    location        = var.rglocation
}

# Provision the App Service plan to host the App Service web app
resource "azurerm_app_service_plan" "asp" {
    name                = "${var.resource_prefix}-asp"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    kind                = "Windows"

    sku {
        tier = "Free"
        size = "F1"
    }
}

# Provision the Azure App Service to host the main web site
resource "azurerm_app_service" "webapp" {
    name                = "${var.resource_prefix}-webapp"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.asp.id

    site_config {
        #always_on           = true
        default_documents   = [
            "Default.htm",
            "Default.html",
            "hostingstart.html"
        ]
    }

    app_settings = {
        "storageContainerName"          = ""
        "connectionString "             = ""
    }
}

resource "azurerm_storage_account" "storage" {
  name                     = replace(lower("${var.resource_prefix}-storage"), "-", "")
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


