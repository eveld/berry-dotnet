service {
  name = "#{{ .Vars.service_name}}"
  id = "#{{ .Vars.service_id}}"
  port = #{{ .Vars.service_port}}

  connect { 
    sidecar_service {
      proxy {
      }
    }
  }
}