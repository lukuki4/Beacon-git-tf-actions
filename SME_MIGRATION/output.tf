# output "resource_group_id" {
#   value = azurerm_resource_group.rg.id
# }

# output "vm_ids" {
#   description = "Virtual machine ids created."
#   value       = concat(azurerm_virtual_machine.vm-windows.*.id, azurerm_virtual_machine.vm-linux.*.id)
# }

# output "network_interface_ids" {
#   description = "ids of the vm nics provisoned."
#   value       = azurerm_network_interface.vm.*.id
# }