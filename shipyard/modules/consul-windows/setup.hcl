exec_local "install" {
  cmd = "powershell.exe"
  args = [ 
    "${file_dir()}/scripts/download-binaries.ps1"
  ]

  timeout = "600s"

  working_directory = "${file_dir()}/binaries/"
}