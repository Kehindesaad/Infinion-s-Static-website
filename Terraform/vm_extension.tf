resource "azurerm_virtual_machine_extension" "install-apache" {
  name                 = "install-apache"
  virtual_machine_id   = azurerm_virtual_machine.install-apache.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/Kehindesaad/Infinion-s-Static-website/main/Terraform/web_install.sh"],
        "commandToExecute": "./web_install.sh"
    }
SETTINGS
}