subnet_names = {
  "frontend_subnet" = "10.0.0.0/17",
  "backend_subnet"  = "10.0.128.0/17"
}

vm_config = {
  frontend-vm = {
    nic_name    = "frontend_nic",
    subnet_name = "frontend_subnet",
    pip_name    = "frontend_pip"
  },
  backend-vm = {
    nic_name    = "backend_nic",
    subnet_name = "backend_subnet",
    pip_name    = "backend_pip"
  }
}

pip_names = ["frontend_pip", "backend_pip"]

