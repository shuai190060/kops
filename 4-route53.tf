resource "aws_route53_zone" "kops_subdomain" {
  name = "kops.papavonning.com"
  tags = {
    "Name" = "kubernetes cluster zone"
  }

}

resource "aws_route53_zone" "root_domain" {
  name = "papavonning.com"

}




resource "aws_route53_record" "kops_ns" {
  zone_id = aws_route53_zone.root_domain.zone_id
  name    = aws_route53_zone.kops_subdomain.name
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.kops_subdomain.name_servers
}

output "kops_subdomain_nameserver" {
  value = aws_route53_zone.kops_subdomain.name_servers
}



