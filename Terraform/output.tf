output "public_ip" {
  value = azurerm_public_ip.example.ip_address
}

output "frontdoor_endpoint" {
  value = azurerm_frontdoor.example.frontend_endpoint[0].host_name
}