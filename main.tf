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

# Provision the App Service plan to host the App Service web app in each region
# resource "azurerm_app_service_plan" "asp" {
#     count               = length(var.webapplocations)
#     name                = "${var.resource_prefix}-${var.webapplocations[count.index]}-asp"
#     location            = var.webapplocations[count.index]
#     resource_group_name = azurerm_resource_group.rg.name
#     kind                = "Windows"

#     sku {
#         tier = "Standard"
#         size = "S1"
#     }
# }

# # Provision the Azure App Service to host the main web site
# resource "azurerm_app_service" "webapp" {
#     count               = length(var.webapplocations)
#     name                = "${var.resource_prefix}-${var.webapplocations[count.index]}-webapp"
#     location            = var.webapplocations[count.index]
#     resource_group_name = azurerm_resource_group.rg.name
#     app_service_plan_id = azurerm_app_service_plan.asp[count.index].id

#     site_config {
#         always_on           = true
#         default_documents   = [
#             "Default.htm",
#             "Default.html",
#             "hostingstart.html"
#         ]
#     }

#     app_settings = {
#         "storageContainerName"          = ""
#         "connectionString "             = ""
#     }
# }

# resource "azurerm_storage_account" "storage" {
#     count                    = length(var.webapplocations)
#     name                     = replace(lower("${var.resource_prefix}-${var.webapplocations[count.index]}-sa"), "-", "")
#     location                 = var.webapplocations[count.index]
#     resource_group_name      = azurerm_resource_group.rg.name
#     account_tier             = "Standard"
#     account_replication_type = "LRS"
# }
resource "azurerm_storage_account" "storage2" {
    for_each = var.regionstest
    name                     = replace(lower("${var.resource_prefix}-${var.short_names[each.key]}-sa"), "-", "")
    location                 = each.value
    resource_group_name      = azurerm_resource_group.rg.name
    account_tier             = "Standard"
    account_replication_type = "LRS"
}
