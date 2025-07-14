variable "rg_name" {
  default = "taani_rg"
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
variable "kv_name" {
  default = "taani-kv"
}
variable "kv_sku" {
  default = "standard"
}

variable "kv_location" {
  default = "centralus"
}

variable "nsg_name" {
  default = "frontend-nsg"
}
variable "db_server_location" {
  default = "centralindia"
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
  default = "mera-db-server79"
}
variable "db_name" {
  default = "todo-db"
}
variable "subnet_names" {
  type = map(string)
}

variable "pip_names" {
  type = set(string)
}

variable "vm_config" {
  type = map(object({
    nic_name    = string
    subnet_name = string
    pip_name    = string
  }))
}
