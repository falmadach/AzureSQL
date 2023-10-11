
/*resource "azurerm_resource_group" "falmada_rg" {
  name     = "rg-falmada"
  location = "West US"
}
*/

data "azurerm_resource_group" "rg" {
    name = "rg-falmada"
}
/*
resource "azurerm_storage_account" "stg_acc" {
  name                     = "accounthyperscale"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
} */

resource "azurerm_mssql_server" "az_sq_svr" {
  name                         = "ss-fernando-hs"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = data.azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "hyperscaledb"
  administrator_login_password = "XVncNG.~%Rd#8W;[YA"
}

resource "azurerm_mssql_database" "sqdb" {
  name           = "db-fernando-hs"
  server_id      = azurerm_mssql_server.az_sq_svr.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "HS_Gen5_2"
  zone_redundant = false
  tags = {
    environment = "sandbox"
  }
}
// Add Firewall Rule range
resource "azurerm_mssql_firewall_rule" "sqlfw" {
  name             = "zscaler1"
  server_id        = azurerm_mssql_server.az_sq_svr.id
  start_ip_address = "185.46.212.0"
  end_ip_address   = "185.46.215.255"
}

//Add Synapse SQL Pool

resource "azurerm_mssql_database" "sqlpool" {
  name           = "sample-synapse-sqlpool"
  server_id      = azurerm_mssql_server.az_sq_svr.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"    
  sku_name       = "DW100c"
  zone_redundant = false
  tags = {
    environment = "synapse"
  }
}

# resource "azurerm_synapse_sql_pool" "example" {
#   name                 = "sample-synapse-sqlpool"
#   synapse_workspace_id = azurerm_synapse_workspace.example.id
#   sku_name             = "DW100c"
#   create_mode          = "Default"
#   storage_account_type = "GRS"
# }