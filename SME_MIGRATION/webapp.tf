resource "azurerm_app_service_plan" "becsme" {  
  name                = "bcservice-plan"  
  location            = "uksouth"  
  resource_group_name = azurerm_resource_group.beaconsme_gp.name  
  
  sku {  
    tier = "Standard"  
    size = "S1"  
  }  
}  
  
resource "azurerm_app_service" "beaconsmeinc" {  
  name                = "BeaconSmeInc"  
  location            = "uksouth"  
  resource_group_name = azurerm_resource_group.beaconsme_gp.name  
  app_service_plan_id = azurerm_app_service_plan.becsme.id  
  https_only = false

resource "azurerm_application_insights" "beaconsmeinc" {
  name                = "beaconweb-appinsights"
  location            = azurerm_resource_group.beaconsme_gp.location
  resource_group_name = azurerm_resource_group.beaconsme_gp.name
  application_type    = "web"
}

  site_config {
    dotnet_framework_version = "v6.0"
    always_on                = false
    ftps_state               = "Disabled"
    min_tls_version          = "1.2"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2019"
  }

  source_control {
    repo_url           = "https://github.com/lukuki4/Beaconteqk"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }

  
  #backup {
    #name = "beacsmebackup"
    #storage_account_url = ""
    #schedule {
        #frequency_interval = 30
        #frequency_unit = [Days]
    #}
  #}

}