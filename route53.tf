data "aws_route53_zone" "primary" {
  name = "${var.profile}.${var.domain}"
}


resource "aws_route53_record" "new_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = data.aws_route53_zone.primary.name
  type    = "A"
  alias {
    name                   = aws_lb.app-lb.dns_name   
    zone_id                = aws_lb.app-lb.zone_id 
    evaluate_target_health = true
  }
}
