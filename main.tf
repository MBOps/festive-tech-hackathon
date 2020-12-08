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
    kind                = "Windows"

    sku {
        tier = "Free"
        size = "F1"
    }
}

# Provision the Azure App Service to host the main web site
resource "azurerm_app_service" "webapp" {
    for_each = var.regionstest
    name                = "${var.resource_prefix}-${var.short_names[each.key]}-webapp"
    location            = each.value
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.asp[each.key].id

    # site_config {
        # always_on           = true
        # default_documents   = [
        #     "Default.htm",
        #     "Default.html",
        #     "hostingstart.html"
        # ]
    # }

    app_settings = {
        "storageContainerName"          = "${var.resource_prefix}-${var.short_names[each.key]}"
        "connectionString "             = "${azurerm_storage_account.storage[each.key].primary_connection_string}"
    }
    depends_on = [azurerm_storage_account.storage, azurerm_app_service_plan.asp]
    
}

resource "azurerm_storage_account" "storage" {
    for_each = var.regionstest
    name                     = replace(lower("${var.resource_prefix}-${var.short_names[each.key]}-sa"), "-", "")
    location                 = each.value
    resource_group_name      = azurerm_resource_group.rg.name
    account_tier             = "Standard"
    account_replication_type = "GRS"
}

resource "azurerm_frontdoor" "example" {
  name                                         = "${var.resource_prefix}-frontdoor"
  location                                     = azurerm_resource_group.rg.location
  resource_group_name                          = azurerm_resource_group.rg.name
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "exampleRoutingRule1"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["exampleFrontendEndpoint1"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "exampleBackendBing"
    }
  }

  backend_pool_load_balancing {
    name = "exampleLoadBalancingSettings1"
  }

  backend_pool_health_probe {
    name = "exampleHealthProbeSetting1"
  }

  backend_pool {
    name = "exampleBackendBing"
    backend {
      host_header = "www.bing.com"
      address     = "www.bing.com"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "exampleLoadBalancingSettings1"
    health_probe_name   = "exampleHealthProbeSetting1"
  }

  frontend_endpoint {
    name                              = "exampleFrontendEndpoint1"
    host_name                         = "example-FrontDoor.azurefd.net"
    custom_https_provisioning_enabled = false
  }
}
