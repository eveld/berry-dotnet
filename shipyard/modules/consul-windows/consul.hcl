// Generate the Consul server config.
template "consul_config" {
  source = file("${file_dir()}/config/consul-server.hcl")
  destination = "${data("consul/config")}/server.hcl"

  vars = {
    data_dir = data("consul/data")
  }
}

//
// Run the Consul server.
//
exec_local "consul_server" {
  depends_on = ["exec_local.install", "template.consul_config"]
  
  cmd = "${file_dir()}/binaries/consul.exe"
  args = [ 
    "agent",
    "--config-dir",
    "${data("consul/config")}"
  ]

  // Keep the server running in the background.
  daemon = true
}