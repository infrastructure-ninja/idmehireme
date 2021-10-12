#############################################################################
###### CREATE DNS ZONE AND NECESSARY RECORDS
#############################################################################

resource "google_dns_managed_zone" "idmehireme" {
  name        = "idmehireme-zone"
  dns_name    = "gcp.idmehire.me."
  description = "ID.me Hire Me!"
  depends_on  = [google_project_service.cloud_dns_api]
}

resource "google_dns_record_set" "a" {
  name         = "prod.${google_dns_managed_zone.idmehireme.dns_name}"
  managed_zone = google_dns_managed_zone.idmehireme.name
  type         = "A"
  ttl          = 60

  rrdatas = [module.lb-http.external_ip]

  depends_on  = [google_project_service.cloud_dns_api]
}


### AWS DNS (subdomain delegation)
data "aws_route53_zone" "idmehireme" {
  name    = "idmehire.me."
}

resource "aws_route53_record" "gcp-ns" {
  zone_id = data.aws_route53_zone.idmehireme.zone_id
  name    = "gcp.idmehire.me"
  type    = "NS"
  ttl     = "60"
  records = google_dns_managed_zone.idmehireme.name_servers
}

resource "aws_route53_record" "go-cname" {
  zone_id = data.aws_route53_zone.idmehireme.zone_id
  name    = "go.idmehire.me"
  type    = "CNAME"
  ttl     = "60"
  records = ["prod.gcp.idmehire.me."]
}
