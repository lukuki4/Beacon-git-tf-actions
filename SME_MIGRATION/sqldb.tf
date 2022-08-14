resource "azurerm_mssql_server" "bcmssqlserver" {
  name                         = "bcmssqlserver"
  resource_group_name          = azurerm_resource_group.beaconsmes_gp.name
  location                     = azurerm_resource_group.beaconsmes_gp.location
  version                      = "12.0"
  administrator_login          = "beacon-2022server"
  administrator_login_password = "randomnot?43!2random@"
  public_network_access_enabled = true

  tags = {
    environment = "bcmigplan"
  }
}


resource "azurerm_subnet" "db_subnet" {
    name = "db_subnet"
    resource_group_name     = azurerm_resource_group.beaconsmes_gp.name
    virtual_network_name    = azurerm_virtual_network.main.name
    address_prefixes        = ["10.0.3.0/24"]
    enforce_private_link_endpoint_network_policies      = true
  
}

#resource "azurerm_mssql_elasticpool" "example" {
 # name                = "test-epool"
 # resource_group_name = azurerm_resource_group.example.name
  #location            = azurerm_resource_group.example.location
  #server_name         = azurerm_mssql_server.example.name
  #max_size_gb         = 50

  #sku {
   # name     = "StandardPool"
    #tier     = "Standard"
    #family   = null
    #capacity = 50
  #}

  #per_database_settings {
  #  min_capacity = 0
   # max_capacity = 10
#  }
#}


resource "azurerm_mssql_database" "tryout" {
  name           = "acctest-db-d"
  server_id      = azurerm_mssql_server.bcmssqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 5
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    Company = "beacon"
  }
}
