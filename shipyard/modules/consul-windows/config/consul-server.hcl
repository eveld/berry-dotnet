data_dir = "#{{ .Vars.data_dir | js}}"
log_level = "DEBUG"
node_name = "server"

datacenter = "windows"
primary_datacenter = "windows"

server = true

bootstrap_expect = 1

ui_config {
  enabled = true
}

bind_addr = "{{ GetPrivateInterfaces | attr \"address\" }}"
client_addr = "0.0.0.0"

ports {
  grpc = 8502
}

connect {
  enabled = true
}