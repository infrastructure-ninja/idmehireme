# THIS OUR LOAD BALANCER IP ADDRESS
output "instance_ip_addr" {
  value = module.lb-http.external_ip
}

# THIS IS OUR APPLICATION'S INTERNAL IP ADDRESS
output "application_status_url" {
  value = google_cloud_run_service.application.status[0].url
}

# ROUTE53 MUST DELEGATE HERE
output "route53_nameservers" {
  value = google_dns_managed_zone.idmehireme.name_servers
}

