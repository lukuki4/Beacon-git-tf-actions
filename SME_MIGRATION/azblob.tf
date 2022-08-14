resource "azurerm_storage_account" "becstorage" {
  name                     = "bcsmestorage"
  resource_group_name      = azurerm_resource_group.beaconsmes_gp.name
  location                 = azurerm_resource_group.beaconsmes_gp.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "becstorage" {
  name                  = "beaconsme-storage"
  storage_account_name  = azurerm_storage_account.becstorage.name
  container_access_type = "private"
}

#resource "azurerm_storage_blob" "migration" {
  #name                   = "my-awesome-content.zip"
  #storage_account_name   = azurerm_storage_account.becstorage.name
  #storage_container_name = azurerm_storage_container.becstorage.name
  #type                   = "Block"
  #source                 = "some-local-file.zip"
#}