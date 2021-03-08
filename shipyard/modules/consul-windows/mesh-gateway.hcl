// // Generate the mesh gateway config.
template "gateway_config" {
  source = file("${file_dir()}/config/envoy-bootstrap.json")
  destination = "${data("envoy/config")}/mesh-gateway.json"

  vars = {
    service_name = "mesh-gateway"
    service_id = "mesh-gateway-windows"
    envoy_admin_port = 19010
  }
}

template "gateway_service" {
  source = <<EOF
service {
  name = "mesh-gateway"
  id = "mesh-gateway-windows"
  port = 8443
  kind = "mesh-gateway"

  proxy {
    mesh_gateway {
      mode = "remote"
    }
    expose {}
  }
}
EOF
  destination = "${data("consul/config")}/gateway.hcl"
}

//
// Run the Mesh Gateway.
//
exec_local "gateway_proxy" {
  depends_on = ["exec_local.install"]
  
  cmd = "${file_dir()}/binaries/envoy.exe"
  args = [
    "-c",
    "${data("envoy/config")}/mesh-gateway.json",
    "--bootstrap-version",
    "2"
  ]
  daemon = true
  working_directory = "${file_dir()}"

  env_var = {
    Temp = env("Temp")
  }
}