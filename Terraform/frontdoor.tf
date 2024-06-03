data "azurerm_resource_group" "kehinderg" {
  name     = "kehinderg"
  location = "East US"
}

resource "azurerm_frontdoor" "DemoFD" {
  name                = "DemoFD"
  resource_group_name = azurerm_resource_group.kehinderg.name

  routing_rule {
    name               = "exampleRoutingRule1"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["exampleFrontendEndpoint1"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "exampleBackendBing"
    }
  }

  backend_pool_load_balancing {
    name = "exampleLoadBalancingSettings1"
  }

  backend_pool_health_probe {
    name = "exampleHealthProbeSetting1"
  }

  backend_pool {
    name = "exampleBackendBing"
    backend {
      host_header = azurerm_public_ip.Demo-IP.ip_address
      address     = azurerm_public_ip.Demo-IP.ip_address
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "exampleLoadBalancingSettings1"
    health_probe_name   = "exampleHealthProbeSetting1"
  }

  frontend_endpoint {
    name      = "exampleFrontendEndpoint1"
    host_name = "${azurerm_frontdoor.DemoFD.name}.azurefd.net"
  }
}