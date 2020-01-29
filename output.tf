output "install_ready" {
  value = "\nYour installation is complete. It may take several minutes until it is ready.\n\nContinue the installation by visiting:\n\nhttp://${google_compute_instance.circleci-services.network_interface.0.access_config[0].nat_ip}:8800\n\nThank you and enjoy using CircleCI on Google Cloud!"
}
