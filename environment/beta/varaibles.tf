variable "rg_name"{
    default = "tanii_rg"
}
variable "rg_location" {
  default = "centralindia"
}
variable "vnet_name" {
  default = "todo_vnet"
}
variable "vnet_location" {
  default = "westus"
}
variable "f_subnet_name" {
  default = "frontend_subnet"
}
variable "b_subnet_name" {
  default = "backend_subnet"
}
variable "pip_name" {
  default = "todo_pip" 
}
# variable "pip_location" {
#   default = "westus"
# }
variable "nic_name" {
  default = "todo_nic"
}
variable "vm_name" {
  default = "todo-vm"     
}
variable "publisher_id" {
  default = "canonical"
}
variable "product_id" {
  default = "0001-com-ubuntu-server-jammy"
}
variable "plan_id" {
  default = "22_04-lts"
}
variable "db_server_name" {
  default = "mera-db-server"
}
variable "db_name" {
  default = "todo-db"
}