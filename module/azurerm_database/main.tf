data "azurerm_mssql_server" "server_data" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_mssql_database" "db_block" {
  name      = var.db_name
  server_id = data.azurerm_mssql_server.server_data.id
}

variable "db_name" {}
variable "server_name" {}
variable "resource_group_name" {}