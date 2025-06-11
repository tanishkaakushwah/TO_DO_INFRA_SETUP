module "rg_module" {
  source = "../../module/azurerm_rg"
  resource_group_name     = "tanii_rg"
  resource_group_location = "centralindia"
}

module "vnet_module"{
  depends_on = [ module.rg_module ]
  source ="../../module/azurerm_vnet"
  vnet_name = "todo_vnet"
  location = "westus"
  resource_group_name = "tanii_rg"
}

module "subnet_module" {
  depends_on = [ module.vnet_module ]
  source = "../../module/azurerm_subnet"
  subnet_name = "frontend_subnet"
  vnet_name = "todo_vnet"
  resource_group_name = "tanii_rg"
  address_prefixes = ["10.0.1.0/24"]
}

module "pip_module" {
  depends_on = [ module.rg_module] 
  source = "../../module/azurerm_pip"
  pip_name = "todo_pip"
  resource_group_name = "tanii_rg"
  location = "westus"
}

module "nic_module" {
  # depends_on = [ module.subnet_module, module.pip_module ]
  source = "../../module/azurerm_nic"
  nic_name = "todo_nic"
  resource_group_name = "tanii_rg"
  location = "westus"
  subnet_id = module.subnet_module.subnet_id
  public_ip_address_id = module.pip_module.pip_id
}

module "vm_module" {
  depends_on = [ module.subnet_module, module.nic_module ]
  source = "../../module/azurerm_vm"
  vm_name = "todo-vm"
  resource_group_name = "tanii_rg"
  location = "westus"
  network_interface_ids = [module.nic_module.nic_id]
  publisher_id = "canonical"
  product_id = "0001-com-ubuntu-server-jammy"
  plan_id = "22_04-lts"
}

output "public_ip_address" {
  value = module.pip_module.ip_address
}







 


