resource "random_pet" "app_prefix" {
    length = 3
    separator = ""
}

resource "azurerm_resource_group" "webapp_resource_group" {
  name     = "${random_pet.app_prefix.id}-rg"
  location = "East US 2"
}

resource "azurerm_storage_account" "webapp_storage_account" {
  name                     = "${random_pet.app_prefix.id}"
  resource_group_name      = azurerm_resource_group.webapp_resource_group.name
  location                 = azurerm_resource_group.webapp_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_service_plan" "webapp_service_plan" {
  name                = "${random_pet.app_prefix.id}-service-plan"
  resource_group_name = azurerm_resource_group.webapp_resource_group.name
  location            = azurerm_resource_group.webapp_resource_group.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "${random_pet.app_prefix.id}-app"
  resource_group_name = azurerm_resource_group.webapp_resource_group.name
  location            = azurerm_resource_group.webapp_resource_group.location
  service_plan_id     = azurerm_service_plan.webapp_service_plan.id

  site_config {}
}

output "hostname" {
  value = azurerm_linux_web_app.webapp.default_hostname
}
