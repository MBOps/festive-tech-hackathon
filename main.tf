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
    name            = "${var.resource_prefix}-rg"
    location        = var.rglocation
}

# Provision the App Service plan to host the App Service web app in each region
resource "azurerm_app_service_plan" "asp" {
    for_each = var.regionstest
    name                = "${var.resource_prefix}-${var.short_names[each.key]}-asp"
    location            = each.value
    resource_group_name = azurerm_resource_group.rg.name
    kind                = "Linux"
    reserved            = true
    sku {
        tier = "Basic"
        size = "B1"
    }
}

# Provision the Azure App Service to host the Website
# resource "azurerm_app_service" "webapp" {
#     for_each = var.regionstest
#     name                = "${var.resource_prefix}-${var.short_names[each.key]}-webapp"
#     location            = each.value
#     resource_group_name = azurerm_resource_group.rg.name
#     app_service_plan_id = azurerm_app_service_plan.asp[each.key].id

#     # site_config {
#         # always_on           = true
#         # default_documents   = [
#         #     "Default.htm",
#         #     "Default.html",
#         #     "hostingstart.html"
#         # ]
#     # }

#     app_settings = {
#         "storageContainerName"          = "${var.resource_prefix}-${var.short_names[each.key]}"
#         "connectionString "             = "${azurerm_storage_account.storage[each.key].primary_connection_string}"
#     }
#     depends_on = [azurerm_storage_account.storage, azurerm_app_service_plan.asp]
    
# }

# Provision the Azure Storage Account 
resource "azurerm_storage_account" "storage" {
    for_each = var.regionstest
    name                     = replace(lower("${var.resource_prefix}-${var.short_names[each.key]}-sa"), "-", "")
    location                 = each.value
    resource_group_name      = azurerm_resource_group.rg.name
    account_tier             = "Standard"
    account_replication_type = "GRS"
}

# Provision the Azure FrontDoor
# resource "azurerm_frontdoor" "frontdoor" {
#   name                                         = "${var.resource_prefix}-frontdoor"
#   resource_group_name                          = azurerm_resource_group.rg.name
#   enforce_backend_pools_certificate_name_check = false

#   routing_rule {
#     name               = "${var.resource_prefix}-RoutingRule1"
#     accepted_protocols = ["Http", "Https"]
#     patterns_to_match  = ["/*"]
#     frontend_endpoints = ["${var.resource_prefix}-FrontendEndpoint1"]
#     forwarding_configuration {
#       forwarding_protocol = "MatchRequest"
#       backend_pool_name   = "${var.resource_prefix}-Backend"
#     }
#   }

#   backend_pool_load_balancing {
#     name = "${var.resource_prefix}-LoadBalancingSettings1"
#   }

#   backend_pool_health_probe {
#     name = "${var.resource_prefix}-HealthProbeSetting1"
#   }

#   backend_pool {
#     name = "${var.resource_prefix}-Backend"
    
#     dynamic backend {
#       for_each = var.regionstest

#       content {
#         host_header = "${var.resource_prefix}-${var.short_names[backend.key]}-webapp.azurewebsites.net"
#         address     = "${var.resource_prefix}-${var.short_names[backend.key]}-webapp.azurewebsites.net"
#         http_port   = 80
#         https_port  = 443
#       }
#     }

#     load_balancing_name = "${var.resource_prefix}-LoadBalancingSettings1"
#     health_probe_name   = "${var.resource_prefix}-HealthProbeSetting1"
#   }

#   frontend_endpoint {
#     name                              = "${var.resource_prefix}-FrontendEndpoint1"
#     host_name                         = "${var.resource_prefix}-frontdoor.azurefd.net"
#     custom_https_provisioning_enabled = false
#   }
# #   frontend_endpoint {
# #     name                              = "${var.resource_prefix}-FrontendEndpoint2"
# #     host_name                         = "${var.resource_prefix}.com"
# #     custom_https_provisioning_enabled = false
# #   }
#   depends_on = [azurerm_app_service.webapp]
# }

resource "azurerm_app_service" "dockerapp" {
  for_each = var.regionstest
  name                = "${var.resource_prefix}-${var.short_names[each.key]}-dockerapp"
  location            = each.value
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp[each.key].id

  # Do not attach Storage by default
  app_settings = {
    #WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    # "storageContainerName"          = "${var.resource_prefix}-${var.short_names[each.key]}"
    # "connectionString "             = "${azurerm_storage_account.storage[each.key].primary_connection_string}"

    /*
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = ""
    DOCKER_REGISTRY_SERVER_USERNAME = ""
    DOCKER_REGISTRY_SERVER_PASSWORD = ""
    */
  }

  # Configure Docker Image to load on start
  site_config {
    # linux_fx_version = "DOCKER|appsvcsample/static-site:latest"
    # always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
  
  depends_on = [azurerm_storage_account.storage, azurerm_app_service_plan.asp]
}