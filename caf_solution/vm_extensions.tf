#
# microsoft_enterprise_cloud_monitoring - Install the monitoring agent in the virtual machine
#



module "vm_extension_microsoft_azure_domainjoin" {
  # source  = "aztfmod/caf/azurerm//modules/compute/virtual_machine_extensions"
  # version = "5.5.5"

  source = "git::https://github.com/aztfmod/terraform-azurerm-caf.git//modules/compute/virtual_machine_extensions?ref=main"

  depends_on = [module.solution]

  for_each = {
    for key, value in try(var.virtual_machines, {}) : key => value
    if try(value.virtual_machine_extensions.microsoft_azure_domainjoin, null) != null
  }

  client_config      = module.solution.client_config
  virtual_machine_id = module.solution.virtual_machines[each.key].id
  extension          = each.value.virtual_machine_extensions.microsoft_azure_domainjoin
  extension_name     = "microsoft_azure_domainJoin"
  keyvaults          = merge(tomap({ (var.landingzone.key) = module.solution.keyvaults }), try(local.remote.keyvaults, {}))
}

