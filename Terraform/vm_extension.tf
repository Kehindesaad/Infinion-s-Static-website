resource "azurerm_virtual_machine_extension" "example" {
  name                 = "install-apache"
  virtual_machine_id   = azurerm_virtual_machine.example.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/<Your-Github-Username>/terraform-azure-vm/main/install_web_server.sh"],
        "commandToExecute": "./install_web_server.sh"
    }
SETTINGS
}