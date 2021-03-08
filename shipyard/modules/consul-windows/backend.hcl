//
// Generate the Envoy bootstrap.
//
template "backend_bootstrap" {
  source = file("${file_dir()}/config/envoy-bootstrap.json")
  destination = "${data("envoy/config")}/backend.json"

  vars = {
    service_name = "backend"
    service_id = "backend-1"
    envoy_admin_port = 19002
  }
}

//
// Register the service with Consul.
//
template "backend_service" {
  source = <<EOF
service {
  name = "backend"
  id = "backend-1"
  port = 9999

  connect { 
    sidecar_service {
      proxy {
      }
    }
  }
}
EOF
  destination = "${data("consul/config")}/backend.hcl"
}

// Unfortunately this does not work ...
// exec_local "backend-bootstrap" {
//   depends_on = ["exec_local.install"]
  
//   cmd = "${file_dir()}/binaries/consul.exe"
//   args = [
//    "connect", "envoy",
//    "-envoy-binary", "${file_dir()}/binaries/envoy.exe",
//    "-sidecar-for", "backend-1",
//    "-admin-access-log-path", "backend-access.log",
//    "-bootstrap",
//   //  "|", "Out-File", "-FilePath", "${data("envoy/config")}/backend.json"
//   ]

//   // Keep the application running in the background.
//   // daemon = true
//   working_directory = "${file_dir()}"

//   // Set the OS temp folder env var so Envoy can use it internally.
//   env_var = {
//     Temp = env("Temp")
//   }
// }

//
// Run the Envoy sidecar proxy with the config we generated above.
//
exec_local "backend_proxy" {
  depends_on = ["exec_local.install"]
  
  cmd = "${file_dir()}/binaries/envoy.exe"
  args = [
    "-c",
    "${data("envoy/config")}/backend.json",
    "--bootstrap-version",
    "2"
  ]
  daemon = true
  working_directory = "${file_dir()}"

  env_var = {
    Temp = env("Temp")
  }
}

//
// Run the application.
//
exec_local "backend_app" {
  depends_on = ["exec_local.install"]
  
  cmd = "${file_dir()}/binaries/fake-service.exe"
  daemon = true

  env_var = {
    LISTEN_ADDR = "0.0.0.0:9990"
    MESSAGE = "hello from v1"
  }
} 