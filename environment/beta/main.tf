module "rg_module" {
  source                  = "../../module/azurerm_rg"
  resource_group_name     = var.rg_name
  resource_group_location = var.rg_location
}

module "kv_module" {
  depends_on          = [module.rg_module]
  source              = "../../module/azurerm_key_vault"
  kv_name             = var.kv_name
  location            = var.kv_location
  resource_group_name = var.rg_name
  sku_name            = var.kv_sku
}

module "pip_module" {
  depends_on          = [module.rg_module]
  for_each            = var.pip_names
  source              = "../../module/azurerm_pip"
  pip_name            = each.value
  resource_group_name = var.rg_name
  location            = var.vnet_location
}

module "vnet_module" {
  depends_on          = [module.rg_module]
  source              = "../../module/azurerm_vnet"
  vnet_name           = var.vnet_name
  location            = var.vnet_location
  resource_group_name = var.rg_name
}

module "subnet_module" {
  depends_on          = [module.vnet_module]
  for_each            = var.subnet_names
  source              = "../../module/azurerm_subnet"
  subnet_name         = each.key
  vnet_name           = var.vnet_name
  resource_group_name = var.rg_name
  address_prefixes    = [each.value]
}

module "vm_module" {
  depends_on          = [module.subnet_module, module.kv_module]
  for_each            = var.vm_config
  source              = "../../module/azurerm_vm"
  nsg_name            = var.nsg_name
  vm_name             = each.key
  resource_group_name = var.rg_name
  location            = var.vnet_location
  nic_name            = each.value.nic_name
  publisher_id        = var.publisher_id
  product_id          = var.product_id
  plan_id             = var.plan_id
  subnet_name         = each.value.subnet_name
  vnet_name           = var.vnet_name
  pip_name            = each.value.pip_name
  kv_name             = var.kv_name
}

module "db_server_module" {
  depends_on          = [module.rg_module, module.kv_module]
  source              = "../../module/azurerm_db_server"
  server_name         = var.db_server_name
  resource_group_name = var.rg_name
  location            = var.db_server_location
  admin_login         = "dbadmin"
  kv_name             = var.kv_name
}

module "db_module" {
  depends_on          = [module.db_server_module]
  source              = "../../module/azurerm_database"
  db_name             = var.db_name
  server_name         = var.db_server_name
  resource_group_name = var.rg_name
}