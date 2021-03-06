locals {
  allregions = flatten([
    for geo_key, geo in var.geographies : [
      for region_key, region in geo.regions : {
        region_key = region_key
        name       = region.name
        shortname  = region.shortname
        tag        = region.tag
      }
    ]

  ])
}

terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform"
    storage_account_name = "mbopsterraformstorage"
    container_name       = "tfstate"
    key                  = "festive.terraform.tfstate"
  }
}

provider "azurerm" {
  version         = ">=2.39.0"
  subscription_id = var.subscription_id
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}-rg"
  location = var.rglocation

  tags = {
    environment = "Production"
    project     = var.resource_prefix
    region      = var.rglocation
  }

}

# Provision the App Service plan to host the App Service web app in each region
resource "azurerm_app_service_plan" "asp" {
  for_each            = { for region in local.allregions : region.region_key => region }
  name                = "${var.resource_prefix}-${each.value.shortname}-asp"
  location            = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {
    environment = "Production"
    project     = var.resource_prefix
    region      = each.value.name
  }
}

resource "azurerm_monitor_autoscale_setting" "autoscaling" {
  for_each            = { for region in local.allregions : region.region_key => region }
  name                = "${var.resource_prefix}-${each.value.shortname}-scaling"
  location            = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  target_resource_id  = azurerm_app_service_plan.asp[each.key].id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CPUPercentage"
        metric_resource_id = azurerm_app_service_plan.asp[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CPUPercentage"
        metric_resource_id = azurerm_app_service_plan.asp[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
    }
  }
  depends_on = [azurerm_app_service_plan.asp]
}

# resource "azurerm_virtual_network" "vnet" {
#   for_each            = { for region in local.allregions : region.region_key => region }
#   name                = "${var.resource_prefix}-${each.value.shortname}-vnet"
#   location            = each.value.name
#   resource_group_name = azurerm_resource_group.rg.name
#   address_space       = ["10.1.1.0/24"]
#   tags = {
#     environment = "Production"
#     project     = var.resource_prefix
#     region      = each.value.name
#   }
# }

# resource "azurerm_subnet" "internal" {
#   for_each             = { for region in local.allregions : region.region_key => region }
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet[each.key].name
#   address_prefixes     = ["10.1.1.0/24"]
#   service_endpoints    = ["Microsoft.Storage"]
#   depends_on           = [azurerm_virtual_network.vnet]
# }

# Provision the Azure Storage Account 
resource "azurerm_storage_account" "storage" {
  for_each = { for region in local.allregions : region.region_key => region }
  #for_each                 = var.regions
  name                     = replace(lower("${var.resource_prefix}-${each.value.shortname}-sa"), "-", "")
  location                 = each.value.name
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false
  #   network_rules {
  #     default_action             = "Deny"
  #     virtual_network_subnet_ids = [azurerm_subnet.internal[each.key].id]
  #   }

  tags = {
    environment = "Production"
    project     = var.resource_prefix
    region      = each.value.name
  }

  #   depends_on = [azurerm_subnet.internal]
}

resource "azurerm_app_service" "webapp" {
  for_each            = { for region in local.allregions : region.region_key => region }
  name                = "${var.resource_prefix}-${each.value.shortname}-webapp"
  location            = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp[each.key].id

  # Do not attach Storage by default
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    "storageContainerName"              = "${var.resource_prefix}-${each.value.shortname}"
    "connectionString"                  = "${azurerm_storage_account.storage[each.key].primary_connection_string}"

    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = "https://${var.registry_name}"
    DOCKER_REGISTRY_SERVER_USERNAME = "${var.admin_username}"
    DOCKER_REGISTRY_SERVER_PASSWORD = "${var.admin_password}"
  }

  # Configure Docker Image to load on start
  site_config {
    linux_fx_version = "DOCKER|${var.registry_name}/festive-tech:${each.value.tag != "" ? each.value.tag : var.tag_name}"
    always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Production"
    project     = var.resource_prefix
    region      = each.value.name
  }

  depends_on = [azurerm_storage_account.storage, azurerm_app_service_plan.asp]
}
# Provision the Azure FrontDoor
resource "azurerm_frontdoor" "frontdoor" {
  for_each                                     = var.geographies #{ for geo in var.geos : geo.name => geo }
  name                                         = "${var.resource_prefix}-${each.key}-frontdoor"
  resource_group_name                          = azurerm_resource_group.rg.name
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "${var.resource_prefix}-${each.key}-RoutingRule1"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["${var.resource_prefix}-${each.key}-FrontendEndpoint1"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "${var.resource_prefix}-${each.key}-Backend"
    }
  }

  backend_pool_load_balancing {
    name = "${var.resource_prefix}-${each.key}-LoadBalancingSettings1"
  }

  backend_pool_health_probe {
    name = "${var.resource_prefix}-${each.key}-HealthProbeSetting1"
  }

  backend_pool {
    name = "${var.resource_prefix}-${each.key}-Backend"

    dynamic "backend" {
      for_each = each.value.regions

      content {
        host_header = "${var.resource_prefix}-${backend.value.shortname}.azurewebsites.net"
        address     = "${var.resource_prefix}-${backend.value.shortname}.azurewebsites.net"
        http_port   = 80
        https_port  = 443
      }
    }

    load_balancing_name = "${var.resource_prefix}-${each.key}-LoadBalancingSettings1"
    health_probe_name   = "${var.resource_prefix}-${each.key}-HealthProbeSetting1"
  }

  frontend_endpoint {
    name                              = "${var.resource_prefix}-${each.key}-FrontendEndpoint1"
    host_name                         = "${var.resource_prefix}-${each.key}-frontdoor.azurefd.net"
    custom_https_provisioning_enabled = false
  }
  depends_on = [azurerm_app_service.webapp]

  tags = {
    environment = "Production"
    project     = var.resource_prefix
    region      = each.value.name
  }
}

# resource "azurerm_app_service_virtual_network_swift_connection" "vnetconnection" {
#   for_each       = { for region in local.allregions : region.region_key => region }
#   app_service_id = azurerm_app_service.webapp[each.key].id
#   subnet_id      = azurerm_subnet.internal[each.key].id
#   depends_on     = [azurerm_subnet.internal, azurerm_app_service.webapp]
# }