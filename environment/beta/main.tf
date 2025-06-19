module "rg_module" {
  source                  = "../../module/azurerm_rg"
  resource_group_name     = "tanii_rg"
  resource_group_location = "centralindia"
}

module "kv_module" {
  depends_on          = [module.rg_module]
  source              = "../../module/azurerm_key_vault"
  kv_name             = "tani-kv"
  location            = "westus"
  resource_group_name = "tanii_rg"
  sku_name            = "standard"
}


module "vnet_module" {
  depends_on          = [module.rg_module]
  source              = "../../module/azurerm_vnet"
  vnet_name           = "todo_vnet"
  location            = "westus"
  resource_group_name = "tanii_rg"
}

module "f_subnet_module" {
  depends_on          = [module.vnet_module]
  source              = "../../module/azurerm_subnet"
  subnet_name         = "frontend_subnet"
  vnet_name           = "todo_vnet"
  resource_group_name = "tanii_rg"
  address_prefixes    = ["10.0.0.0/17"]
}
module "b_subnet_module" {
  depends_on          = [module.vnet_module]
  source              = "../../module/azurerm_subnet"
  subnet_name         = "backend_subnet"
  vnet_name           = "todo_vnet"
  resource_group_name = "tanii_rg"
  address_prefixes    = ["10.0.128.0/17"]
}

module "f_pip_module" {
  depends_on          = [module.rg_module]
  source              = "../../module/azurerm_pip"
  pip_name            = "f_todo_pip"
  resource_group_name = "tanii_rg"
  location            = "westus"
}

module "b_pip_module" {
  depends_on          = [module.rg_module]
  source              = "../../module/azurerm_pip"
  pip_name            = "b_todo_pip"
  resource_group_name = "tanii_rg"
  location            = "westus"
}

module "f_vm_module" {
  depends_on          = [module.f_subnet_module, module.kv_module]
  source              = "../../module/azurerm_vm"
  vm_name             = "f-todo-vm"
  resource_group_name = "tanii_rg"
  location            = "westus"
  nic_name            = "f_todo_nic"
  publisher_id        = "canonical"
  product_id          = "0001-com-ubuntu-server-jammy"
  plan_id             = "22_04-lts"
  subnet_name         = "frontend_subnet"
  vnet_name           = "todo_vnet"
  pip_name            = "f_todo_pip"
  kv_name             = "tani-kv"
}
module "b_vm_module" {
  depends_on          = [module.b_subnet_module, module.kv_module]
  source              = "../../module/azurerm_vm"
  vm_name             = "b-todo-vm"
  resource_group_name = "tanii_rg"
  location            = "westus"
  nic_name            = "b_todo_nic"
  publisher_id        = "canonical"
  product_id          = "0001-com-ubuntu-server-jammy"
  plan_id             = "22_04-lts"
  subnet_name         = "backend_subnet"
  vnet_name           = "todo_vnet"
  pip_name            = "b_todo_pip"
  kv_name             = "tani-kv"
}

module "db_server_module" {
  depends_on          = [module.rg_module, module.kv_module]
  source              = "../../module/azurerm_db_server"
  server_name         = "mera-db-server"
  resource_group_name = "tanii_rg"
  location            = "westus"
  admin_login         = "dbadmin"
  kv_name             = "tani-kv"
  }

module "db_module" {
  depends_on          = [module.db_server_module]
  source              = "../../module/azurerm_database"
  db_name             = "todo-db"
  server_name         = "mera-db-server"
  resource_group_name = "tanii_rg"
}