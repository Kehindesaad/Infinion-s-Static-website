output "public_ip" {
  value = azurerm_public_ip.Demo-IP.ip_address
}

output "frontdoor_endpoint" {
  value = azurerm_frontdoor.DemoFD.frontend_endpoint[0].host_name
}