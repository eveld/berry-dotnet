# Download Consul
$destination = 'consul.exe'
if (Test-Path $destination -PathType leaf)
{
  echo "consul.exe exists, not downloading"
} else {
  $source = 'https://github.com/hashicorp/consul-envoy-windows/releases/download/binaries/consul.exe'
  Invoke-WebRequest -Uri $source -OutFile $destination
}

# Download Envoy
$destination = 'envoy.exe'
if (Test-Path $destination -PathType leaf)
{
  echo "envoy.exe exists, not downloading"
} else {
  $source = 'https://github.com/hashicorp/consul-envoy-windows/releases/download/binaries/envoy.exe'
  Invoke-WebRequest -Uri $source -OutFile $destination
}

# Download fake-service
$destination = 'fake-service.exe'
if (Test-Path $destination -PathType leaf)
{
  echo "fake-service.exe exists, not downloading"
} else {
  $source = 'https://github.com/hashicorp/consul-envoy-windows/releases/download/binaries/fake-service.exe'
  Invoke-WebRequest -Uri $source -OutFile $destination
}